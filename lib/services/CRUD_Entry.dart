import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/InitDataBase.dart';
import 'package:sqflite/sqflite.dart';

Future<void> pushEntry(Entry entry) async {
  print(
      'Pushing Entry :\n --${entry.title} \n-- ${entry.Content} \n-- ${entry.mood} \n-- ${entry.date}');
  final db = await Initdatabase().database;
  await db.insert(
      "items",
      {
        "title": entry.title,
        "content": entry.Content,
        "mood": entry.mood.toString(),
        "location": entry.location,
        "audio_record": entry.audio_record,
        "image": entry.image,
        "date": '${entry.date.day}/${entry.date.month}/${entry.date.year}'
      },
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> deleteEntry(dynamic query) async {
  final db = await Initdatabase().database;
}

Future<List<Map<String, Object?>>> getEntry(dynamic query) async {
  final db = await Initdatabase().database;
  final res = db.query("items");
  return res;
}

Future<void> updateEntry(dynamic query, Entry entry) async {}
