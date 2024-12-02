import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/InitDataBase.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Map<String, dynamic>>> getRecentEntries() async {
  final db = await Initdatabase().database;
  return await db.query(
    'items',
    orderBy: 'date DESC',
    limit: 10,
  );
}

Future<void> pushEntry(Entry entry) async {
  print(
      'Pushing Entry :\n --${entry.title} \n-- ${entry.Content} \n-- ${entry.mood} \n-- ${entry.date}');
  final db = await Initdatabase().database;
  await db.insert(
      "items",
      {
        "title": entry.title,
        "content": entry.Content,
        "mood": entry.mood,
        "location": entry.location,
        "audio_record": entry.audio_record,
        "image": entry.image,
        "date":
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
      },
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> deleteEntry(int id) async {
  final db = await Initdatabase().database;
  db.delete("items", where: "id = ?", whereArgs: ["$id"]);
}

Future<void> Wipe_deleteAllEntry() async {
  final db = await Initdatabase().database;
  db.delete("items");
}

Future<List<Map<String, Object?>>> getAllEntry() async {
  final db = await Initdatabase().database;
  final res = db.query("items");
  return res;
}

Future<List<Map<String, Object?>>> getEntry(String query) async {
  final db = await Initdatabase().database;
  final res =
      await db.query("items", where: "title LIKE ?", whereArgs: ["%$query%"]);
  return res;
}

Future<List<Map<String, Object?>>> getEntryById(int id) async {
  final db = await Initdatabase().database;
  final res = await db.query("items", where: "id = ?", whereArgs: [id]);
  return res;
}

Future<void> updateEntry(int id, Entry entry) async {
  final db = await Initdatabase().database;
  db.update(
      "items",
      {
        "title": entry.title,
        "content": entry.Content,
        "mood": entry.mood.toString(),
        "location": entry.location,
        "audio_record": entry.audio_record,
        "image": entry.image,
        "date":
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
      },
      where: "id = $id",
      conflictAlgorithm: ConflictAlgorithm.replace);
}
