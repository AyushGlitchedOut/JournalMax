import 'package:flutter/material.dart';
import 'package:journalmax/models/EntryItemMoods.dart';
import 'package:journalmax/widgets/XEntryItem.dart';
import 'package:journalmax/services/DataBaseService.dart';

Future<List<XEntryItem>> loadRecentEntries(void Function() renderParent) async {
  try {
    //specify the name to color function
    const Map<String, Color> Function(String query) NameToColor =
        EntryItemMoods.nameToColor;

    //get recent entries
    final Entries = (await getRecentEntries());
    final List<XEntryItem> ResultArray = [];

    //convert each into a widget
    for (var i in Entries) {
      ResultArray.add(XEntryItem(
          renderParent: renderParent,
          id: i["id"],
          mood: NameToColor(i["mood"]),
          date: i["date"],
          title: i["title"]));
    }

    //return the array of widgets
    return ResultArray;
  } catch (e) {
    //generic exception
    throw Exception(e);
  }
}
