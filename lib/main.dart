import 'package:flutter/material.dart';
import 'package:flutter_db/screens/form_ui.dart';
import 'package:flutter_db/screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NoteKeeper",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      home: NoteList(),
    );
  }
}
