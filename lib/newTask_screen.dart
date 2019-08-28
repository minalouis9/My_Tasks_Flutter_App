import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewTaskScreen extends StatefulWidget {

  final Color mainBackgroundColor;
  final Color mainTaskColor;
  final Color mainTextColor;
  final String mainColor;
  final List<String> mainTasksTitlesList;
  final List<String> mainTasksDetailsList;
  final List<String> mainTasksDaysList;
  final List<bool> isSelectedList;
  final List<Color> selectedColorList;

  NewTaskScreen(
      {Key key,
        @required this.mainBackgroundColor,
        this.mainColor,
        this.mainTextColor,
        this.mainTaskColor,
        this.mainTasksTitlesList,
        this.mainTasksDetailsList,
        this.mainTasksDaysList,
        this.isSelectedList,
        this.selectedColorList,
        })
      : super(key: key);
  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  TextEditingController _taskTitle = new TextEditingController();
  TextEditingController _taskDescription = new TextEditingController();

  bool _isDayChosen;
  bool _isCodeScanned;
  bool _isChooseDayScreen;

  String _selectedDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    _isCodeScanned = false;
    _isDayChosen = false;
    _isChooseDayScreen = false;
    _selectedDay = "Tab to choose a day";
  }

  void _addTask() {
    Color _taskColor = widget.mainTaskColor;
    int index = widget.mainTasksTitlesList.length;
    widget.isSelectedList.insert(index, false);
    widget.selectedColorList.insert(index, _taskColor);
    widget.mainTasksTitlesList.insert(index, _taskTitle.text);
    widget.mainTasksDaysList.insert(index, _selectedDay);
    if(_taskDescription.toString()!= null || _taskDescription.toString() != "") {
      widget.mainTasksDetailsList.insert(index, _taskDescription.text);
    }
    _isCodeScanned = false;
    _isDayChosen = false;
    _saveData();
    Navigator.pop(context);
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("Titles", widget.mainTasksTitlesList);
    prefs.setStringList("Details", widget.mainTasksTitlesList);
    prefs.setStringList("Day", widget.mainTasksDaysList);
  }

  Widget _buildDayComponent(String day) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 80.0,
        child: Material(
          borderRadius: BorderRadius.circular(15.0),
          color: widget.mainTaskColor,
          child: OutlineButton(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(15.0))),
            borderSide: BorderSide(
              color: widget.mainTaskColor,
            ),
            onPressed: () {
              setState(() {
                _selectedDay = day;
                _isDayChosen = true;
                _isChooseDayScreen = false;
              });
            },
            child: Text(
              day,
              style: TextStyle(
                  fontSize: 25.0,
                  color:
                  widget.mainTextColor),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildChooseDayComponent() {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 15.0),
            width: MediaQuery.of(context).size.width,
            height: 75.0,
            child: Text(
              "Choose Day",
              style: TextStyle(fontSize: 25.0, color: widget.mainTextColor),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildDayComponent("Saturday"),
                  _buildDayComponent("Sunday"),
                  _buildDayComponent("Monday"),
                  _buildDayComponent("Tuesday"),
                  _buildDayComponent("Wednesday"),
                  _buildDayComponent("Thursday"),
                  _buildDayComponent("Friday"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewTaskComponents() {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width,
            height: 75.0,
            child: FlatButton.icon(
              onPressed: () {
                _saveData();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 35.0,
                color: widget.mainTextColor,
              ),
              label: Text(
                "Add New",
                style: TextStyle(fontSize: 20.0, color: widget.mainTextColor),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Task Name",
                          style: TextStyle(fontSize: 17.5),
                        ),
                        SizedBox(
                          height: 7.5,
                        ),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          height: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: widget.mainTaskColor,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _taskTitle,
                            minLines: 1,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Example: Take the medicine",
                              hintStyle: TextStyle(
                                  color: widget.mainTextColor.withOpacity(0.5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      color: widget.mainTaskColor, width: 1.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Description",
                          style: TextStyle(fontSize: 17.5),
                        ),
                        SizedBox(
                          height: 7.5,
                        ),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: widget.mainTaskColor,
                          ),
                          child: TextField(
                            controller: _taskDescription,
                            minLines: 1,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText:
                              "I should eat before medicine, don't have to wait after eating.",
                              hintStyle: TextStyle(
                                  color: widget.mainTextColor.withOpacity(0.5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      color: widget.mainTaskColor, width: 1.0)),
                              //icon: Icon(Icons.email)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Task Day",
                          style: TextStyle(fontSize: 17.5),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 80.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(15.0),
                              color: widget.mainTaskColor,
                              child: OutlineButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                                borderSide: BorderSide(
                                  color: widget.mainTaskColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isChooseDayScreen = true;
                                  });
                                },
                                child: Text(
                                  _selectedDay,
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      color:
                                      widget.mainTextColor.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Task Code", style: TextStyle(fontSize: 17.5),),
                            Text("Tab to scan the QR code", style: TextStyle(fontSize: 16.0,color: widget.mainTextColor.withOpacity(0.5)),)
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.filter_center_focus,size: 35.0,color: widget.mainTextColor,),
                          onPressed: (){
                            setState(() {
                              _isCodeScanned = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    child: FlatButton(
                      onPressed: (_isDayChosen && _isCodeScanned) ? ((){setState(() {_addTask();});}) : null,
                      child: Text("Add the task +", style: TextStyle(fontSize: 25.0,color: widget.mainTextColor.withOpacity(0.5)),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: widget.mainBackgroundColor,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: _isChooseDayScreen ?
        _buildChooseDayComponent()
            :
        _buildNewTaskComponents(),
      ),
    );
  }
}