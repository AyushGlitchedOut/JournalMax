import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/DataBaseService.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () async {
                pushEntry(Entry(
                    title: "Test Entry",
                    content: "Test Entry Content",
                    mood: "Excited",
                    date: DateTime.now().toString()));
              },
              child: const Text("Push a Test Entry")),
          ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController controller =
                          TextEditingController();
                      return AlertDialog(
                        content: TextField(
                          controller: controller,
                        ),
                        actions: [
                          actionButton(
                              onclick: () async {
                                final result = await getEntry(controller.text);
                                for (dynamic i in result) {
                                  if (kDebugMode) print("Entry Found:" + i);
                                }
                              },
                              text: "OK",
                              isForDeleteOrCancel: false,
                              colors: colors)
                        ],
                      );
                    });
              },
              child: const Text("Find an Entry")),
          ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController controller =
                          TextEditingController();
                      return AlertDialog(
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              hintText: "Enter id to modfiy"),
                        ),
                        actions: [
                          actionButton(
                              onclick: () async {
                                updateEntry(
                                    int.parse(controller.text),
                                    Entry(
                                        title: "This is a modified Title",
                                        content:
                                            "This content was modified at ${DateTime.now()}",
                                        mood: "Neutral",
                                        date: DateTime.now().toString()));
                              },
                              text: "OK",
                              isForDeleteOrCancel: false,
                              colors: colors)
                        ],
                      );
                    });
              },
              child: const Text("Update an Entry")),
          ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController controller =
                          TextEditingController();
                      return AlertDialog(
                        content: TextField(
                          controller: controller,
                          decoration:
                              const InputDecoration(hintText: "Enter an Id"),
                        ),
                        actions: [
                          actionButton(
                              onclick: () async {
                                print(
                                    "Got Entry: ${await getEntryById(int.parse(controller.text))}");
                              },
                              text: "OK",
                              isForDeleteOrCancel: false,
                              colors: colors)
                        ],
                      );
                    });
              },
              child: const Text("Read an Entry")),
          ElevatedButton(
              onPressed: () async {
                final result = await getAllEntry();
                for (dynamic i in result) {
                  if (kDebugMode) print("Entry: $i");
                }
              },
              child: const Text("Dump All Entries")),
          ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController controller =
                          TextEditingController();
                      return AlertDialog(
                        content: TextField(
                          controller: controller,
                          decoration:
                              const InputDecoration(hintText: "Enter an Id"),
                        ),
                        actions: [
                          actionButton(
                              onclick: () async {
                                deleteEntry(int.parse(controller.text));
                              },
                              text: "OK",
                              isForDeleteOrCancel: true,
                              colors: colors)
                        ],
                      );
                    });
              },
              child: const Text("Delete an Entry")),
          ElevatedButton(
              onPressed: () async {
                await wipeOrdeleteAllEntry();
              },
              child: const Text("Wipe the DataBase")),
          ElevatedButton(
              onPressed: () async {
                final dataDirectory = await getApplicationDocumentsDirectory();
                final result =
                    await dataDirectory.list(recursive: true).toList();
                for (dynamic i in result) {
                  if (kDebugMode) print("File: $i");
                }
              },
              child: const Text("Dump contents of data directory")),
          ElevatedButton(
              onPressed: () async {
                final cacheDirectory = await getApplicationCacheDirectory();
                final result =
                    await cacheDirectory.list(recursive: true).toList();
                for (dynamic i in result) {
                  if (kDebugMode) print("Cache File: $i");
                }
              },
              child: const Text("Dump Cache Directory"))
        ],
      ),
    );
  }
}
