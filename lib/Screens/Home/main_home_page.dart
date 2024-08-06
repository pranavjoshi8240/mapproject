import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Utils/app_strings.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  static const String routeName = "/homeScreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.taskName),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.permissionGranted.value
            ? Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    onMapCreated: controller.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: controller.center.value,
                      zoom: 12,
                    ),
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    markers: controller.markers.value.toSet(),
                    onLongPress: controller.onMapLongPress,
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      onPressed: controller.moveToCurrentLocation,
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppStrings.locationPermissionRequired),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.requestLocationPermission(),
                      child: const Text(AppStrings.grantPermission),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
