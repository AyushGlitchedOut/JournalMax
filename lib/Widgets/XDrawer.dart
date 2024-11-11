import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journalmax/Widgets/ExitDialog.dart';

class XDrawer extends StatelessWidget {
  const XDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0))),
      elevation: 25,
      shadowColor: colors.primary,
      width: 300,
      backgroundColor: colors.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 70.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: colors.outline, width: 3.0))),
            child: Text(
              "JournalMax",
              style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 35.0,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              XDrawerTile(Icons.home, context, "Homepage", "/homepage"),
              XDrawerTile(Icons.storage, context, "Collection", "/collection"),
              XDrawerTile(Icons.create, context, "New Entry", "/editor"),
              XDrawerTile(Icons.settings, context, "Settings", "/settings"),
              XDrawerTile(Icons.sync, context, "Synchronise", "/sync"),
            ],
          ),
          XDrawerTile(Icons.exit_to_app_rounded, context, "Quit App", "/exit")
        ],
      ),
    );
  }

  GestureDetector XDrawerTile(
      IconData icon, BuildContext context, String title, String? path) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        if (path == "/exit") {
          ExitDialog(context);
          return;
        }
        Navigator.pushReplacementNamed(context, path!);
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: colors.tertiary,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(color: colors.shadow, offset: Offset(-1.5, -1.5))
            ]),
        child: ListTile(
          leading: Icon(icon, size: 35.0, color: colors.onSurface, shadows: [
            Shadow(color: colors.onPrimary, offset: Offset(-1.0, -1.0))
          ]),
          title: Text(
            title,
            style: TextStyle(
                color: colors.primary,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: colors.onPrimary,
                    offset: Offset(-1.0, -1.0),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
