import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../DatabaseHelper.dart';
import '../Notes.dart';
import 'NoteDetail.dart';

class NoteList extends StatefulWidget {
  @override
  NoteListState createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  DatabaseHelper helper = DatabaseHelper.getInstance();
  List<Notes> noteList = List<Notes>(); //error
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      this.noteList = List<Notes>();
      updateListViewVariables();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Task Manager'),
        backgroundColor: Colors.blue,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            navigateToDetail(Notes('', '', 2), 'Add Your ToDo Task'),
      ),
    );
  }

  void navigateToDetail(Notes note, String title) async {
    //bool result = await
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => NoteDetail(note, title)))
        .then((value) {
      if (value != null && value) {
        updateListViewVariables();
      }
    });
  }

  void updateListViewVariables() {
    final Future<Database> db = this.helper.initializeDatabase();
    db.then((database) {
      Future<List<Notes>> noteListFuture = helper.getNoteList();
      noteListFuture.then((nL) {
        setState(() {
          this.noteList = nL;
          this.count = nL.length;
        });
      });
    });
  }

  _clear() async {
    print("in _clear");
    await this.helper.clear();
    this.updateListViewVariables();
  }

  getNoteListView() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: this.count,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(8, 6, 8, 0),
                  child: Card(
                    color: Colors.green[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // elevation: 4.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red[50],
                        backgroundImage: AssetImage('images/to-do.png'),
                      ),
                      title: Text(
                        this.noteList[index].title ?? " ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        this.noteList[index].date,
                        //style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: GestureDetector(
                          child: Icon(Icons.open_in_new),
                          onTap: () => {
                                navigateToDetail(this.noteList[index],
                                    this.noteList[index].title)
                              }),
                    ),
                  ),
                );
              }),
        ),
        // Container(
        //   padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
        //   child: RaisedButton(
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(30.0)),
        //     textColor: Colors.white,
        //     color: Colors.red,
        //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        //     child: Text(
        //       'Clear',
        //       textScaleFactor: 1.5,
        //     ),
        //     onPressed: () {
        //       print("clear click");
        //       setState(() {
        //         _clear();
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }
}
