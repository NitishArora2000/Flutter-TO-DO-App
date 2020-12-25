//import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Notes.dart';

class DatabaseHelper {
  DatabaseHelper._(); //private constructor

  static final DatabaseHelper _instance = DatabaseHelper._();

  static Database _database; //singleton
  String noteTable = 'Note_Table';
  String colID = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  factory DatabaseHelper.getInstance() => _instance;

  //custom getter
  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database;
  }

  //how initialization works
  Future<Database> initializeDatabase() async {
    print("38");
    Directory directory = await getApplicationDocumentsDirectory();
    var path = directory.path + 'notes.db';

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  //  creating table in database
  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable ('
        '$colID INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colTitle TEXT,'
        '$colDescription TEXT, '
        '$colPriority INTEGER,'
        '$colDate TEXT'
        ')');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    Future<List<Map<String, dynamic>>> result =
        db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Notes note) async {
    print("in insert");
    print(note.toMap());
    Database db = await this.database;
    var result = db.insert(noteTable, note.toMap());
    print(result);
    return result;
  }

  Future<int> updateNote(Notes note) async {
    print("in update");
    print(note.toMap());
    Database db = await this.database;
    var result = db.update(noteTable, note.toMap(),
        where: '$colID = ?', whereArgs: [note.id]);
    print(result);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = db.rawDelete('DELETE FROM $noteTable where $colID = $id');
    return result;
  }

  Future clear() async {
    print("clear database");
    Database db = await this.database;
    var result = db.delete(noteTable);
    print(result);
  }

  Future<int> countNotes() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery(' SELECT COUNT(*) FROM $noteTable');
    // return Sqflite.firstIntValue(x);
    return x.length;
  }

  // getting data in a list of notes from database
  Future<List<Notes>> getNoteList() async {
    var mapList = await getNoteMapList();
    int count = mapList.length;
    print("length");
    print(count);
    List<Notes> result = List<Notes>();
    for (var i = 0; i < count; i++) {
      print(mapList[i]);
      result.add(Notes.fromMapObject(mapList[i]));
    }
    return result;
  }
}
