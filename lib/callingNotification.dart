<<<<<<< HEAD
/*
=======
>>>>>>> origin/master
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
<<<<<<< HEAD
import 'package:alarm_demo/systemSpecificPaths.dart';
void callingNotification(int uniqueID) async {

    //For Daily Alarm

    print("$uniqueID is called");
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettings =  notificationInitializationSettings();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    var platform =  await notificationSettings();
    await flutterLocalNotificationsPlugin.show(
        0, "Fitness traker", "gh", platform,
        payload: "You have clicked notification");


}

InitializationSettings notificationInitializationSettings() {
  var androids = AndroidInitializationSettings('bvplogo'); //Notification Icon
  var iOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(androids, iOS);
  return initializationSettings;
}

Future  notificationSettings() async{

  var android = AndroidNotificationDetails(
    "channelID",
    "channelName",
    "channelDescription",
    playSound: true,
    enableLights: true,
    enableVibration: true,
    color: Colors.green,
    importance: Importance.Max,
    priority: Priority.High,

  );
  var ios = IOSNotificationDetails();
  var platform = NotificationDetails(android, ios);
  return platform;
}
*/


import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:alarm_demo/systemSpecificPaths.dart';
=======
>>>>>>> origin/master
void callingNotification(int uniqueID) async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString(uniqueID.toString());
  var temp = json.decode(value);
  print("Ima ");
  prefs.setString("demo", "12347");
  print(uniqueID);
  print(uniqueID.runtimeType);
  var schedule = uniqueID.toString().substring(
        4,
      );
  if (schedule == "7") {
    //For Daily Alarm
    print(schedule);
    print("$uniqueID is called");
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettings =  notificationInitializationSettings();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    var platform = await notificationSettings(temp["image"]);
    await flutterLocalNotificationsPlugin.show(
        0, "Fitness traker", "${temp["label"]}", platform,
        payload: "You have clicked notification");
    AudioPlayer audioPlayer2 = AudioPlayer();
    Directory appDocDirectory;
    appDocDirectory = await systemSpecificFilePath();
    var audioFilePath =
        appDocDirectory.path +
            "/${uniqueID.toString()}" +
            ".wav";
    print("I called $audioFilePath");
    await audioPlayer2.play(audioFilePath, isLocal: true);
    final DateTime now = DateTime.now();
  } 
  // This condtion is not used now. Ignore it for a while
  else {
    print(schedule);
    print("not laone");
    schedule.runes.forEach((int rune) async {
      var character = new String.fromCharCode(rune);
      //Checking for selected days for alarm
      if (DateTime.now().weekday == int.parse(character)) {
        print(character);
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();

        var initializationSettings = notificationInitializationSettings();
        flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
        );

        var platform = await notificationSettings(temp["image"]);
        await flutterLocalNotificationsPlugin.show(
            0, "Fitness traker", "${temp["label"]}", platform,
            payload: "You have clicked notification");
        AudioPlayer audioPlayer2 = AudioPlayer();
        var audioFilePath =
            "/storage/emulated/0/Android/data/com.aditya25dev.alarm_demo/files/" +
                "${uniqueID.toString()}" +
                ".wav";
        print("I called $audioFilePath");
        await audioPlayer2.play(
          audioFilePath,
          isLocal: true,
        ); //To play Audio in Notification
        final DateTime now = DateTime.now();
        print("[$now] Hello, world! isolate function");
      }
      // print(character);
    });
  }
}

InitializationSettings notificationInitializationSettings() {
  var androids = AndroidInitializationSettings('bvplogo'); //Notification Icon
  var iOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(androids, iOS);
  return initializationSettings;
}

Future  notificationSettings(img) async{

  var android = AndroidNotificationDetails(
    "channelID",
    "channelName",
    "channelDescription",
    playSound: true,
    enableLights: true,
    enableVibration: true,
    color: Colors.green,
    importance: Importance.Max,
    priority: Priority.High,
    largeIcon: FilePathAndroidBitmap(img),
    styleInformation: BigPictureStyleInformation(
      FilePathAndroidBitmap(img), //Big Picture Image
    ),
  );
  var ios = IOSNotificationDetails();
  var platform = NotificationDetails(android, ios);
  return platform;
}

