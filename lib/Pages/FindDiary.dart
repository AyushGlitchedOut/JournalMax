import 'package:flutter/material.dart';
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
  List<XEntryItem> Entries = [];
  late FocusNode focus;

  //READ
  void Search(String query) async {
    try {
      setState(() {
        isLoading = true;
      });
      final searchResults = await searchEntries(query, Search);
      setState(() {
        Entries = searchResults;
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
              child: isLoading
                  ? XProgress(colors: colors)
                  : Entries.isEmpty
                      ? const Expanded(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("No Entries found..")],
                        ))
                      : ListView.builder(
                          itemCount: Entries.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int Itemindex) {
                            return Entries[Itemindex];
                          },
                        ),
            ),
          )
        ],
      ),
    );
  }
}
