class Entry {
  final String title;
  final String Content;
  final String mood;
  final dynamic location;
  final dynamic audio_record;
  final dynamic image;
  final String date;

  Entry(
      {required this.title,
      required this.Content,
      required this.mood,
      this.location,
      this.audio_record,
      this.image,
      required this.date});
}
