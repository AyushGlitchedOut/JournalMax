import 'package:flutter/material.dart';
import 'package:journalmax/Themes/ThemeProvider.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XToggle.dart';
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
