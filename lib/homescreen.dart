import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notification/main.dart';
import 'package:flutter_local_notification/timeservice.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final jsondata = {
    "MON": [
      {"subject": "CC", "time": "14:30-15", "roomNo": "B-306"},
      {"subject": "ML(DE)", "time": "15:01", "roomNo": "B-204"},
      {"subject": "SPM", "time": "15:02-4", "roomNo": "A-LH-009"},
      {"subject": "CC(L)", "time": "15:11-6", "roomNo": "WL-103"}
    ],
  };

  Timeservice timeservice = Timeservice();

void shownotification() async {
  final AndroidFlutterLocalNotificationsPlugin? androidNotificationsPlugin =
      notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidNotificationsPlugin != null) {
    final bool? hasPermission =
        await androidNotificationsPlugin.requestNotificationsPermission();

    if (hasPermission == null || !hasPermission) {
      // Permissions not granted, handle accordingly (e.g., show a message to the user)
      print('Notification permissions not granted.');
    } else {
      // Permissions granted, proceed with scheduling notification
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        "notificationtest",
        "My Notification",
        priority: Priority.max,
        importance: Importance.max,
      );
      NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );
      String? timeofday = "";
      for(int i = 0; i<jsondata["MON"]!.length; i++){
          timeofday = jsondata["MON"]?[i]["time"];
                List<int> mytime = timeservice.parseTime(timeofday!);
      int startHour = mytime[0];
      int startMinutes = mytime[1];
     print("Strinf"+timeofday);
     print(startHour.toString()+ "hello"+ startMinutes.toString());

      DateTime now = DateTime.now();
      DateTime scheduledtime = DateTime(
        now.year,
        now.month,
        now.day,
        startHour,
        startMinutes,
      );
      String? classname  = jsondata["MON"]![i]["subject"];
      String? roomnoname = jsondata["MON"]![i]["roomNo"];


      if (scheduledtime.isAfter(now)) {
        print("NOtification added from ${startHour.toString()}-${startMinutes.toString()}");
         await notificationsPlugin.zonedSchedule(
        i,
        "${classname} in ${roomnoname}",
        "Join the class asap",
        TZDateTime.from(scheduledtime, local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
      );
      }else{
        print("NOtifications are skipped");
      }

     
         
      }
     


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
