import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journalmax/widgets/dialogs/ExportDataDialog.dart';
import 'package:journalmax/widgets/dialogs/ImportDataDialog.dart';
import 'package:journalmax/widgets/dialogs/WipeEntriesDialogSettingsPage.dart';
import 'package:journalmax/themes/ThemeProvider.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/widgets/XToggle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> saveTheme(bool isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isDarkMode", isDarkMode);
}

Future<void> savePreferenceToUseMobileData(bool prefToChange) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("canUseMobileData", prefToChange);
}

Future<bool> getPreferenceToUseMobileData() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("canUseMobileData") == null) {
    await prefs.setBool("canUseMobileData", false);
    return false;
  }
  return prefs.getBool("canUseMobileData") ?? false;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
          FutureBuilder(
              future: getPreferenceToUseMobileData(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? XToggle(
                        title: "Can Use Mobile Data for Sync",
                        value: snapshot.data!,
                        customFontSize: 15.0,
                        onclick: (value) {
                          savePreferenceToUseMobileData(value);
                          setState(() {});
                        },
                      )
                    : const XToggle(title: "Loading Setting...", value: false);
              }),
          XIconLabelButton(
              icon: Icons.delete_forever,
              label: "Delete All Entries",
              onclick: () async {
                HapticFeedback.heavyImpact();
                try {
                  await wipeEntriesDialog(context, colors);
                } catch (e) {
                  showSnackBar(e.toString(), context);
                }
              }),
          XIconLabelButton(
            icon: Icons.download,
            label: "Import a Journalmax database",
            onclick: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ImportDataDialog();
                  });
            },
            customFontSize: 16.0,
          ),
          XIconLabelButton(
            icon: Icons.upload,
            label: "Export current Journalmax Database",
            onclick: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ExportDataDialog();
                  });
            },
            customFontSize: 13.5,
          ),
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
                openLink("https://github.com/AyushGlitchedOut", context),
          ),
          XIconLabelButton(
            icon: Icons.code,
            label: "Source Code",
            onclick: () => openLink(
                "https://github.com/AyushGlitchedOut/JournalMax", context),
          ),
        ],
      ),
    );
  }
}
