import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

Future<List<XEntryItem>> loadRecentEntries(void Function() renderParent) async {
  const Map<String, Color> Function(String query) NameToColor =
      EntryItemMoods.NameToColor;
  //TODO : implement the actual stuff
  final Entries = await getRecentEntries();
  final List<XEntryItem> ResultArray = [];
  for (var i in Entries) {
    ResultArray.add(XEntryItem(
        renderParent: renderParent,
        id: i["id"],
        mood: NameToColor(i["mood"]),
        date: i["date"],
        title: i["title"]));
    print(i["id"]);
  }
  return ResultArray;
}
