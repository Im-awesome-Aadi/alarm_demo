import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'callingNotification.dart';


var filename =
    '/alarm_${DateTime.now().hour.toString() + DateTime.now().minute.toString()}';

class SetAlarm extends StatefulWidget {
  SetAlarm({this.name, this.time});
  final name;
  final time;
  @override
  _SetAlarmState createState() => _SetAlarmState();
}

class _SetAlarmState extends State<SetAlarm> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  var weekdays = [1, 1, 1, 1, 1, 1, 1];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //   initRecorder();
  }

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
    int id = int.parse(
        (givenAlarmTime.hour * 100 + givenAlarmTime.minute).toString() +
            conv(weekdays));
    print(id);
    print(id.bitLength);

    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(
      new Duration(hours: 24
//        seconds: givenTime.difference(DateTime.now()).inSeconds,
          ),
      id,
      callingNotification,
      startAt: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, givenTime.hour, givenTime.minute, 0, 0, 0),
    );
  }

  TextEditingController label = TextEditingController();
  DateFormat format = DateFormat("HH:mm");
  DateTime givenAlarmTime = DateTime.now();

  int isPlay;
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('SET ALARM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
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
              height: 20,
            ),

            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            givenAlarmTime ?? DateTime.now()),
                      );
                      setState(
                        () {
                          givenAlarmTime =
                              DateTimeField.combine(DateTime.now(), time);

                          isClicked = true;
                        },
                      );
                    },
                    child: Text("Set Alarm"),
                  ),
                  Text("${givenAlarmTime.hour} : ${givenAlarmTime.minute}"),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),

            SizedBox(
              height: 5,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text("Select Days"),
                  children: <Widget>[
                    CheckboxListTile(
                      title: Text("Sunday"),
                      value: weekdays[0] == 1 ? true : false,
                      onChanged: (isTrue) {
                        setState(
                          () {
                            weekdays[0] = isTrue ? 1 : 0;
                          },
                        );
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Monday"),
                      value: weekdays[1] == 1 ? true : false,
                      onChanged: (isTrue) {
                        setState(
                          () {
                            weekdays[1] = isTrue ? 1 : 0;
                          },
                        );
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Tuesday"),
                      value: weekdays[2] == 1 ? true : false,
                      onChanged: (isTrue) {
                        setState(
                          () {
                            weekdays[2] = isTrue ? 1 : 0;
                          },
                        );
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Wednesday"),
                      value: weekdays[3] == 1 ? true : false,
                      onChanged: (isTrue) {
                        setState(
                          () {
                            weekdays[3] = isTrue ? 1 : 0;
                          },
                        );
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Thursday"),
                      value: weekdays[4] == 1 ? true : false,
                      onChanged: (isTrue) {
                        setState(
                          () {
                            weekdays[4] = isTrue ? 1 : 0;
                          },
                        );
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Friday"),
                      value: weekdays[5] == 1 ? true : false,
                      onChanged: (isTrue) {
                        setState(
                          () {
                            weekdays[5] = isTrue ? 1 : 0;
                          },
                        );
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Saturday"),
                      value: weekdays[6] == 1 ? true : false,
                      onChanged: (isTrue) {
                        setState(
                          () {
                            weekdays[6] = isTrue ? 1 : 0;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: isClicked ? Colors.blue : Colors.grey[300],
                    child: IconButton(
                      disabledColor: Colors.grey,
                      color: Colors.white,
                      icon: Icon(Icons.mic),
                      onPressed: isClicked
                          ? () async {
                              String aa = conv(weekdays);
                              String customPath =
                                  '/${givenAlarmTime.hour.toString() + givenAlarmTime.minute.toString()}' +
                                      aa;
                              Directory appDocDirectory;
                              if (Platform.isIOS) {
                                appDocDirectory =
                                    await getApplicationDocumentsDirectory();
                              } else {
                                appDocDirectory =
                                    await getExternalStorageDirectory();
                              }

                              customPath = appDocDirectory.path + customPath;
                              print("Custom path is ${customPath}");
                              _recorder = FlutterAudioRecorder(customPath,
                                  audioFormat: AudioFormat.WAV);

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

                              var recording =
                                  await _recorder.current(channel: 0);
                              print(recording.status);
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Recording Started"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      CircleAvatar(
                                        child: IconButton(
                                          icon: Icon(Icons.pause),
                                          onPressed: () async {
                                            _recorder.stop();
                                            var recording = await _recorder
                                                .current(channel: 0);
                                            print(recording.status);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 26,
                                      ),
                                      Text("Click Here to Stop"),
                                    ],
                                  ),
                                ),
                              );
                              print("AlartBox Out");
                            }
                          : null,
                    ),
                  ),
                  Text(
                    "Click to Record",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () async {
                if (label.text != "") {
                  setTimer(givenAlarmTime);
                  await addAlarm(
                      label.text,
                      int.parse(
                          (givenAlarmTime.hour * 100 + givenAlarmTime.minute)
                                  .toString() +
                              conv(weekdays)));
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

conv(input) {
  print('converting it');
  String output = "";

  for (int i = 0; i < input.length; i++) {
    if (input[i] == 1) {
      output = output + i.toString();
    }
  }
  if (output == "0123456") {
    return "7";
  } else {
    return output;
  }
}
