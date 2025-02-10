import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Initdatabase {
  static final Initdatabase _instance = Initdatabase._internal();
  factory Initdatabase() => _instance;

  static Database? _db;
  Initdatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    try {
      //create Images and Recordings file
      final Directory applicationDataDirectory =
          await getApplicationDocumentsDirectory();
      final Directory recordingStorage =
          Directory("${applicationDataDirectory.path}/Recordings");
      final Directory imageStorage =
          Directory("${applicationDataDirectory.path}/Images");
      if (!(await recordingStorage.exists())) await recordingStorage.create();
      if (!(await imageStorage.exists())) await imageStorage.create();

      //cretae sqlite db app_database.db
      final dbPath = await getDatabasesPath();
      return await openDatabase(join(dbPath, "app_database.db"), version: 1,
          onCreate: (db, version) async {
        await db.execute(
            '''CREATE TABLE items (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,
         content TEXT NOT NULL, mood TEXT NOT NULL,
         location TEXT, audio_record TEXT, image TEXT, date TEXT NOT NULL);''');
      });
    } on Exception {
      throw Exception("Error creating DataBase: ");
    }
  }
}
