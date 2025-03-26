import 'package:flutter/material.dart';
import 'package:journalmax/widgets/ContentBox.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';
import 'package:journalmax/widgets/XProgress.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/services/GetCollection.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Widget> entries = [];
  bool isLoading = true;

  //READ
  Future<void> getEntryCollection() async {
    try {
      //start loading
      setState(() {
        isLoading = true;
      });

      //get widget list of All the Entries
      final awaitedEntries = await getCollection(getEntryCollection);

      //stop loading
      setState(() {
        entries = awaitedEntries;
        isLoading = false;
      });

      if (entries.isEmpty) {
        //show snackbar if no entry is there
        showSnackBar("There isn't any Entry to show", context);
      }
    } catch (e) {
      //stop loading
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    // start fetching the collection's entries
    getEntryCollection();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "My Diaries",
          )),
      drawer: const XDrawer(
        currentPage: "collection",
      ),
      backgroundColor: colors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Navigate to Search Page
          XIconLabelButton(
            icon: Icons.search,
            label: "Search for an Entry",
            onclick: () => Navigator.pushNamed(context, "/find"),
          ),
          Expanded(
            child: contentBox(
                child: isLoading
                    ? XProgress(colors: colors)
                    // a listview to build lazy-loaded list of entries from the fetched Widget list
                    : ListView.builder(
                        itemCount: entries.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int itemIndex) {
                          return entries[(entries.length - 1) - itemIndex];
                        }),
                colors: colors,
                context: context),
          ),
        ],
      ),
    );
  }
}
