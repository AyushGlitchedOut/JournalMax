import 'package:journalmax/models/EntryItemMoods.dart';
import 'package:journalmax/widgets/XEntryItem.dart';
import 'package:journalmax/services/DataBaseService.dart';

Future<List<XEntryItem>> searchEntries(
    String query, dynamic renderParent) async {
  try {
    //get entries by the query
    final results = await getEntry(query);

    //loop over the results and return a widget for each of them
    final List<XEntryItem> items = [];

    for (var item in results) {
      items.add(XEntryItem(
          mood: EntryItemMoods.nameToColor(item["mood"].toString()),
          date: item["date"].toString(),
          title: item["title"].toString(),
          id: int.parse(item["id"].toString()),
          renderParent: renderParent));
    }

    return items;
  } catch (e) {
    //generic exception
    throw Exception(e);
  }
}
