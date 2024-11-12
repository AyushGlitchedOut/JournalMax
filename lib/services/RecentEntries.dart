import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/EntryItem.dart';

List<EntryItem> recentEntries() {
  //TODO : implement the actual stuff
  return [
    EntryItem(
      mood: EntryItemMoods.angry,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now(),
    ),
    EntryItem(
      mood: EntryItemMoods.anxious,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now(),
    ),
    EntryItem(
      mood: EntryItemMoods.doubtful,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now(),
    ),
    EntryItem(
      mood: EntryItemMoods.excited,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now(),
    ),
    EntryItem(
      mood: EntryItemMoods.frustrated,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now(),
    ),
    EntryItem(
      mood: EntryItemMoods.happy,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now(),
    ),
    EntryItem(
      mood: EntryItemMoods.mundane,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now(),
    ),
    EntryItem(
      mood: EntryItemMoods.sad,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now(),
    ),
    EntryItem(
      mood: EntryItemMoods.surprised,
      title: "Lorem Ipsum dolor sit Amet iuerrvg iuesr",
      date: DateTime.now(),
    ),
  ];
}
