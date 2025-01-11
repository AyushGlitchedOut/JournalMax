import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "NOT FOR PRODUCTION",
          )),
      drawer: const XDrawer(
        currentPage: "Test",
      ),
      backgroundColor: colors.surface,
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                if (kDebugMode) print(await getEntry("push"));
                if (kDebugMode) print('\n ${await getAllEntry()}');
              },
              child: const Text("GET Entry")),
          ElevatedButton(
              onPressed: () {
                deleteEntry(27);
              },
              child: const Text("DELETE")),
          ElevatedButton(
              onPressed: () {
                updateEntry(
                    7,
                    Entry(
                        title: "Title",
                        content: "Lorem Ipsum Dolor Amet",
                        mood: "Happy",
                        date: "Now"));
              },
              child: const Text("UPDATE")),
          ElevatedButton(
              onPressed: () {
                pushEntry(Entry(
                    content: "Push Entry Content",
                    title: "pushEntry",
                    date: "Now",
                    mood: "Frustrated"));
              },
              child: const Text("PUSH")),
          ElevatedButton(
              onPressed: () {
                wipeOrdeleteAllEntry();
              },
              child: const Text("Wipe ")),
        ],
      ),
    );
  }
}
