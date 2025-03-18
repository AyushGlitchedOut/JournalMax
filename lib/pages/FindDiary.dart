import 'package:flutter/material.dart';
import 'package:journalmax/widgets/ContentBox.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/widgets/XEntryItem.dart';
import 'package:journalmax/widgets/XProgress.dart';
import 'package:journalmax/widgets/XSearchBar.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/services/SearchEntries.dart';

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

  //Find entries by query
  void search(String query) async {
    try {
      //start loading
      setState(() {
        isLoading = true;
      });

      final searchResults = await searchEntries(query, search);

      //stop loading
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

    //focusnode used for autofocus
    focus = FocusNode();
    focus.requestFocus();
  }

  @override
  void dispose() {
    //dispose focus node
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      //prevent resisizing
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
          //custom searchbar
          XSearchBar(
            searchFunction: search,
            controller: widget._searchController,
            focus: focus,
          ),

          SearchResultsBox(
              isLoading: isLoading, colors: colors, entries: entries)
        ],
      ),
    );
  }
}

class SearchResultsBox extends StatelessWidget {
  const SearchResultsBox({
    super.key,
    required this.isLoading,
    required this.colors,
    required this.entries,
  });

  final bool isLoading;
  final ColorScheme colors;
  final List<XEntryItem> entries;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: contentBox(
          width: MediaQuery.of(context).size.width,
          child: isLoading
              ? XProgress(colors: colors)
              : entries.isEmpty
                  //no entries found message of no entries are there
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
                  //ListView to list the Widget list obtained from search function
                  : ListView.builder(
                      itemCount: entries.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int itemIndex) {
                        return entries[itemIndex];
                      }),
          colors: colors),
    );
  }
}
