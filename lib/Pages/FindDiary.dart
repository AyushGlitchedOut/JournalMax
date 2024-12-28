import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/Widgets/XSearchBar.dart';
import 'package:journalmax/services/searchEntries.dart';

class FindDiaryEntryPage extends StatefulWidget {
  FindDiaryEntryPage({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  State<FindDiaryEntryPage> createState() => _FindDiaryEntryPageState();
}

class _FindDiaryEntryPageState extends State<FindDiaryEntryPage> {
  List<XEntryItem> results = [];
  late FocusNode focus;

  //READ
  void Search(String query) async {
    final searchResults = await searchEntries(query, Search);
    setState(() {
      results = searchResults;
    });
  }

  @override
  void initState() {
    super.initState();
    focus = FocusNode();
    focus.requestFocus();
  }

  @override
  void dispose() {
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "Find Entry",
          )),
      drawer: const XDrawer(currentPage: "find"),
      backgroundColor: colors.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XSearchBar(
            searchFunction: Search,
            controller: widget._searchController,
            focus: focus,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: colors.surface,
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
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: results,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
