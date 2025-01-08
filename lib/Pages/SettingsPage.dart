import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journalmax/Widgets/Dialogs/WipeEntriesDialogSettingsPage.dart';
import 'package:journalmax/Themes/ThemeProvider.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XSnackBar.dart';
import 'package:journalmax/Widgets/XToggle.dart';
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
            onclick: (value) {
              try {
                Provider.of<Themeprovider>(context, listen: false)
                    .toggleThemes();
                saveTheme(Provider.of<Themeprovider>(context, listen: false)
                    .isDarkMode);
              } on Exception {
                showSnackBar("Error changing Theme", context);
              }
            },
          ),
          XIconLabelButton(
              icon: Icons.delete_forever,
              label: "Delete All Entries",
              onclick: () {
                HapticFeedback.heavyImpact();
                wipeEntriesDialog(context, colors);
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
}
