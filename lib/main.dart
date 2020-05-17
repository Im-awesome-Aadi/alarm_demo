import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alarm_demo/setAlarm.dart';
import 'package:alarm_demo/homescreen.dart';
void main() => runApp(MyApp());
void printHello() async{
  print("Ima ");
  final DateTime now = DateTime.now();
  await print("[$now] Hello, world! isolate function");
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
    List alarmtime=[];
    List alarmlabel=[];

    void initState() {
      super.initState();
       initial();
    }

      initial() async{
        final prefs = await SharedPreferences.getInstance();
        final prefKeys = await prefs.getKeys();
        if(prefKeys.isEmpty){
          print("NO alram");
        }
        if(prefKeys.isNotEmpty){
          for (String i in prefKeys){
            final value = await prefs.getInt(i);
           await alarmlabel.add(i);
            await alarmtime.add(value);

            print(i);
            print(value);
          }
        }
        Navigator.of(context).push(
            MaterialPageRoute(
                builder:(_)=> new homes(alarmtime:alarmtime, alarmlabel:alarmlabel)
            )
        );
      }
  void _incrementCounter() async{
    print("i st");
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.oneShotAt(new DateTime(0,0,0,0,5,0,0), 0, await printHello);

  }

  @override
  Widget build(BuildContext context) {
      print("Build is called");
    return Container(
      color: Colors.blue,
    );
  }
}
