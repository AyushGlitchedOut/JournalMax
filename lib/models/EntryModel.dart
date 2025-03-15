//The model for the fundamental unit of data in the App, an entry. Includes a title and content along with date,
//and a mood (compulsory) and a date, voice recording(path) and json List of Images(paths) and all of those are not
//compulsory
class Entry {
  final String title;
  final String content;
  final String mood;
  final dynamic location;
  final dynamic audioRecord;
  final dynamic image;
  final String date;

  Entry(
      {required this.title,
      required this.content,
      required this.mood,
      this.location,
      this.audioRecord,
      this.image,
      required this.date});
}
