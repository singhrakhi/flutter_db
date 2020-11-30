import 'package:flutter/material.dart';
import 'package:flutter_db/model/note.dart';
import 'package:flutter_db/utils/database_helper.dart';
import 'package:flutter_db/utils/utility.dart';
import 'package:intl/intl.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  Notes _notes;

  NoteDetails(this._notes, this.appBarTitle);

  @override
  _NoteDetailsState createState() => _NoteDetailsState(this._notes,this.appBarTitle);
}

class _NoteDetailsState extends State<NoteDetails> {
  var _priorities = ['High', 'Low'];
  String appBarTitle;
  Notes _notes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _NoteDetailsState(this._notes, this.appBarTitle);

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    _titleController.text = _notes.title;
    _descController.text = _notes.description;

    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(icon: Icon(Icons.arrow_back),
              onPressed: (){
            moveToLastScreen();
              }),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: [
                ListTile(
                  title: DropdownButton(
                    isExpanded: true,
                    items: _priorities.map((String value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    style: simpleStyle(),
                    value: getPriorityAsString(_notes.priority),
                    hint: Text('Select Priority'),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        updatePriorityAsInt(valueSelectedByUser);
                        debugPrint('User selected $valueSelectedByUser');
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: _titleController,
                    style: simpleStyle(),
                    keyboardType: TextInputType.text,
                      validator: (val){
                        return val.isEmpty || val.length<2 ? "Please provide title minimum 2 character." : null;
                      },
                    onChanged: (value) {
                      updateTitle();

                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: simpleStyle(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: _descController,
                    style: simpleStyle(),
                    keyboardType: TextInputType.text,
                    validator: (val){
                      return val.isEmpty || val.length<2 ? "Please provide description maximum 500 character." : null;
                    },
                    onChanged: (value) {
                      updateDesc();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: simpleStyle(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(15.0),
                          onPressed: () {
                            if(_formKey.currentState.validate()) {
                              setState(() {
                                save();
                              });
                            }
                          },
                          child: Text('Save',
                            style: simpleButtonStyle(),
                          ),
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(15.0),
                          onPressed: () {
                            setState(() {
                              debugPrint('Delete');
                              delete();
                            });
                          },
                          child: Text('Delete',
                              style:simpleButtonStyle()
                          ),
                          color: Theme.of(context).primaryColorDark,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void  moveToLastScreen(){
    Navigator.pop(context,true);
  }

  void updatePriorityAsInt(String value){
    switch (value){
      case 'High':
        _notes.priority = 1;
        break;
      case 'Low':
        _notes.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value){
    String priority;
    switch (value){
      case 1:
       priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle(){
    _notes.title = _titleController.text;
  }

  void updateDesc(){
    _notes.description = _descController.text;
  }

  void save() async{
    moveToLastScreen();
    _notes.date = DateFormat.yMMMMd().format(DateTime.now());
    int result;
    if(_notes.id !=null){ // update note
        result = await databaseHelper.updateNote(_notes);
    } else{ // insert note
        result = await databaseHelper.insertNote(_notes);
    }

    if( result != 0){  // success
      _showAlertDialog('Status', 'Note saved successfully.');
    }
    else{ // failure
      _showAlertDialog('Status', 'Problem saving notes.');
    }
  }

  void delete() async{
    moveToLastScreen();
    if(_notes.id==null){
      _showAlertDialog('Status', 'No note was deleted');
    }

    int result = await databaseHelper.deleteNote(_notes.id);
    if( result != 0){  // success
      _showAlertDialog('Status', 'Note Deleted successfully.');
    }
    else{ // failure
      _showAlertDialog('Status', 'Some error occurred');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }


}
