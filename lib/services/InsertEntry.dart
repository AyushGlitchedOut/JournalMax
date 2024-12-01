import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

Future<void> insertEntry(String title, String content, String mood, String date,
    dynamic location, dynamic audio, dynamic images) async {
  await pushEntry(Entry(
      title: title,
      Content: content,
      mood: mood,
      location: location,
      audio_record: audio,
      image: images,
      date: date));
}
