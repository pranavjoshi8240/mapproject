import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'Screens/Home/main_home_page.dart';
import 'app_route.dart';
import 'services/notification_service.dart';
import '../../Utils/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServices();
  runApp(const MyApp());
}

Future<void> initializeServices() async {
  await NotificationService().initNotification();
  tz.initializeTimeZones();
  await handleNotificationPermission();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: false,
      ),
      getPages: AppRoutes.routes,
      initialRoute: HomeScreen.routeName,
    );
  }
}

Future<void> handleNotificationPermission() async {
  const permission = Permission.notification;
  final status = await permission.status;
  if (status.isGranted) {
    print(AppStrings.userGrantedPermission);
  } else {
    final before = await permission.shouldShowRequestRationale;
    final rs = await permission.request();
    final after = await permission.shouldShowRequestRationale;
    if (rs.isGranted) {
      print(AppStrings.userGrantedPermission);
    } else if (!before && after) {
      print(AppStrings.userDeniedPermission);
    } else if (before && !after) {
      print(AppStrings.userDeniedPermission);
    } else if (!before && !after) {
      print(AppStrings.userDeniedPermission);
    }
  }
}
