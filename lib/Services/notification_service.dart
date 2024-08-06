import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {},
    );
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({int id = 0, String? title, String? body, String? payLoad}) async {
    await notificationsPlugin.show(id, title, body, _notificationDetails());
  }

  Future<void> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledNotificationDateTime,
  }) async {
    final timeFormat = DateFormat('h:mm a');
    final formattedTime = timeFormat.format(scheduledNotificationDateTime);
    final updatedBody = '${body ?? ''}\nTime: $formattedTime';
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      updatedBody,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}