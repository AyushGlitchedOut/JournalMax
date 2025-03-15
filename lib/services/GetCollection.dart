import 'package:flutter/material.dart';
import 'package:journalmax/models/EntryItemMoods.dart';
import 'package:journalmax/widgets/XEntryItem.dart';
import 'package:journalmax/services/DataBaseService.dart';

//get a widget list of all the entires for the collection page
Future<List<Widget>> getCollection(void Function() renderParent) async {
  try {
    //specify the nameToColor function
    const Map<String, Color> Function(String query) nametoColor =
        EntryItemMoods.nameToColor;

    final List<Widget> entryList = [];

    //get all the entires
    final entries = await getAllEntry();

    //loop over all the entries and create a widget for each of them
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
    //throw the generic exception
    throw Exception(e);
  }
}
