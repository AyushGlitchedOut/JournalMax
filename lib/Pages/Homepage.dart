import 'dart:math';
import 'package:flutter/material.dart';
import 'package:journalmax/Pages/ViewerPage.dart';
import 'package:journalmax/Themes/ThemeProvider.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/Widgets/XFloatingButton.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XLabel.dart';
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
    final list = await getAllEntry();
    if (list.length == 0) {
      showSnackBar("There isn't any existing Entry!", context);
      return;
    }
    final int random = Random().nextInt(list.length);
    final entry = list[random];
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ViewerPage(
        Id: int.parse(entry["id"].toString()),
      );
    }));
  }

  //UI

  Future<void> loadTheme(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    if (Provider.of<Themeprovider>(context, listen: false).isDarkMode ==
        prefs.getBool("isDarkMode")) {
      return;
    } else {
      Provider.of<Themeprovider>(context, listen: false).toggleThemes();
    }
  }

  Future<void> awaitRecentEntries() async {
    setState(() {
      isLoading = true; // Start loading
    });

    // Simulate fetching entries (Replace with actual data fetching logic)
    final loadedEntries = await loadRecentEntries(awaitRecentEntries);

    setState(() {
      recentEntries = loadedEntries;
      isLoading = false; // End loading
    });
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
          RecentEntriesBox(colors),
          const XLabel(label: "Options"),
          XIconLabelButton(
            icon: Icons.auto_awesome_sharp,
            label: "Get a random memory",
            onclick: () => openRandomEntry(context),
          ),
          XIconLabelButton(
            icon: Icons.sync_sharp,
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

  Expanded RecentEntriesBox(ColorScheme colors) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: colors.onSurface,
            border: Border.all(color: colors.outline),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: colors.primary,
                  offset: const Offset(-1.5, -1.5),
                  blurRadius: 1.0),
              BoxShadow(
                  color: colors.shadow,
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 1.0),
            ]),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ), // Loader widget
              )
            : recentEntries.isEmpty
                ? const Center(
                    child: Text(
                      "No recent entries",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recentEntries,
                    ),
                  ),
      ),
    );
  }
}
