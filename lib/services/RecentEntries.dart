import 'package:flutter/material.dart';
import 'package:journalmax/models/EntryItemMoods.dart';
import 'package:journalmax/widgets/XEntryItem.dart';
import 'package:journalmax/services/DataBaseService.dart';

Future<List<XEntryItem>> loadRecentEntries(void Function() renderParent) async {
  try {
    const Map<String, Color> Function(String query) NameToColor =
        EntryItemMoods.nameToColor;
    final Entries = await getRecentEntries();
    final List<XEntryItem> ResultArray = [];
    for (var i in Entries) {
      ResultArray.add(XEntryItem(
          renderParent: renderParent,
          id: i["id"],
          mood: NameToColor(i["mood"]),
          date: i["date"],
          title: i["title"]));
    }
    return ResultArray;
  } catch (e) {
    throw Exception(e);
  }
}
