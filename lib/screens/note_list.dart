import 'package:flutter/material.dart';
import 'package:flutter_db/model/note.dart';
import 'package:flutter_db/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'Note_details.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper _databaseHelper = new DatabaseHelper();
  List<Notes> _noteList;

  @override
  Widget build(BuildContext context) {
    if (_noteList == null) {
      _noteList = List<Notes>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Note"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nagivate(Notes('', '', 2), 'Add note');
        },
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle style = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int pos) {
        return Card(
          color: Colors.white,
          elevation: 3.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this._noteList[pos].priority),
              child: getPriorityIcon(this._noteList[pos].priority),
            ),
            title: Text(
              this._noteList[pos].title,
              style: style,
            ),
            subtitle: Text(this._noteList[pos].date),
            trailing: GestureDetector(
                onTap: () {
                  delete(context, _noteList[pos]);
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                )),
            onTap: () {
              nagivate(this._noteList[pos], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  // return the priority color

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
        break;
    }
  }

  // return the priority icon

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
        break;
    }
  }

  void delete(BuildContext context, Notes notes) async {
    int result = await _databaseHelper.deleteNote(notes.id);
    if (result != 0) {
      _showSnackBar(context, 'Note deleted successfully');
      updateListView();
    }
  }

  void nagivate(Notes notes, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetails(notes, title);
    }));
    if (result) {
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(content: Text(s));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initializeDb();
    dbFuture.then((database) {
      Future<List<Notes>> noteListFuture = _databaseHelper.getNoteList();
      noteListFuture.then((value) {
        setState(() {
          this._noteList = value;
          this.count = value.length;
        });
      });
    });
  }
}
