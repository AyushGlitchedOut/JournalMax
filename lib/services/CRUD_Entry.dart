import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/InitDataBase.dart';

Future<void> pushEntry(Entry entry) async {
  print(
      'Pushing Entry :${entry.title} -- ${entry.Content} -- ${entry.mood} -- ${entry.date}');
  final db = await Initdatabase().database;
  db.insert("items", {
    "title": entry.title,
    "content": entry.Content,
    "mood": entry.mood,
    "location": entry.location,
    "audio_record": entry.audio_record,
    "image": entry.image,
    "date": entry.date
  });
}

Future<void> deleteEntry(dynamic query) async {
  final db = await Initdatabase().database;
}

Entry getEntry(dynamic query) {
  return Entry(
      title: "", Content: "", mood: EntryItemMoods.angry, date: DateTime.now());
}

Future<void> updateEntry(dynamic query, Entry entry) async {}
