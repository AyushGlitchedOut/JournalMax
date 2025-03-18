import 'dart:math';
import 'package:flutter/material.dart';
import 'package:journalmax/pages/ViewerPage.dart';
import 'package:journalmax/services/CleanCache.dart';
import 'package:journalmax/themes/ThemeProvider.dart';
import 'package:journalmax/widgets/ContentBox.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/widgets/XEntryItem.dart';
import 'package:journalmax/widgets/XFloatingButton.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';
import 'package:journalmax/widgets/XLabel.dart';
import 'package:journalmax/widgets/XProgress.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/services/DataBaseService.dart';
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

  //Get a random entry from all the entries and open it in viewer Page
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
          providedEntryId: int.parse(entry["id"].toString()),
        );
      }));
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  //Load and process the theme setting
  Future<void> loadTheme(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      //check if the preference even exists
      if (prefs.getBool("isDarkMode") == null) {
        prefs.setBool("isDarkMode", false);
        return;
      }

      //toggle themes if preferences dont match actual theme
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

  //method to await recent Entries
  Future<void> awaitRecentEntries() async {
    try {
      setState(() {
        isLoading = true; // Start loading
      });

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
    //do stuff after loading the UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        //clear the Cache upon app loads
        clearCache();
      } catch (e) {
        showSnackBar(e.toString(), context);
      }
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
          XLabel(label: "Recent Entries"),
          RecentEntriesBox(
              isLoading: isLoading,
              recentEntries: recentEntries,
              colors: colors),
          XLabel(label: "Options"),
          XIconLabelButton(
            icon: Icons.auto_awesome_sharp,
            label: "Get a random memory",
            onclick: () => openRandomEntry(context),
          ),

          //button to take to search page
          XIconLabelButton(
            icon: Icons.search_sharp,
            label: "Find an Entry",
            onclick: () => Navigator.pushNamed(context, "/find"),
          )
        ],
      ),
      floatingActionButton: XFloatingButton(
        //floating button to open editor page to create new entry
        icon: Icons.add,
        onclick: () => Navigator.pushNamed(context, "/editor"),
      ),
    );
  }
}

class RecentEntriesBox extends StatelessWidget {
  const RecentEntriesBox({
    super.key,
    required this.isLoading,
    required this.recentEntries,
    required this.colors,
  });

  final bool isLoading;
  final List<XEntryItem> recentEntries;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: contentBox(
            child: isLoading
                ? XProgress(colors: colors)
                : recentEntries.isEmpty
                    //message if there's no recent Entries
                    ? const Center(
                        child: Text(
                          "No recent entries..",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )
                    //ListView to build from the provided List of Widgets
                    : ListView.builder(
                        itemCount: recentEntries.length,
                        itemBuilder: (BuildContext context, int itemIndex) {
                          return recentEntries[itemIndex];
                        }),
            colors: colors));
  }
}
