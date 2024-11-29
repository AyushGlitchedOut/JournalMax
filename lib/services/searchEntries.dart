import 'package:journalmax/Widgets/XEntryItem.dart';

List<XEntryItem> searchEntries(String query) {
  print(query);
  return [
    XEntryItem(
      mood: EntryItemMoods.angry,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now().toString(),
    ),
    XEntryItem(
      mood: EntryItemMoods.anxious,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now().toString(),
    ),
    XEntryItem(
      mood: EntryItemMoods.doubtful,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now().toString(),
    ),
    XEntryItem(
      mood: EntryItemMoods.excited,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now().toString(),
    ),
    XEntryItem(
      mood: EntryItemMoods.frustrated,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now().toString(),
    ),
    XEntryItem(
      mood: EntryItemMoods.happy,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now().toString(),
    ),
    XEntryItem(
      mood: EntryItemMoods.mundane,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now().toString(),
    ),
    XEntryItem(
      mood: EntryItemMoods.sad,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now().toString(),
    ),
    XEntryItem(
      mood: EntryItemMoods.surprised,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now().toString(),
    ),
  ];
}
