import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:alarm_demo/setAlarm.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homes extends StatefulWidget {
  homes({this.alarmtime, this.alarmlabel});
  final alarmtime;
  final alarmlabel;
  @override
  _homesState createState() => _homesState();
}

class _homesState extends State<homes> {
  AudioPlayer audioPlayer1 = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: widget.alarmtime.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    AndroidAlarmManager.cancel(widget.alarmtime[index]);
                    prefs.remove(widget.alarmlabel[index]);
                    widget.alarmlabel.removeAt(index);
                    widget.alarmtime.removeAt(index);
                    setState(() {});
                  }),
              title: Text(
                '${widget.alarmlabel[index]}',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              subtitle: Row(
                children: <Widget>[
                  Text('${widget.alarmtime[index]}'),
                  IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                    ),
                    onPressed: () async {
                      await audioPlayer1.play(
                          "/storage/emulated/0/Android/data/shashankgupta.notificationdemo/files/Ringtones/Closer.mp3",
                          isLocal: true);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.stop,
                    ),
                    onPressed: () async {
                      await audioPlayer1.stop();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => new setAlarm(
                    name: widget.alarmlabel,
                    time: widget.alarmtime,
                  ),
                ),
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
