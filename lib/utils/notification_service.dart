import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notifier =
    FlutterLocalNotificationsPlugin();
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> initNotify() async {
  // Load the full timezone database
  tz.initializeTimeZones();

  // Ask flutter_timezone for the device’s current zone name
  final String name = await FlutterTimezone.getLocalTimezone();

  //Tell `timezone` to use that zone
  tz.setLocalLocation(tz.getLocation(name));

  // Initialize flutter_local_notifications
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();

  await notifier.initialize(
    const InitializationSettings(
      android: android,
      iOS: ios,
    ),
    onDidReceiveNotificationResponse: (response) {
      // handle tapped notification here
      final payload = jsonDecode(response.payload ?? '{}');
      Get.toNamed(payload['route'], arguments: payload['id']);
    },
  );

  // Request Android 13+ permission
  await notifier
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // Request iOS permissions
  await notifier
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

/// Schedules either a one-off reminder at [hour]:[minute], or (with
/// `matchDateTimeComponents`) a daily reminder at that time.
Future<void> scheduledOnTime({
  required int id,
  required String title,
  required String body,
  required int hour,
  required int minute,
  String? route,
  bool daily = false,
}) async {
  // 1️⃣ Compute the next instance of that time in the local zone
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(
    tz.local,
    now.year, // <-- use now.year
    now.month, // <-- use now.month
    now.day,
    hour,
    minute,
  );
  if (scheduled.isBefore(now)) {
    // bump to tomorrow
    scheduled = scheduled.add(const Duration(days: 1));
  }

  // 2️⃣ Build your details
  const androidDetails = AndroidNotificationDetails(
    'reminder_channel',
    'Reminders',
    channelDescription: 'Event reminders',
    importance: Importance.max,
    priority: Priority.high,
  );
  const iosDetails = DarwinNotificationDetails();
  const notifDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  // 3️⃣ Actually schedule
  await notifier.zonedSchedule(id, title, body, scheduled, notifDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      // if you want it to repeat daily at that time:
      matchDateTimeComponents: daily ? DateTimeComponents.time : null,
      payload: jsonEncode({'route': route, 'id': id}));
}

Future<void> scheduledAt({
  required int id,
  required String title,
  required String body,
  required DateTime at,
  String? route,
  bool daily = false,
}) async {
  // // Convert your DateTime into a TZDateTime in the local zone
  var scheduled = tz.TZDateTime.from(at, tz.local);
  final now = tz.TZDateTime.now(tz.local);

  if (scheduled.isBefore(now)) {
    // bump to tomorrow
    scheduled = scheduled.add(const Duration(days: 1));
  }

  const androidDetails = AndroidNotificationDetails(
    'reminder_channel',
    'Reminders',
    channelDescription: 'Event reminders',
    importance: Importance.max,
    priority: Priority.high,
  );
  const iosDetails = DarwinNotificationDetails();
  const notifDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await notifier.zonedSchedule(
    id, title, body, scheduled, notifDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    // if you want it to repeat daily at that time:
    matchDateTimeComponents: daily ? DateTimeComponents.time : null,
    payload: jsonEncode({'route': route, 'id': id}),
  );
}

Future<void> scheduledRemind({
  required int id,
  required String title,
  required String body,
  required int remind,
  String? route,
  bool daily = false,
}) async {
  // // Convert your DateTime into a TZDateTime in the local zone
  final scheduled = tz.TZDateTime.now(tz.local).add(Duration(minutes: remind));

  const androidDetails = AndroidNotificationDetails(
    'reminder_channel',
    'Reminders',
    channelDescription: 'Event reminders',
    importance: Importance.max,
    priority: Priority.high,
  );
  const iosDetails = DarwinNotificationDetails();
  const notifDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await notifier.zonedSchedule(
    id, title, body, scheduled, notifDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    // if you want it to repeat daily at that time:
    matchDateTimeComponents: daily ? DateTimeComponents.time : null,
    payload: jsonEncode({'route': route, 'id': id}),
  );
}

Future<void> showSimpleNotification({
  int? id,
  String? title,
  String? body,
  String? route,
}) async {
  const androidDetails = AndroidNotificationDetails(
    'test_channel', // channel id
    'Test Notifications', // channel name
    channelDescription: 'Used for testing simple local notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    // ✔️ You can set a custom small icon if needed:
    // smallIcon: 'ic_notification',
  );
  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  const platformDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await notifier.show(
    id ?? 0,
    title ?? 'Hello!',
    body ?? 'This is a test notification.',
    platformDetails,
    payload: jsonEncode({'route': route, 'id': id}),
  );
}
