import 'package:flutter/material.dart';
import 'package:journalmax/widgets/XEntryItem.dart';
import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

Future<List<Widget>> getCollection(void Function() renderParent) async {
  try {
    const Map<String, Color> Function(String query) nametoColor =
        EntryItemMoods.nameToColor;
    final List<Widget> entryList = [];
    final entries = await getAllEntry();
    for (var entry in entries) {
      entryList.add(XEntryItem(
          renderParent: renderParent,
          id: int.parse(entry["id"].toString()),
          mood: nametoColor(entry["mood"].toString()),
          date: entry["date"].toString(),
          title: entry["title"].toString()));
    }
    return entryList;
  } catch (e) {
    throw Exception(e);
  }
}
