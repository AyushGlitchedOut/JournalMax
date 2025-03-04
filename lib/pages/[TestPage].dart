import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/DataBaseService.dart';
import 'package:path_provider/path_provider.dart';

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
          ElevatedButton(
              onPressed: () async {
                final Directory directory =
                    await getApplicationDocumentsDirectory();
                List<FileSystemEntity> items =
                    await directory.list(recursive: true).toList();
                for (final file in items) {
                  print(file);
                }
              },
              child: const Text("List Media")),
          ElevatedButton(
              onPressed: () async {
                final Directory directory =
                    await getApplicationDocumentsDirectory();
                List<FileSystemEntity> items = await directory.list().toList();
                for (final file in items) {
                  if (file.path.endsWith(".png") ||
                      file.path.endsWith(".jpg") ||
                      file.path.endsWith(".jpeg") ||
                      file.path.endsWith(".webp")) {
                    print("$file:To Be Deleted");
                    await file.delete();
                  } else {
                    print("Others Found!$file");
                  }
                }
              },
              child: const Text("Delete Media")),
          ElevatedButton(
              onPressed: () async {
                final Directory directory =
                    await getApplicationCacheDirectory();
                final result = await directory.list(recursive: true).toList();
                for (FileSystemEntity i in result) {
                  print(i);
                }
                print(File(
                        "/data/user/0/com.ayushispro2011.journalmax/cache/audio")
                    .readAsBytesSync());
              },
              child: const Text("See cache")),
        ],
      ),
    );
  }
}
