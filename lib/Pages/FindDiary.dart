import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/ContentBox.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/Widgets/XProgress.dart';
import 'package:journalmax/Widgets/XSearchBar.dart';
import 'package:journalmax/Widgets/XSnackBar.dart';
import 'package:journalmax/services/searchEntries.dart';

class FindDiaryEntryPage extends StatefulWidget {
  FindDiaryEntryPage({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  State<FindDiaryEntryPage> createState() => _FindDiaryEntryPageState();
}

class _FindDiaryEntryPageState extends State<FindDiaryEntryPage> {
  bool isLoading = false;
  List<XEntryItem> entries = [];
  late FocusNode focus;

  //READ
  void search(String query) async {
    try {
      setState(() {
        isLoading = true;
      });
      final searchResults = await searchEntries(query, search);
      setState(() {
        entries = searchResults;
        isLoading = false;
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
      resizeToAvoidBottomInset: false,
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
            searchFunction: search,
            controller: widget._searchController,
            focus: focus,
          ),
          Expanded(
            child: contentBox(
                width: MediaQuery.of(context).size.width,
                child: isLoading
                    ? XProgress(colors: colors)
                    : entries.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "No Entries Found...",
                                  style: TextStyle(color: colors.primary),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: entries.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int itemIndex) {
                              return entries[itemIndex];
                            }),
                colors: colors),
          )
        ],
      ),
    );
  }
}
