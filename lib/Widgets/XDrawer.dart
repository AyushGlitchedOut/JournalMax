import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/Pages/EditorPage.dart';
import 'package:journalmax/Widgets/Dialogs/XExitDialog.dart';

class XDrawer extends StatelessWidget {
  final String currentPage;
  const XDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Drawer(
      shape: const RoundedRectangleBorder(
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
              margin: const EdgeInsets.only(top: 40.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(-2, -2),
                      color: colors.shadow,
                      blurRadius: 2.0),
                  BoxShadow(
                      offset: const Offset(2, 2),
                      color: colors.shadow,
                      blurRadius: 2.0)
                ],
              ),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      offset: const Offset(2, 2),
                      color: colors.shadow,
                      blurRadius: 2.0),
                  BoxShadow(
                      offset: const Offset(-2, -2),
                      color: colors.shadow,
                      blurRadius: 2.0),
                  BoxShadow(
                      offset: const Offset(-2, 2),
                      color: colors.shadow,
                      blurRadius: 2.0),
                  BoxShadow(
                      offset: const Offset(2, -2),
                      color: colors.shadow,
                      blurRadius: 2.0)
                ], borderRadius: const BorderRadius.all(Radius.circular(15.0))),
                child: const Image(
                  fit: BoxFit.fill,
                  height: 150,
                  width: 150,
                  image: AssetImage(
                    'assets/AppIcon.png',
                  ),
                ),
              )),
          ScreensList(context),
          XDrawerTile(Icons.exit_to_app_rounded, context, "Quit App", "/exit",
              highlight: false)
        ],
      ),
    );
  }

  Column ScreensList(BuildContext context) {
    return Column(
      children: [
        XDrawerTile(Icons.home, context, "Homepage", "/homepage",
            highlight: currentPage == "homepage"),
        XDrawerTile(Icons.storage, context, "Collection", "/collection",
            highlight: currentPage == "collection" || currentPage == "find"),
        XDrawerTile(Icons.create, context, "New Entry", "/editor",
            highlight: currentPage == "editor" || currentPage == "view"),
        XDrawerTile(Icons.settings, context, "Settings", "/settings",
            highlight: currentPage == "settings"),
        XDrawerTile(Icons.sync, context, "Synchronise", "/sync",
            highlight: currentPage == "sync"),
        if (kDebugMode)
          XDrawerTile(Icons.adb, context, "Test DB", "/test", highlight: false)
      ],
    );
  }

  GestureDetector XDrawerTile(
      IconData icon, BuildContext context, String title, String? path,
      {required bool highlight}) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () async {
        if (path == "/exit") {
          XExitDialog(context);
          return;
        }
        if (path == "/editor") {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return EditorPage();
          }));
          return;
        }
        Navigator.pushNamed(context, path!);
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: highlight ? colors.primary : colors.tertiary,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(color: colors.shadow, offset: const Offset(-1.5, -1.5)),
              BoxShadow(color: colors.primary, offset: const Offset(1.5, 1.5))
            ]),
        child: ListTile(
          leading: Icon(icon,
              size: 35.0,
              color: highlight ? colors.onPrimary : colors.onSurface,
              shadows: [
                Shadow(
                    color: highlight ? colors.primary : colors.secondary,
                    offset: const Offset(-1.0, -1.0))
              ]),
          title: Text(
            title,
            style: TextStyle(
                color: highlight ? colors.onPrimary : colors.primary,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: highlight ? colors.secondary : colors.onPrimary,
                    offset: const Offset(-1.0, -1.0),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
