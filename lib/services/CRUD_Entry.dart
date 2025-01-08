import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/InitDataBase.dart';
import 'package:sqflite/sqflite.dart';

//Create
Future<void> pushEntry(Entry entry) async {
  try {
    final db = await Initdatabase().database;
    await db.insert(
        "items",
        {
          "title": entry.title,
          "content": entry.content,
          "mood": entry.mood,
          "location": entry.location,
          "audio_record": entry.audioRecord,
          "image": entry.image,
          "date":
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  } on Exception {
    throw Exception("Error inserting Entry to DataBase");
  }
}

// Read
Future<List<Map<String, Object?>>> getEntry(String query) async {
  try {
    final db = await Initdatabase().database;
    final res =
        await db.query("items", where: "title LIKE ?", whereArgs: ["%$query%"]);
    return res;
  } on Exception {
    throw Exception("Error getting Entries by query");
  }
}

Future<List<Map<String, Object?>>> getAllEntry() async {
  try {
    final db = await Initdatabase().database;
    final res = db.query("items");
    return res;
  } on Exception {
    throw Exception("Error retrieving all the Entries in DataBase");
  }
}

Future<List<Map<String, Object?>>> getEntryById(int id) async {
  try {
    final db = await Initdatabase().database;
    final res = await db.query("items", where: "id = ?", whereArgs: [id]);
    return res;
  } on Exception {
    throw Exception("Error getting a specific Entry by Id");
  }
}

Future<List<Map<String, dynamic>>> getRecentEntries() async {
  try {
    final db = await Initdatabase().database;
    return await db.query(
      'items',
      orderBy: 'date DESC',
      limit: 10,
    );
  } on Exception {
    throw Exception("Error getting the most Recent Entries");
  }
}

//Update

Future<void> updateEntry(int id, Entry entry) async {
  try {
    final db = await Initdatabase().database;
    db.update(
        "items",
        {
          "title": entry.title,
          "content": entry.content,
          "mood": entry.mood.toString(),
          "location": entry.location,
          "audio_record": entry.audioRecord,
          "image": entry.image,
          "date":
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
        },
        where: "id = $id",
        conflictAlgorithm: ConflictAlgorithm.replace);
  } on Exception {
    throw Exception("Error updating an Entry");
  }
}

//Delete

Future<void> deleteEntry(int id) async {
  try {
    final db = await Initdatabase().database;
    db.delete("items", where: "id = ?", whereArgs: ["$id"]);
  } on Exception {
    throw Exception("Error deleting an Entry by Id");
  }
}

Future<void> wipeOrdeleteAllEntry() async {
  try {
    final db = await Initdatabase().database;
    db.delete("items");
  } on Exception {
    throw Exception("Error wiping the Database");
  }
}
