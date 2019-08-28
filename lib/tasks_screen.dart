import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'newTask_screen.dart';
import 'doneTask_screen.dart';
import 'editTask_screen.dart';

class TaskScreen extends StatefulWidget {
  final Color mainBackgroundColor;
  final Color mainTextColor;
  final String mainColor;
  TaskScreen(
      {Key key,
      @required this.mainBackgroundColor,
      this.mainColor,
      this.mainTextColor})
      : super(key: key);
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<String> _tasksTitles;
  List<String> _tasksDetails;
  List<String> _doneTasks;
  List<bool> _isSelected = [];
  List<Color> _selectedColor = [];

  bool _isAnySelected;
  bool _isMyTaskScreen;
  bool _isGridView;
  bool _isLoading;
  bool _isMultipleSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isMyTaskScreen = true;
    _isGridView = false;
    _isAnySelected = false;
    _isMultipleSelected = false;
    _isLoading = true;
    _loadData();
  }

  Future<bool> _writeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("Titles", _tasksTitles);
    prefs.setStringList("Details", _tasksDetails);
    prefs.setStringList("Done", _doneTasks);
    return true;
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasksTitles = prefs.getStringList("Titles");
      if (_tasksTitles == null) {
        _tasksTitles = [];
      }
      _tasksDetails = prefs.getStringList("Details");
      if (_tasksDetails == null) {
        _tasksDetails = [];
      }
      _doneTasks = prefs.getStringList("Done");
      if (_doneTasks == null) {
        _doneTasks = [];
      }
      if (_tasksTitles.isNotEmpty) {
        for (var task in _tasksTitles) {
          _isSelected.add(false);
          _selectedColor.add(_selectTaskColor());
        }
      }
      _isLoading = false;
    });
  }

  Color _selectTaskColor() {
    switch (widget.mainColor) {
      case "_backgroundColors.red":
        {
          return Color(0xffC2352B);
        }
        break;

      case "_backgroundColors.yellow":
        {
          return Colors.yellowAccent;
        }
        break;

      case "_backgroundColors.blue":
        {
          return Colors.lightBlueAccent;
        }
        break;

      case "_backgroundColors.darkBlue":
        {
          return Colors.indigoAccent;
        }
        break;

      case "_backgroundColors.green":
        {
          return Colors.greenAccent;
        }
        break;

      default:
        {
          return Colors.grey;
        }
        break;
    }
  }

  void _removeTask(int index) {
    _doneTasks.add(_tasksTitles.elementAt(index));
    _tasksTitles.removeAt(index);
    _tasksDetails.removeAt(index);
    _isSelected.removeAt(index);
    _selectedColor.removeAt(index);
  }

  void _selectTask(int index) {
    int count = 0;
    bool _noneSelected = true;
    bool _selectionState = _isSelected.elementAt(index);
    _selectedColor.removeAt(index);
    _isSelected.removeAt(index);
    _isSelected.insert(index, !_selectionState);
    if (_isSelected.elementAt(index)) {
      _selectedColor.insert(index, Colors.white);
    } else {
      _selectedColor.insert(index, _selectTaskColor());
    }
    for (var check in _isSelected) {
      if (check) {
        count++;
        _noneSelected = false;
      }
    }
    if (_noneSelected) {
      _isAnySelected = false;
    } else {
      _isAnySelected = true;
    }
    if (count > 1) {
      _isMultipleSelected = true;
    } else {
      _isMultipleSelected = false;
    }
  }

  Widget _buildAddTaskButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 80.0,
        child: Material(
          color: widget.mainBackgroundColor,
          child: _isAnySelected
              ? OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  borderSide: BorderSide(
                    color: widget.mainTextColor.withOpacity(0.5),
                    style: BorderStyle.solid,
                    width: 2.0,
                  ),
                  onPressed: null,
                  child: Text(
                    "Add New +",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: widget.mainTextColor.withOpacity(0.1)),
                  ),
                )
              : OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  borderSide: BorderSide(
                    color: widget.mainTextColor.withOpacity(0.5),
                    style: BorderStyle.solid,
                    width: 2.0,
                  ),
                  onPressed: () {
                    _writeData();
                    Navigator.push(
                        context,
                        NewTaskScreenRoute(
                            widget.mainBackgroundColor,
                            _selectTaskColor(),
                            widget.mainTextColor,
                            widget.mainColor,
                            _tasksTitles,
                            _tasksDetails,
                            _isSelected,
                            _selectedColor));
                  },
                  child: Text(
                    "Add New +",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: widget.mainTextColor.withOpacity(0.5)),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSelectedOptionsMenu() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      width: MediaQuery.of(context).size.width,
      child: _isMultipleSelected
          ? FlatButton(
              onPressed: (){
                setState(() {
                  for(int index = 0; index < _isSelected.length; ++index){
                    if(_isSelected.elementAt(index) == true){
                      _tasksTitles.removeAt(index);
                      _tasksDetails.removeAt(index);
                      _selectedColor.removeAt(index);
                      _isSelected.removeAt(index);
                    }
                  }
                });
              },
              child: Text(
                "Delete",
                style: TextStyle(
                    color: widget.mainTextColor.withOpacity(0.5),
                    fontSize: 20.0),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      for(int index = 0; index < _isSelected.length; ++index){
                        if(_isSelected.elementAt(index) == true){
                          Navigator.of(context).push(EditTaskScreenRoute(widget.mainBackgroundColor, _selectTaskColor(), widget.mainTextColor, widget.mainColor, index, _tasksTitles, _tasksDetails));
                        }
                      }
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(
                          color: widget.mainTextColor.withOpacity(0.5),
                          fontSize: 20.0),
                    ),
                  ),
                  FlatButton(
                    onPressed: (){
                      setState(() {
                        for(int index = 0; index < _isSelected.length; ++index){
                          if(_isSelected.elementAt(index) == true){
                            _tasksTitles.removeAt(index);
                            _tasksDetails.removeAt(index);
                            _selectedColor.removeAt(index);
                            _isSelected.removeAt(index);
                          }
                        }
                      });
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: widget.mainTextColor.withOpacity(0.5),
                          fontSize: 20.0),
                    ),
                  ),
                ]),
    );
  }

  Widget _buildDoneButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy < 0) {
            //TODO: implement the navigation to the done page
            _writeData();
            Navigator.push(
                context,
                doneTaskScreenRoute(
                    widget.mainBackgroundColor,
                    widget.mainTextColor,
                    widget.mainColor,
                    _selectTaskColor(),
                    _doneTasks));
          }
        },
        child: Column(
          children: <Widget>[
            Icon(
              Icons.keyboard_arrow_up,
              color: widget.mainTextColor.withOpacity(0.5),
              size: 35.0,
            ),
            Text(
              "Done",
              style: TextStyle(
                  color: widget.mainTextColor.withOpacity(0.5), fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myTaskScreen() {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 75.0,
              color: widget.mainBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(new HomeScreenRoute());
                    },
                    child: Text(
                      "My Tasks",
                      style: TextStyle(
                          fontSize: 20.0, color: widget.mainTextColor),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          onPressed: null,
                          child: Text(
                            "Sunday",
                            style: TextStyle(
                                color: widget.mainTextColor.withOpacity(0.5),
                                fontSize: 17.5),
                          ),
                        ),
                        //Icon(Icons.keyboard_arrow_right,size: 30.0,color: widget.mainTextColor.withOpacity(0.5),),
                        IconButton(
                          icon: _isGridView
                              ? Icon(
                                  Icons.list,
                                  color: widget.mainTextColor,
                                )
                              : Icon(
                                  Icons.dashboard,
                                  color: widget.mainTextColor,
                                ),
                          iconSize: 30.0,
                          onPressed: () {
                            setState(() {
                              _isGridView = !_isGridView;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 300.0,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow),
                      ),
                    )
                  : (_isGridView
                      ? GridView.builder(
                          itemCount: _tasksTitles.length,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            final item = _tasksTitles[index];
                            return Dismissible(
                              key: Key(item),
                              onDismissed: (direction) {
                                if (!_isAnySelected) {
                                  setState(() {
                                    _removeTask(index);
                                  });
                                }
                              },
                              //background: Container(color: Colors.green,),
                              child: GestureDetector(
                                onLongPress: () {
                                  if (!_isAnySelected) {
                                    setState(() {
                                      _selectTask(index);
                                    });
                                  }
                                },
                                onTap: () {
                                  if (_isAnySelected) {
                                    setState(() {
                                      _selectTask(index);
                                    });
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.all(10.0),
                                  padding: EdgeInsets.all(15.0),
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: _isSelected.elementAt(index)
                                        ? Colors.white
                                        : _selectedColor.elementAt(index),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '$item',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            color: _isSelected.elementAt(index)
                                                ? Colors.black
                                                : widget.mainTextColor
                                                    .withOpacity(0.75)),
                                        textAlign: TextAlign.center,
                                      ),
                                      _isAnySelected
                                          ? _isSelected.elementAt(index)
                                              ? Icon(Icons.radio_button_checked)
                                              : Icon(
                                                  Icons.radio_button_unchecked)
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: _tasksTitles.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = _tasksTitles[index];
                            return Dismissible(
                              key: Key(item),
                              onDismissed: (direction) {
                                if (!_isAnySelected) {
                                  setState(() {
                                    _removeTask(index);
                                  });
                                }
                              },
                              child: GestureDetector(
                                onLongPress: () {
                                  if (!_isAnySelected) {
                                    setState(() {
                                      _selectTask(index);
                                    });
                                  }
                                },
                                onTap: () {
                                  if (_isAnySelected) {
                                    setState(() {
                                      _selectTask(index);
                                    });
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.all(10.0),
                                  padding: EdgeInsets.all(15.0),
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: _isSelected.elementAt(index)
                                        ? Colors.white
                                        : _selectedColor.elementAt(index),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '$item',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            color: _isSelected.elementAt(index)
                                                ? Colors.black
                                                : widget.mainTextColor
                                                    .withOpacity(0.75)),
                                        textAlign: TextAlign.center,
                                      ),
                                      _isAnySelected
                                          ? _isSelected.elementAt(index)
                                              ? Icon(Icons.radio_button_checked)
                                              : Icon(
                                                  Icons.radio_button_unchecked)
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
            ),
            _buildAddTaskButton(),
            _isAnySelected ? _buildSelectedOptionsMenu() : _buildDoneButton(),
          ],
        ),
      ),
    );
  }

  /*Widget _addTaskScreen() {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.all(15.0),
          width: MediaQuery.of(context).size.width,
          height: 75.0,
          child: FlatButton.icon(
            onPressed: () {
              setState(() {
                _isAddNewTask = false;
              });
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
                          color: _selectTaskColor(),
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
                                    color: _selectTaskColor(), width: 1.0)),
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
                          color: _selectTaskColor(),
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
                                    color: _selectTaskColor(), width: 1.0)),
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
                            color: _selectTaskColor(),
                            child: OutlineButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              borderSide: BorderSide(
                                color: _selectTaskColor(),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isDayChosen = true;
                                });
                              },
                              child: Text(
                                "Tab to choose a day",
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
    );
  }*/

  Widget _doneScreen() {
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
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _doneTasks.length,
                      itemBuilder: (BuildContext context, int index) {
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
                          child: Text(
                            '$item',
                            style: TextStyle(
                                fontSize: 30.0,
                                color: widget.mainTextColor.withOpacity(0.75),
                                decoration: TextDecoration.lineThrough),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _mainScreens = [_myTaskScreen(), _doneScreen()];

    // TODO: implement build
    return Scaffold(
      backgroundColor: widget.mainBackgroundColor,
      body: WillPopScope(
        child: _isMyTaskScreen ? _mainScreens[0] : _mainScreens[1],
        onWillPop: _writeData,
      ),
    );
  }
}

class HomeScreenRoute extends CupertinoPageRoute {
  HomeScreenRoute()
      : super(builder: (BuildContext context) => new HomeScreen());
}

class NewTaskScreenRoute extends CupertinoPageRoute {
  NewTaskScreenRoute(
      Color mainBackgroundColor,
      Color mainTaskColor,
      Color mainTextColor,
      String mainColor,
      List<String> mainTasksTitlesList,
      List<String> mainTasksDetailsList,
      List<bool> isSelectedList,
      List<Color> selectedColorList)
      : super(
            builder: (BuildContext context) => new NewTaskScreen(
                  mainBackgroundColor: mainBackgroundColor,
                  mainTaskColor: mainTaskColor,
                  mainTextColor: mainTextColor,
                  mainColor: mainColor,
                  mainTasksTitlesList: mainTasksTitlesList,
                  mainTasksDetailsList: mainTasksDetailsList,
                  isSelectedList: isSelectedList,
                  selectedColorList: selectedColorList,
                ));
}

class EditTaskScreenRoute extends CupertinoPageRoute {
  EditTaskScreenRoute(
      Color mainBackgroundColor,
      Color mainTaskColor,
      Color mainTextColor,
      String mainColor,
      int index,
      List<String> mainTasksTitlesList,
      List<String> mainTasksDetailsList,)
      : super(
      builder: (BuildContext context) => new EditTaskScreen(
        mainBackgroundColor: mainBackgroundColor,
        mainTaskColor: mainTaskColor,
        mainTextColor: mainTextColor,
        mainColor: mainColor,
        index: index,
        mainTasksTitlesList: mainTasksTitlesList,
        mainTasksDetailsList: mainTasksDetailsList,
      ));
}

Route doneTaskScreenRoute(Color mainBackgroundColor, Color mainTextColor,
    String mainColor, Color mainTaskColor, List<String> mainDoneTasksList) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DoneTaskScreen(
      mainBackgroundColor: mainBackgroundColor,
      mainColor: mainColor,
      mainTextColor: mainTextColor,
      mainTaskColor: mainTaskColor,
      mainDoneTasksList: mainDoneTasksList,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
