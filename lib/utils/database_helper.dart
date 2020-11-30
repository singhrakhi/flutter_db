import 'package:flutter_db/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper==null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database==null){
      _database = await initializeDb();
    }
    return _database;
  }

  Future<Database> initializeDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path+'note.db';
    
   var noteDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
   return noteDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

//  get all notes

  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    Database db = await this.database;
    // var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');

    return result;
  }

//  insert note into db

  Future<int> insertNote(Notes notes ) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, notes.toMap());
    return result;
  }

  //  update note into db

  Future<int> updateNote(Notes notes ) async{
    Database db = await this.database;
    var result = await db.update(noteTable, notes.toMap(), where: '$colId =?', whereArgs: [notes.id]);
    return result;
  }

  //  delete note into db

  Future<int> deleteNote(int id ) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  // get number of note objs

  Future<int> getCounts() async{
    Database db = await this.database;
   List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
   int result =  Sqflite.firstIntValue(x);
   return result;
  }

//  get map list from database and convert it into note list

  Future<List<Notes>> getNoteList() async {
    var noteMap = await getNoteMapList();
    int count = noteMap.length;
    List<Notes> note = List<Notes>();

    for(int i=0; i<count;i++){
      note.add(Notes.fromMap(noteMap[i]));
    }

    return note;
  }



}