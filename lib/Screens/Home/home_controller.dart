import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapproject/Services/notification_service.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as date_time_picker;
import '../../Utils/utils.dart';
import '../../Utils/app_strings.dart';

class HomeController extends GetxController {
  Rx<Completer<GoogleMapController>> mapController = Completer<GoogleMapController>().obs;
  Rx<LatLng> center = const LatLng(23.042824, 72.581143).obs;
  late Position currentPosition;

  RxSet<Marker> markers = <Marker>{}.obs;
  final NotificationService _notificationService = NotificationService();
  Timer? _locationTimer;

  Rx<bool> permissionGranted = false.obs;
  Map<String, DateTime> lastNotificationTimes = {};

  var distanceNearBy=100;

  @override
  void onInit() {
    super.onInit();
    _notificationService.initNotification();
    checkLocationPermission();
  }

  @override
  void onClose() {
    _locationTimer?.cancel();
    super.onClose();
  }

  Future<void> checkLocationPermission() async {
    permissionGranted.value = await handleLocationPermission();
    if (permissionGranted.value) {
      getCurrentPosition();
      loadMarkers();
      startLocationTracking();
    }
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint(AppStrings.userDeniedPermission);
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint(AppStrings.userDeniedPermission);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint(AppStrings.userDeniedPermission);
      return false;
    }

    debugPrint(AppStrings.userGrantedPermission);
    return true;
  }

  Future<void> moveToCurrentLocation() async {
    if (!permissionGranted.value) {
      Get.snackbar(
        AppStrings.permissionRequired,
        AppStrings.grantLocationPermission,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final GoogleMapController controller = await mapController.value.future;
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } catch (e) {
      debugPrint('Error moving to current location: $e');
      Get.snackbar(
        AppStrings.error,
        AppStrings.unableToGetLocation,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void requestLocationPermission() async {
    permissionGranted.value = await handleLocationPermission();
    if (permissionGranted.value) {
      getCurrentPosition();
      loadMarkers();
      startLocationTracking();
    } else {
      Geolocator.openLocationSettings();
      Get.snackbar(
        AppStrings.permissionRequired,
        AppStrings.grantLocationPermission,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void startLocationTracking() {
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkProximityToMarkers();
    });
  }

  Future<void> checkProximityToMarkers() async {
    if (!permissionGranted.value) return;

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      for (Marker marker in markers.value) {
        double distanceInMeters = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          marker.position.latitude,
          marker.position.longitude,
        );

        if (distanceInMeters <= distanceNearBy) {
          String markerId = marker.markerId.value;
          DateTime now = DateTime.now();
          if (!lastNotificationTimes.containsKey(markerId) ||
              now.difference(lastNotificationTimes[markerId]!) > const Duration(minutes: 5)) {
            _notificationService.showNotification(
              title: AppStrings.nearbyLocation,
              body: 'You are near ${marker.infoWindow.title}',
            );
            lastNotificationTimes[markerId] = now;
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting current position: $e');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value.complete(controller);
  }

  Future<void> getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;
      center.value = LatLng(currentPosition.latitude, currentPosition.longitude);
      final GoogleMapController controller = await mapController.value.future;
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } catch (e) {
      debugPrint('Error getting current position: $e');
    }
  }

  void onMapLongPress(LatLng position) {
    showMarkerDialog(position, null, null);
  }

  void showMarkerDialog(LatLng position, String? name, String? address) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController addressController = TextEditingController(text: address);
    DateTime? reminderTime;

    Get.dialog(
      AlertDialog(
        title: Text(name == null ? AppStrings.addMarker : AppStrings.editMarker),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name', hintText: AppStrings.nameHint),
              controller: nameController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Address', hintText: AppStrings.addressHint),
              controller: addressController,
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && nameController.text.trim().isNotEmpty) {

                  date_time_picker.DatePicker.showDateTimePicker(
                  Get.context!,
                  showTitleActions: true,
                  onConfirm: (date) {
                    reminderTime = date;
                    Utils.toastMessage("${AppStrings.reminderSet} ${nameController.text}");
                  },
                );}else{
                  Utils.toastMessage(AppStrings.nameCompulsory);
                }
              },
              child: const Text(AppStrings.setReminder),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && nameController.text.trim().isNotEmpty) {
                if (name == null) {
                  addMarker(position, nameController.text, addressController.text, reminderTime);
                } else {
                  updateMarker(position, nameController.text, addressController.text);
                }
                if (reminderTime != null) {
                  _notificationService.scheduleNotification(
                    title: '${AppStrings.reminderFor} ${nameController.text}',
                    body: AppStrings.reminderSetForLocation,
                    scheduledNotificationDateTime: reminderTime!,
                  );
                }
                Get.back();
              } else {
                Utils.toastMessage(AppStrings.nameCompulsory);
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  void addMarker(LatLng position, String name, String address, DateTime? reminderTime) {
    final Marker marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(title: name, snippet: address),
      onTap: () => showMarkerDialog(position, name, address),
    );

    markers.value.add(marker);
    markers.refresh();

    saveMarkers();
  }

  void updateMarker(LatLng position, String newName, String newAddress) {
    markers.value = markers.value.map((marker) {
      if (marker.markerId.value == position.toString()) {
        return marker.copyWith(
          infoWindowParam: InfoWindow(title: newName, snippet: newAddress),
          onTapParam: () => showMarkerDialog(position, newName, newAddress),
        );
      }
      return marker;
    }).toSet();
    markers.refresh();
    saveMarkers();
  }

  Future<void> saveMarkers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> markerList = markers.value
        .map((marker) => jsonEncode({
      'lat': marker.position.latitude,
      'lng': marker.position.longitude,
      'name': marker.infoWindow.title,
      'address': marker.infoWindow.snippet,
    }))
        .toList();
    await prefs.setStringList('markers', markerList);
  }

  Future<void> loadMarkers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? markerList = prefs.getStringList('markers');
    if (markerList != null) {
      for (String markerString in markerList) {
        Map<String, dynamic> markerMap = jsonDecode(markerString);
        LatLng position = LatLng(markerMap['lat'], markerMap['lng']);
        addMarker(
          position,
          markerMap['name'],
          markerMap['address'],
          null,
        );
      }
    }
  }
}
