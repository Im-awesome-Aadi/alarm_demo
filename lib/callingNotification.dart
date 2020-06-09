import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void callingNotification(int uniqueID) async {
  print("Ima ");
  print(uniqueID);
  print(uniqueID.runtimeType);
  var schedule = uniqueID.toString().substring(
        4,
      );
  if (schedule == "7") {
    //For Daily Alarm
    print("$uniqueID is called");
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettings = notificationInitializationSettings();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    var platform = notificationSettings();
    await flutterLocalNotificationsPlugin.show(
        0, "New Video is out", "Flutter Local Notification", platform,
        payload: "You have clicked notification");
    AudioPlayer audioPlayer2 = AudioPlayer();
    var audioFilePath =
        "/storage/emulated/0/Android/data/com.aditya25dev.alarm_demo/files/" +
            "${uniqueID.toString()}" +
            ".wav";
    print("I called $audioFilePath");
    await audioPlayer2.play(audioFilePath, isLocal: true);
    final DateTime now = DateTime.now();
    print(
        "[$now] Hello, world! isolate function"); //Checking this section of code is working or not.
  } else {
    schedule.runes.forEach((int rune) async {
      var character = new String.fromCharCode(rune);
      //Checking for selected days for alarm
      if (DateTime.now().weekday == int.parse(character)) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();

        var initializationSettings = notificationInitializationSettings();
        flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
        );

        var platform = notificationSettings();
        await flutterLocalNotificationsPlugin.show(uniqueID, "New Video is out",
            "Flutter Local Notification", platform,
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

NotificationDetails notificationSettings() {
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
    largeIcon: DrawableResourceAndroidBitmap("bvplogo"),
    styleInformation: BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("bvplogo"), //Big Picture Image
    ),
  );
  var ios = IOSNotificationDetails();
  var platform = NotificationDetails(android, ios);
  return platform;
}
