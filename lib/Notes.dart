//import 'package:flutter/scheduler.dart';

class Notes {
  // data members
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  //constructors
  Notes(this._title, this._date, this._priority, [this._description]);

  Notes.withId(this._id, this._date, this._priority, this._title,
      [this._description]);

  // getters
  int get id => _id;

  String get title => _title;

  String get description => _description;

  String get date => _date;

  int get priority => _priority;

  // setters
  set title(newTitle) {
    if (newTitle.length <= 255) this._title = newTitle;
  }

  set description(newDescription) {
    if (newDescription.length <= 255) this._description = newDescription;
  }

  set date(newDate) {
    this._date = newDate;
  }

  set priority(newPriority) {
    if (newPriority == 1 || newPriority == 2) this._priority = newPriority;
  }

  // converted notes' object to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  // from map to notes object
  Notes.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}
