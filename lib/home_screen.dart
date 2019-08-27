import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tasks_screen.dart';

enum _backgroundColors {
  red,
  yellow,
  blue,
  darkBlue,
  green,
  black
}

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Color _mainColor = Colors.black;
  Color _mainTextColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void _setMainProgramColor() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.setInt("mainBackgroundColor", _mainColor.hashCode);
    prefs.setString("mainBackgroundColor", _mainColor.toString());
    //prefs.setString("mainTextColor", _textColor().toString());
  }

  Color _textColor () {
    if(_mainColor == Colors.black || _mainColor == Color(0xff311B92))
      return Colors.white;
    else
      return Colors.black;
  }

  Widget _buildStartScreenComponents() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("My Tasks", style: TextStyle(color: _textColor().withOpacity(0.75), fontSize: 20.0),),
        SizedBox(height: 20.0,),
        Text("My Tasks", style: TextStyle(color: _textColor(), fontSize: 45.0, fontWeight: FontWeight.bold),),
        SizedBox(height: 20.0,),
        Text("Flutter App", style: TextStyle(color: _textColor().withOpacity(0.75), fontSize: 20.0),),
      ],
    );
  }

  Widget _colorComponent(Color color, String value, Color textColor) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(25.0),
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
        borderSide: BorderSide(
          color: Colors.white,
          style: BorderStyle.solid,
          width: 2.0,
        ),
          onPressed: () {
            setState(() {
              _mainColor = color;
              _setMainProgramColor();
              _mainTextColor = _textColor();
            });
            Navigator.of(context).pushReplacement(new TaskScreenRoute(_mainColor,value,_mainTextColor));
          }
      ),
    );
  }

  Widget _colorSelectorComponents() {
    return Column(
      children: <Widget>[
        Text("Choose Your Color", style: TextStyle(color: _textColor(), fontSize: 25.0),),
        Icon(Icons.keyboard_arrow_down, color: _textColor(), size: 40.0,),
        SizedBox(height: 30.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 40.0,
              width: 40.0,
              child: _colorComponent(Color(0xffF44336), _backgroundColors.red.toString(),_textColor()),
            ),
            SizedBox(width: 15.0,),
            SizedBox(
              height: 40.0,
              width: 40.0,
              child: _colorComponent(Color(0xffFFC400), _backgroundColors.yellow.toString(),_textColor()),
            ),
            SizedBox(width: 15.0,),
            SizedBox(
              height: 40.0,
              width: 40.0,
              child: _colorComponent(Color(0xff2962FF), _backgroundColors.blue.toString(),_textColor()),
            ),
            SizedBox(width: 15.0,),
            SizedBox(
              height: 40.0,
              width: 40.0,
              child: _colorComponent(Color(0xff311B92), _backgroundColors.darkBlue.toString(),_textColor()),
            ),
            SizedBox(width: 15.0,),
            SizedBox(
              height: 40.0,
              width: 40.0,
              child: _colorComponent(Color(0xff00E676), _backgroundColors.green.toString(),_textColor()),
            ),
            SizedBox(width: 15.0,),
            SizedBox(
              height: 40.0,
              width: 40.0,
              child: _colorComponent(Colors.black, _backgroundColors.black.toString(),_textColor()),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: _mainColor,
      body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildStartScreenComponents(),
                SizedBox(height: 220.0,),
                _colorSelectorComponents(),
                SizedBox(height: 10.0,)
              ],
            ),
          ),
      ),
    );
  }
}

class TaskScreenRoute extends CupertinoPageRoute {
  TaskScreenRoute(Color color, String colorString, Color textColor)
      : super(builder: (BuildContext context) => new TaskScreen(mainBackgroundColor: color,mainColor: colorString,mainTextColor: textColor,));
}