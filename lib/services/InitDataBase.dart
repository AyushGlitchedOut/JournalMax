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
      final DBpath = await getDatabasesPath();
      return await openDatabase(join(DBpath, "app_database.db"), version: 1,
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
