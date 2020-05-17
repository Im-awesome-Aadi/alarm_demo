import 'package:flutter/material.dart';
import 'package:alarm_demo/setAlarm.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
class homes extends StatefulWidget {

  homes({this.alarmtime,this.alarmlabel});
  final alarmtime;
  final alarmlabel;
  @override
  _homesState createState() => _homesState();
}

class _homesState extends State<homes> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('A'),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: widget.alarmtime.length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text('${widget.alarmlabel[index]}',style: TextStyle(color: Colors.black,fontSize: 18),),
                  subtitle: Text('${widget.alarmtime[index]}'),
                );
              })
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder:(_)=> new setAlarm(name: widget.alarmlabel,time: widget.alarmtime,)
              )
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
