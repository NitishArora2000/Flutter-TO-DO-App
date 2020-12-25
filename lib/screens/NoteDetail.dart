import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../Notes.dart';
import '../DatabaseHelper.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NoteDetail extends StatefulWidget {
  final Notes note;
  final String appBarTitle;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorityOption = ['High', 'Low'];
  DatabaseHelper helper = DatabaseHelper.getInstance();
  FlutterLocalNotificationsPlugin fltrNotification;
  String appBarTitle;
  Notes note;
  String _selectedParam;
  String task;
  int val;
  //tz.initializeTimeZones();

  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('@mipmap/to_do');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification Clicked $payload"),
      ),
    );
  }

  Future _showNotification() async {
    print('inside');
    var androidDetails = new AndroidNotificationDetails(
        "Channel", "hello", "This is my channel",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    await fltrNotification.show(
        1, "Task", "You created a Task", generalNotificationDetails,
        payload: "Task");
     
    DateTime scheduledTime=DateTime.now();
    scheduledTime=DateTime(scheduledTime.year,scheduledTime.month,scheduledTime.day,
    picked.hour,picked.minute);
    // if (picked.hour == _time.hour) {
    //   scheduledTime = DateTime.now()
    //       .add(Duration(minutes: (picked.minute - _time.minute) - 1));
    // } else if (picked.hour > 12 && _time.hour > 12) {
    //   scheduledTime = DateTime.now().add(Duration(
    //       hours: (picked.hour - 12 - (_time.hour - 12)),
    //       minutes: (picked.minute - _time.minute)));
    // } else {
    //   scheduledTime = DateTime.now().add(Duration(
    //       hours: (picked.hour - _time.hour),
    //       minutes: (picked.minute - _time.minute)));
    // }
    //androidAllowWhileIdle: true;
    //fltrNotification.schedule(id, title, body, scheduledDate, notificationDetails)
    var title = note.title;
    var desc = note.description;

    fltrNotification.schedule(
        1, "$title", "$desc", scheduledTime, generalNotificationDetails);
  }

  NoteDetailState(this.note, this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  var hour = 00;
  var minutes = 00;

  Future<Null> _selectTime(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time) {
      setState(() {
        hour = picked.hour;
        minutes = picked.minute;
        print(picked);
        print(picked.hour);
        print(picked.minute);
      });
    }
  }

  @override
  Widget build(context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = note.title;
    descriptionController.text = note.description;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: moveToLastScreen,
        child: Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            centerTitle: true,
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: moveToLastScreen,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
            child: Card(
              color: Colors.green[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                    //dropdown menu
                    child: new ListTile(
                      leading: const Icon(Icons.low_priority),
                      title: DropdownButton(
                          items:
                              _priorityOption.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            );
                          }).toList(),
                          value: getPriority(note.priority),
                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              updatePriorityAsInt(valueSelectedByUser);
                            });
                          }),
                    ),
                  ),
                  // Second Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: titleController,
                      // style: textStyle,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        icon: Icon(Icons.title),
                      ),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 1.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: descriptionController,
                      // style: textStyle,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration(
                        labelText: 'Detail',
                        labelStyle: textStyle,
                        icon: Icon(Icons.details),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: h * 0.03)),
                  GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: HStack([
                        Padding(padding: EdgeInsets.only(left: w * 0.05)),
                        Icon(Icons.alarm),
                        Container(
                            padding: EdgeInsets.only(left: w * 0.04),
                            child: Text(
                              "Reminder",
                              style: textStyle,
                            )),
                      ])),
                  // IconButton(
                  //   icon: Icon(Icons.alarm),
                  //   onPressed: () {
                  //     _selectTime(context);
                  //     //print(_time);
                  //   },
                  //),
                  // Fourth Element
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 0.2),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            textColor: Colors.white,
                            color: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 30),
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                _save();
                                _showNotification();
                              });
                            },
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.only(right: 0.5),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            textColor: Colors.white,
                            color: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 30),
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);

    // Fluttertoast.showToast(
    //     msg: title + "\n" + message,
    //     toastLength: Toast.LENGTH_SHORT,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    var result;
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      if (note.id != null) {
        result = await helper.updateNote(note);
      } else {
        result = await helper.insertNote(note);
      }
    }

    print(result);
    if (result != null && result != 0)
      _showAlertDialog('Status', 'Note Saved Successfully');
    else
      _showAlertDialog('Status', 'Note not Saved.\nAll fields are required.');
  }

  _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDialog('Status', "Note doesn't exist.");
      return;
    }

    var result = await helper.deleteNote(note.id);
    if (result != null)
      _showAlertDialog('Status', 'Note Deleted Successfully');
    else
      _showAlertDialog('Status', 'Problem! Try Again');
  }

  Future<bool> moveToLastScreen() async {
    Navigator.pop(context, true);
    return false;
  }

  void updatePriorityAsInt(String val) {
    if (val == 'High')
      note.priority = 1;
    else
      note.priority = 2;
  }

//getting data from database,so converting it into h igh/low for user
  String getPriority(int val) {
    return _priorityOption[val - 1];
  }
}
