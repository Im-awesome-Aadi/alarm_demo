import 'package:flutter/material.dart';
import 'package:alarm_demo/setAlarm.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homes extends StatefulWidget {
  Homes({this.alarmtime, this.alarmlabel,this.temp});
  final alarmtime;
  final alarmlabel;
  final temp;

  @override
  _HomesState createState() => _HomesState();
}

class _HomesState extends State<Homes> {
//  AudioPlayer audioPlayer1 = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Notifications'),
      ),

      body: Column(
        children: <Widget>[
          Text('${widget.temp}'),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 500),
              child: ListView.builder(
                itemCount: widget.alarmlabel.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    leading: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          AndroidAlarmManager.cancel(int.parse(widget.alarmtime[index]));
                          prefs.remove(widget.alarmtime[index]);
                          widget.alarmlabel.removeAt(index);
                          widget.alarmtime.removeAt(index);
                          setState(() {});
                        }),
                    title: Text(
                      widget.alarmlabel[index].toString(),
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    subtitle: Text("Time " +
                        widget.alarmtime[index].substring(0, 2) +
                        ":" +
                        "${widget.alarmtime[index].substring(2, 4)}"),
                    children: dayList(widget.alarmtime[index].substring(
                      4,
                    )),
                  );
                },
              ),
            ),
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
                () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => new SetAlarm(
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

  List<ListTile> dayList(String substring) {
    List<ListTile> days = [];
    print(substring);
    if (substring == "7") {
      return [
        ListTile(
          title: Text("Daily"),
        )
      ];
    } else {
      if (substring.contains("0")) {
        days.add(
          ListTile(
            title: Text("Sunday"),
          ),
        );
      }
      if (substring.contains("1")) {
        days.add(
          ListTile(
            title: Text("Monday"),
          ),
        );
      }
      if (substring.contains("2")) {
        days.add(
          ListTile(
            title: Text("Tuesday"),
          ),
        );
      }
      if (substring.contains("3")) {
        days.add(
          ListTile(
            title: Text("Wednesday"),
          ),
        );
      }
      if (substring.contains("4")) {
        days.add(
          ListTile(
            title: Text("Thursday"),
          ),
        );
      }
      if (substring.contains("5")) {
        days.add(
          ListTile(
            title: Text("Friday"),
          ),
        );
      }
      if (substring.contains("6")) {
        days.add(
          ListTile(
            title: Text("Saturday"),
          ),
        );
      } else {
        return [
          ListTile(
            title: Text("Not Specified"),
          )
        ];
      }
      return days;
    }
  }
}
