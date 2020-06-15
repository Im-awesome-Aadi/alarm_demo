import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'callingNotification.dart';
import 'systemSpecificPaths.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SetAlarm extends StatefulWidget {
  SetAlarm({this.name, this.time});
  final name;
  final time;
  @override
  _SetAlarmState createState() => _SetAlarmState();
}

class _SetAlarmState extends State<SetAlarm> {
  Directory appDocDirectory;
  TextEditingController label = TextEditingController();
  DateFormat format = DateFormat("HH:mm");
  DateTime givenAlarmTime = DateTime.now();

  FlutterAudioRecorder _recorder;
  Recording _current;
  var imageLocation;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  var weekdays = [1, 1, 1, 1, 1, 1, 1];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //   initRecorder();
  }
  var _image;
  final picker = ImagePicker();
  Future getGalleryImage() async {

      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        _image = (File(pickedFile.path));
      });


    Directory  appDocDirectory;
    appDocDirectory = await getExternalStorageDirectory();
    imageLocation= appDocDirectory.path + '/Pictures/' +  DateTime.now().toIso8601String() +'.jpg';
    print(imageLocation);
    await _image.copy(imageLocation);
    print(_image);
  }
  Future getCameraImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = (File(pickedFile.path));
    });


    Directory appDocDirectory;
    appDocDirectory = await getExternalStorageDirectory();
    imageLocation =
        appDocDirectory.path + '/Pictures/' + DateTime.now().toIso8601String() +
            '.jpg';
    print(imageLocation);
    await _image.copy(imageLocation);
    print(_image);
  }
  void setTimer(DateTime givenTime) async {
    print(givenTime.difference(DateTime.now()));
    int id = int.parse(
        '${givenAlarmTime.hour.toString().padLeft(2,'0') + givenAlarmTime.minute.toString().padLeft(2,'0')}' + conv(weekdays)
    );

    print(givenTime.hour);
    print(givenTime.minute);

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

var alramlabel;
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
              onChanged: (input){

                alramlabel=input;
                setState(() {

                });
                print(alramlabel);
              },
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
                        String customPath =
                            '/${givenAlarmTime.hour.toString().padLeft(2,'0') + givenAlarmTime.minute.toString().padLeft(2,'0')}' +
                                conv(weekdays);

                        appDocDirectory = await systemSpecificFilePath();
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
                                    icon: Icon(Icons.stop),
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
            RaisedButton(
              onPressed: () async{
                  await getGalleryImage();
              },
              child: Text("Gallery"),
            ),
            SizedBox(
              height: 12,
            ),
            RaisedButton(
              onPressed: () async{
                await getCameraImage();
              },
              child: Text("Camera"),
            ),
            Container(
              height: 50,
              child: _image==null?SizedBox.shrink():Image.file( _image,),
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () async {
                var info="""
                {  "label" : "${alramlabel}",
                  "image" : "${imageLocation}"
                 }
                """;
                print(info);
                if (label.text != "") {
                  setTimer(givenAlarmTime);
                   addAlarm(
                      '${givenAlarmTime.hour.toString().padLeft(2,'0') + givenAlarmTime.minute.toString().padLeft(2,'0')}' + conv(weekdays)
                      , info);
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
    var temp =json.decode(value);
    print(value);
   print(temp);
   setState(() {
      widget.name.add('${temp["label"]}');
      widget.time.add(key);
    });
    prefs.setString(key, value);

  }
}

conv(input) {
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
