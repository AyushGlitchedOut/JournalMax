import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XDropDown.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/services/getCollection.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

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
            onclick: () => Navigator.pushReplacementNamed(context, "/find"),
          ),
          const XDropdown(
            label: "Sort By:",
            list: ["Yearly", "Monthly", "Date"],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(5.0),
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
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: getCollection(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
