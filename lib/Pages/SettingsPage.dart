import 'package:flutter/material.dart';
import 'package:journalmax/Themes/ThemeProvider.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XToggle.dart';
import 'package:journalmax/services/CRUD_Entry.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveTheme(bool isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isDarkMode", isDarkMode);
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "Settings",
          )),
      drawer: const XDrawer(
        currentPage: "settings",
      ),
      backgroundColor: colors.surface,
      body: Column(
        children: [
          XToggle(
            title: "Dark Theme",
            value:
                Provider.of<Themeprovider>(context, listen: false).isDarkMode,
            onclick: () {
              Provider.of<Themeprovider>(context, listen: false).toggleThemes();
              saveTheme(Provider.of<Themeprovider>(context, listen: false)
                  .isDarkMode);
            },
          ),
          XIconLabelButton(
              icon: Icons.delete_forever,
              label: "Delete All Entries",
              onclick: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2.0, color: colors.outline),
                          borderRadius: BorderRadius.circular(15.0)),
                      title: const Row(children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          color: Colors.red,
                        ),
                        Text("Wipe All Entries!!")
                      ]),
                      content: const Text(
                          "This action will permanently delete all the Entries. Do you really wanna do it?"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Wipe_deleteAllEntry();
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.red),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No"))
                      ],
                    );
                  })),
          const XIconLabelButton(
            icon: Icons.book,
            label: "App Licenses",
          ),
          const XIconLabelButton(
            icon: Icons.person,
            label: "About Author",
          ),
          const XIconLabelButton(
            icon: Icons.code,
            label: "Source Code",
          )
        ],
      ),
    );
  }
}
