import 'package:flutter/material.dart';

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
          Column(),
          XDrawerTile(Icons.exit_to_app_rounded, context, "Quit App")
        ],
      ),
    );
  }

  Container XDrawerTile(IconData icon, BuildContext context, String title) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: colors.tertiary, borderRadius: BorderRadius.circular(25.0)),
      child: ListTile(
        leading: Icon(
          icon,
          size: 35.0,
          color: colors.onSurface,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: colors.primary,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0),
        ),
      ),
    );
  }
}
