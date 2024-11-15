import 'package:flutter/material.dart';

class Entry {
  final String title;
  final String Content;
  final Map<String, Color> mood;
  final dynamic location;
  final dynamic audio_record;
  final dynamic image;
  final DateTime date;

  Entry(
      {required this.title,
      required this.Content,
      required this.mood,
      this.location,
      this.audio_record,
      this.image,
      required this.date});
}
