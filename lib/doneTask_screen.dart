import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'tasks_screen.dart';

class DoneTaskScreen extends StatefulWidget {
  final Color mainBackgroundColor;
  final Color mainTextColor;
  final String mainColor;
  DoneTaskScreen(
      {Key key,
        @required this.mainBackgroundColor,
        this.mainColor,
        this.mainTextColor})
      : super(key: key);
  @override
  _DoneTaskScreenState createState() => _DoneTaskScreenState();
}

class _DoneTaskScreenState extends State<DoneTaskScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy > 0) {
                    setState(() {
                      _isMyTaskScreen = true;
                    });
                  }
                },
                child: Text(
                  "Done Tasks",
                  style: TextStyle(fontSize: 25.0, color: widget.mainTextColor),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 275.0,
              child: ListView.builder(
                itemCount: _doneTasks.length,
                itemBuilder: (BuildContext context, int index){
                  final item = _doneTasks[index];
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(15.0),
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: _selectTaskColor(),
                    ),
                    child: Text('$item', style: TextStyle(fontSize: 30.0,color: widget.mainTextColor.withOpacity(0.75)),textAlign: TextAlign.center,),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}