import 'package:flutter/material.dart';
import 'package:journalmax/Themes/ThemeProvider.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/Widgets/XFloatingButton.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XLabel.dart';
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
  Future<void> loadTheme(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    print(Provider.of<Themeprovider>(context, listen: false).isDarkMode ==
        prefs.getBool("isDarkMode"));

    if (Provider.of<Themeprovider>(context, listen: false).isDarkMode ==
        prefs.getBool("isDarkMode")) {
      return;
    } else {
      Provider.of<Themeprovider>(context, listen: false).toggleThemes();
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
          Expanded(
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
          ),
          const XLabel(label: "Options"),
          const XIconLabelButton(
            icon: Icons.auto_awesome_sharp,
            label: "Get a random memory",
          ),
          XIconLabelButton(
            icon: Icons.sync_sharp,
            label: "Synchronize your Diary",
            onclick: () => Navigator.pushReplacementNamed(context, "/sync"),
          ),
          XIconLabelButton(
            icon: Icons.search_sharp,
            label: "Find an Entry",
            onclick: () => Navigator.pushReplacementNamed(context, "/find"),
          )
        ],
      ),
      floatingActionButton: XFloatingButton(
        icon: Icons.add,
        onclick: () => Navigator.pushReplacementNamed(context, "/editor"),
      ),
    );
  }
}
