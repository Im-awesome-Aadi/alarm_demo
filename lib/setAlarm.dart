import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class setAlarm extends StatefulWidget {

  setAlarm({this.name,this.time});
  final name;
  final time;
  @override
  _setAlarmState createState() => _setAlarmState();
}

class _setAlarmState extends State<setAlarm> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


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
  void setTimer(time) async{
    print("i st");
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.oneShot(new Duration(seconds: time) , 0, await printHello);

  }
  TextEditingController label=TextEditingController();
  TextEditingController hour=TextEditingController();
  TextEditingController minute=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('SET ALARM'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 25,),
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
                hintText: 'Enter Label'
            ),
          ),
          SizedBox(height: 25,),
          TextField(
            controller: hour,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: 'Enter Hour'
            ),
          ),
          SizedBox(height: 25,),
          TextField(
            controller: minute,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: 'Enter Minute'
            ),
          ),
          SizedBox(height: 25,),

          FlatButton(
            onPressed: (){

//int.parse(hour.text)*3600 + int.parse(minute.text)*60
              setTimer(12);
              addAlarm(label.text, int.parse(hour.text+minute.text));
              Navigator.of(context).pop();
            },
            child: Container(
              child: Text('Save'),
            ),
          )

        ],
      ),
    );
  }
  addAlarm(key,value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);

    setState(() {
      widget.name.add(key);
      widget.time.add(value);
    });



  }

}
void printHello() async{
  print("Ima ");
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var android = AndroidNotificationDetails(
      "channelID", "channelName", "channelDescription");
  var ios = IOSNotificationDetails();
  var platform = NotificationDetails(android, ios);
  var notification = await flutterLocalNotificationsPlugin.show(
      0, "New Video is out", "Flutter Local Notification", platform,
      payload: "X items");
  var androids = AndroidInitializationSettings('bvplogo');
  var iOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(androids, iOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
   );
  final DateTime now = DateTime.now();
  await print("[$now] Hello, world! isolate function");
}