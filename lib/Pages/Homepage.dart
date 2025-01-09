import 'dart:math';
import 'package:flutter/material.dart';
import 'package:journalmax/Pages/ViewerPage.dart';
import 'package:journalmax/Themes/ThemeProvider.dart';
import 'package:journalmax/Widgets/ContentBox.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/Widgets/XFloatingButton.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XLabel.dart';
import 'package:journalmax/Widgets/XProgress.dart';
import 'package:journalmax/Widgets/XSnackBar.dart';
import 'package:journalmax/services/CRUD_Entry.dart';
import 'package:journalmax/services/RecentEntries.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<XEntryItem> recentEntries = [];
  bool isLoading = true; // Track loading state

  //READ
  Future<void> openRandomEntry(BuildContext context) async {
    try {
      final list = await getAllEntry();
      if (list.isEmpty) {
        showSnackBar("There isn't any existing Entry!", context);
        return;
      }
      final int random = Random().nextInt(list.length);
      final entry = list[random];
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ViewerPage(
          Id: int.parse(entry["id"].toString()),
        );
      }));
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  //UI

  Future<void> loadTheme(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (Provider.of<Themeprovider>(context, listen: false).isDarkMode ==
          prefs.getBool("isDarkMode")) {
        return;
      } else {
        Provider.of<Themeprovider>(context, listen: false).toggleThemes();
      }
    } on Exception {
      showSnackBar("Error loading the ThemeData", context);
    }
  }

  Future<void> awaitRecentEntries() async {
    try {
      setState(() {
        isLoading = true; // Start loading
      });

      // Simulate fetching entries (Replace with actual data fetching logic)
      final loadedEntries = await loadRecentEntries(awaitRecentEntries);

      setState(() {
        recentEntries = loadedEntries;
        isLoading = false; // End loading
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTheme(context);
      awaitRecentEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "Homepage",
          )),
      drawer: const XDrawer(
        currentPage: "homepage",
      ),
      backgroundColor: colors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const XLabel(label: "Recent Entries"),
          recentEntriesBox(colors),
          const XLabel(label: "Options"),
          XIconLabelButton(
            icon: Icons.auto_awesome_sharp,
            label: "Get a random memory",
            onclick: () => openRandomEntry(context),
          ),
          XIconLabelButton(
            icon: Icons.sync_sharp,
            customFontSize: 18.5,
            label: "Synchronize your Diary",
            onclick: () => Navigator.pushNamed(context, "/sync"),
          ),
          XIconLabelButton(
            icon: Icons.search_sharp,
            label: "Find an Entry",
            onclick: () => Navigator.pushNamed(context, "/find"),
          )
        ],
      ),
      floatingActionButton: XFloatingButton(
        icon: Icons.add,
        onclick: () => Navigator.pushNamed(context, "/editor"),
      ),
    );
  }

  Expanded recentEntriesBox(ColorScheme colors) {
    return Expanded(
        child: contentBox(
            child: isLoading
                ? XProgress(colors: colors)
                : recentEntries.isEmpty
                    ? const Center(
                        child: Text(
                          "No recent entries",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )
                    : ListView.builder(
                        itemCount: recentEntries.length,
                        itemBuilder: (BuildContext context, int itemIndex) {
                          return recentEntries[itemIndex];
                        }),
            colors: colors));
  }
}
