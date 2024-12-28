import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journalmax/Themes/ThemeProvider.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XSnackBar.dart';
import 'package:journalmax/Widgets/XToggle.dart';
import 'package:journalmax/services/CRUD_Entry.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> saveTheme(bool isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isDarkMode", isDarkMode);
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  //UI
  Future<void> openLink(String url, BuildContext context) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      showSnackBar("Error opening link", context);
    }
  }

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
              onclick: () {
                HapticFeedback.heavyImpact();
                WipeEntriesDialog(context, colors);
              }),
          XIconLabelButton(
            icon: Icons.book,
            label: "App Licenses",
            onclick: () => openLink(
                "https://www.gnu.org/licenses/gpl-3.0.en.html", context),
          ),
          XIconLabelButton(
            icon: Icons.person,
            label: "About Author",
            onclick: () =>
                openLink("https://github.com/AyushisPro2011", context),
          ),
          XIconLabelButton(
            icon: Icons.code,
            label: "Source Code",
            onclick: () => openLink(
                "https://github.com/AyushisPro2011/JournalMax", context),
          )
        ],
      ),
    );
  }

  Future<dynamic> WipeEntriesDialog(BuildContext context, ColorScheme colors) {
    return showDialog(
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
                  onPressed: () async {
                    Wipe_deleteAllEntry();
                    Navigator.of(context).pop();
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
        });
  }
}
