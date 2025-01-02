import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XProgress.dart';
import 'package:journalmax/Widgets/XSnackBar.dart';
import 'package:journalmax/services/getCollection.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Widget> Entries = [];
  bool isLoading = true;

  //READ
  Future<void> getEntryCollection() async {
    try {
      setState(() {
        isLoading = true;
      });
      final awaitedEntries = await getCollection(getEntryCollection);
      setState(() {
        Entries = awaitedEntries;
        isLoading = false;
      });
      if (Entries.isEmpty) {
        showSnackBar("There isn't any Entry to show", context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void initState() {
    getEntryCollection();
    super.initState();
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
          XIconLabelButton(
            icon: Icons.search,
            label: "Search for an Entry",
            onclick: () => Navigator.pushNamed(context, "/find"),
          ),
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
                  ? XProgress(colors: colors)
                  : ListView.builder(
                      itemCount: Entries.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int Itemindex) {
                        return Entries[Itemindex];
                      }),
            ),
          ),
        ],
      ),
    );
  }
}
