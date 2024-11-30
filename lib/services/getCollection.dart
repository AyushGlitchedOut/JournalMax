import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

//TODO: implement the actual collection
Future<List<Widget>> getCollection() async {
  const Map<String, Color> Function(String query) NametoColor =
      EntryItemMoods.NameToColor;
  final List<Widget> EntryList = [];
  final Entries = await getAllEntry();
  for (var entry in Entries) {
    EntryList.add(XEntryItem(
        mood: NametoColor(entry["mood"].toString()),
        date: entry["date"].toString(),
        title: entry["title"].toString()));
  }
  return EntryList;
}
