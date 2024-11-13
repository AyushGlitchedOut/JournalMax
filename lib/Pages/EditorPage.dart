import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XDropDown.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XLabel.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "Editor Page",
          )),
      drawer: const XDrawer(
        currentPage: "editor",
      ),
      backgroundColor: colors.surface,
      body: Column(
        children: [
          XDropdown(label: "Mood", list: [
            "happy",
            "sad",
            "angry",
            "excited",
            "mundane",
            "surprised",
            "frustrated",
            "doubtful",
            "anxious"
          ]),
          XIconLabelButton(icon: Icons.image_outlined, label: "Add Multimedia")
        ],
      ),
    );
  }
}
