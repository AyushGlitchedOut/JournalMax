
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
