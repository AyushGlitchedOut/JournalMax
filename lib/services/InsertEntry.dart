import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/DataBaseService.dart';

//simple function for inserting entry
Future<void> insertEntry(String title, String content, String mood, String date,
    dynamic location, dynamic audio, dynamic images) async {
  try {
    await pushEntry(Entry(
        title: title,
        content: content,
        mood: mood,
        location: location,
        audioRecord: audio,
        image: images,
        date: date));
  } catch (e) {
    //generic exception
    throw Exception(e);
  }
}
