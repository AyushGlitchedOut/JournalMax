import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

Future<List<XEntryItem>> searchEntries(
    String query, dynamic renderParent) async {
  try {
    final result = await getEntry(query);
    final items = result.map((item) {
      return XEntryItem(
          mood: EntryItemMoods.nameToColor(item["mood"].toString()),
          date: item["date"].toString(),
          title: item["title"].toString(),
          id: int.parse(item["id"].toString()),
          renderParent: renderParent);
    }).toList();
    return items;
  } catch (e) {
    throw Exception(e);
  }
}
