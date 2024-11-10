import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';

class ViewerPage extends StatelessWidget {
  const ViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "View Entry",
          )),
      drawer: XDrawer(),
      backgroundColor: colors.surface,
    );
  }
}
