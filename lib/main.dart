import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alarm_demo/homescreen.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
void main() => runApp(MyApp());
void printHello() async {
  print("Ima ");
  final DateTime now = DateTime.now();
  print("[$now] Hello, world! isolate function");
}
/*void main() async{
  final int helloAlarmID = 0;
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
}*/

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List alarmtime = [];
  List alarmlabel = [];

  void initState() {
    super.initState();
    initial();
  }

  initial() async {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.speech,

    ].request();
    final prefs = await SharedPreferences.getInstance();
    final prefKeys = prefs.getKeys();
    if (prefKeys.isEmpty) {
      print("NO alram");
    }
    if (prefKeys.isNotEmpty) {
      for (String i in prefKeys) {
        final value = prefs.getString(i);
        var info=json.decode(value);
        alarmlabel.add(info['label']);
        alarmtime.add(i);

        print(i);
        print(value);
      }
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => new Homes(alarmtime: alarmtime, alarmlabel: alarmlabel),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    print("Build is called");
    return Container(
      color: Colors.blue,
    );
  }
}
