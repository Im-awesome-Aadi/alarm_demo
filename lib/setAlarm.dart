import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:async';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';


var filename='/alarm_${DateTime.now().hour.toString()+DateTime.now().minute.toString()}';
class setAlarm extends StatefulWidget {
  setAlarm({this.name, this.time});
  final name;
  final time;
  @override
  _setAlarmState createState() => _setAlarmState();
}

class _setAlarmState extends State<setAlarm> {
//  AudioPlayer audioPlayer = AudioPlayer();

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  var weekdays=[1,1,1,1,1,1,1];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 //   initRecorder();

  }

  /*Future<String> platformPath() async {
    String customPath = '/flutter_audio_aditya';
    Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path + customPath;
    print(customPath);
    return customPath;
  }

  initRecorder() async {
    String customPath = await platformPath();

    _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

    await _recorder.initialized;
    // after initialization
    var current = await _recorder.current(channel: 0);
    print(current);
    // should be "Initialized", if all working fine
    setState(() {
      _current = current;
      _currentStatus = current.status;
      print(_currentStatus);
    });
  }*/

  Future onSelectNotification(String payload) async {
    debugPrint("payload:$payload");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Payload"),
        content: Text("$payload"),
      ),
    );
  }

  void setTimer(DateTime givenTime) async {

    print(givenTime.difference(DateTime.now()));
    int id=int.parse((givenAlarmTime.hour * 100 + givenAlarmTime.minute).toString() + conv(weekdays));
    print(id);
    print(id.bitLength);

    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(
        new Duration(hours: 24
//        seconds: givenTime.difference(DateTime.now()).inSeconds,
        ),
        id,
        printHello,
        startAt: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, givenTime.hour, givenTime.minute, 0, 0, 0));
  }

  TextEditingController label = TextEditingController();
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
  DateTime givenAlarmTime = DateTime.now();

  int isPlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('SET ALARM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: label,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Enter Label'),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: DateTimeField(
                format: format,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    setState(() {
                      givenAlarmTime = DateTimeField.combine(date, time);
                    });

                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () async {
                String aa=conv(weekdays);
                String customPath = '/${givenAlarmTime.hour.toString()+givenAlarmTime.minute.toString()}'+aa;
                Directory appDocDirectory;
                if (Platform.isIOS) {
                  appDocDirectory = await getApplicationDocumentsDirectory();
                } else {
                  appDocDirectory = await getExternalStorageDirectory();
                }

                customPath = appDocDirectory.path + customPath;
                print("Custom path is ${customPath}");
                _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

                await _recorder.initialized;
                // after initialization
                var current = await _recorder.current(channel: 0);
                print(current);
                // should be "Initialized", if all working fine
                setState(() {
                  _current = current;
                  _currentStatus = current.status;
                  print(_currentStatus);
                });
                _recorder.start();
                await SimplePermissions.requestPermission(Permission.RecordAudio);
                var recording = await _recorder.current(channel: 0);
                print(recording.status);
              },
            ),
            IconButton(
              icon: Icon(Icons.pause),
              onPressed: () async {
                _recorder.stop();
                var recording = await _recorder.current(channel: 0);
                print(recording.status);
              },
            ),
//            RaisedButton(
//              child: Text("Play Recorded"),
//              onPressed: () async {
//                String path = await platformPath();
//                isPlay = await audioPlayer.play(
//                    "/storage/emulated/0/Android/data/com.aditya25dev.alarm_demo/files/flutter_audio_recorder_shashank4.wav",
//                    isLocal: true);
//                print(isPlay);
//              },
//            ),
//            RaisedButton(
//              child: Text("Stop Recorded"),
//              onPressed: () async {
//                isPlay = await audioPlayer.stop();
//                print(isPlay);
//              },
//            ),
            SizedBox(
              height: 25,
            ),
            FlatButton(
              onPressed: () async {
                if (label.text != "") {
                  setTimer(givenAlarmTime);
                  await addAlarm(
                      label.text, int.parse(
                      (givenAlarmTime.hour * 100 + givenAlarmTime.minute).toString() + conv(weekdays)
                  )
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                child: Text('Save'),
              ),
            ),
//            Text("$currentTime"),
          ],
        ),
      ),
    );
  }

  addAlarm(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);

    setState(() {
      widget.name.add(key);
      widget.time.add(value);
    });
  }
}

void printHello(int a ) async {
  print("Ima ");
  print(a);
  print(a.runtimeType);
  var schedule=a.toString().substring(3,);
  if(schedule=="7"){

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var androids = AndroidInitializationSettings('bvplogo');
    var iOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(androids, iOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    var android = AndroidNotificationDetails(
      "channelID",
      "channelName",
      "channelDescription",
      playSound: true,
      enableLights: true,
      enableVibration: true,
    );
    var ios = await IOSNotificationDetails();
    var platform = await NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(
        0, "New Video is out", "Flutter Local Notification", platform,
        payload: "You have clicked notification");
    AudioPlayer audioPlayer2 = AudioPlayer();
    var p ="/storage/emulated/0/Android/data/com.aditya25dev.alarm_demo/files/" +"${a.toString()}" + ".wav";
    print("I called $p");
    await audioPlayer2.play(
        p,
        isLocal: true);
    final DateTime now = DateTime.now();
    await print("[$now] Hello, world! isolate function");
  }
  else{
    schedule.runes.forEach((int rune)  async{
      var character = new String.fromCharCode(rune);
      if(DateTime.now().weekday==int.parse(character)){

        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
        var androids = AndroidInitializationSettings('bvplogo');
        var iOS = IOSInitializationSettings();
        var initializationSettings = InitializationSettings(androids, iOS);
        flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
        );

        var android = AndroidNotificationDetails(
          "channelID",
          "channelName",
          "channelDescription",
          playSound: true,
          enableLights: true,
          enableVibration: true,
        );
        var ios = await IOSNotificationDetails();
        var platform = await NotificationDetails(android, ios);
        await flutterLocalNotificationsPlugin.show(
            0, "New Video is out", "Flutter Local Notification", platform,
            payload: "You have clicked notification");
        AudioPlayer audioPlayer2 = AudioPlayer();
        var p ="/storage/emulated/0/Android/data/com.aditya25dev.alarm_demo/files/" +"${a.toString()}" + ".wav";
        print("I called $p");
        await audioPlayer2.play(
            p,
            isLocal: true);
        final DateTime now = DateTime.now();
        await print("[$now] Hello, world! isolate function");
      }
      // print(character);
    });
  }
}


 conv(input){
  print('converting it');
  String output="";

  for(int i =0;i<input.length;i++){
    if(input[i]==1)
    {
      output=output+ i.toString();
    }
  }
  if(output=="0123456"){
    return "7";
  }
  else{
    return output;
  }
}