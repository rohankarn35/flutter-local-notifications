import 'package:flutter/material.dart';
import 'package:flutter_local_notification/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void shownotification() async {
    final AndroidFlutterLocalNotificationsPlugin? androidNotificationsPlugin =
        notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    if (androidNotificationsPlugin != null) {
      final bool? hasPermission =
          await androidNotificationsPlugin.requestNotificationsPermission();

      if (hasPermission == null || !hasPermission) {
        // Permissions not granted, navigate to app settings
        openAppSettings();
      } else {
        AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          "notificationtest",
          "My Notification",
          priority: Priority.max,
          importance: Importance.max,
        );
        NotificationDetails notificationDetails = NotificationDetails(
          android: androidDetails,
        );
        DateTime scheduledtime = DateTime.now().add(Duration(seconds: 5));
        await notificationsPlugin.zonedSchedule(
          0,
          "Class Remainder",
          "Class Jao Salo",
          TZDateTime.from(scheduledtime,local),
          notificationDetails,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
         
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notification_add),
        onPressed: shownotification,
      ),
    );
  }
}
