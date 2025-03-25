import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/pages/EditorPage.dart';
import 'package:journalmax/widgets/dialogs/XExitDialog.dart';

class XDrawer extends StatelessWidget {
  final String currentPage;
  const XDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0))),
      elevation: 100,
      shadowColor: colors.surface,
      width: 300,
      backgroundColor: colors.surface,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          colors.primary,
          colors.onPrimary,
          colors.secondary,
          colors.surface,
          colors.tertiary,
          colors.onSurface
        ], begin: Alignment.bottomRight, end: Alignment.topLeft)),
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
                  decoration: BoxDecoration(
                      boxShadow: [
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
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0))),
                  //App's Icon
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: const AspectRatio(
                      aspectRatio: 128 / 126,
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'assets/AppIcon.png',
                        ),
                      ),
                    ),
                  ),
                )),
            screensList(context),
            drawerTile(Icons.exit_to_app_rounded, context, "Quit App", "/exit",
                highlight: false)
          ],
        ),
      ),
    );
  }

  //List of tiles to display to navigate to each screen
  Column screensList(BuildContext context) {
    return Column(
      children: [
        drawerTile(Icons.home, context, "Homepage", "/homepage",
            highlight: currentPage == "homepage"),
        drawerTile(Icons.storage, context, "Collection", "/collection",
            highlight: currentPage == "collection" || currentPage == "find"),
        drawerTile(Icons.create, context, "New Entry", "/editor",
            highlight: currentPage == "editor" || currentPage == "view"),
        drawerTile(Icons.settings, context, "Settings", "/settings",
            highlight: currentPage == "settings"),
        //display test page only if its debug build
        if (kDebugMode)
          drawerTile(Icons.adb, context, "Test DB", "/test", highlight: false)
      ],
    );
  }

  //drawerTile which allow to navigate to different pages
  GestureDetector drawerTile(
      IconData icon, BuildContext context, String title, String? path,
      {required bool highlight}) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      //navigate to the given page
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
            gradient: LinearGradient(
                stops: const [0.8, 0.95],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  highlight ? colors.primary : colors.tertiary,
                  Colors.grey[700]!
                ]),
            color: highlight ? colors.primary : colors.tertiary,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(color: colors.shadow, offset: const Offset(-1.5, -1.5)),
              BoxShadow(color: colors.primary, offset: const Offset(1.5, 1.5))
            ]),
        child: ListTile(
          //Page Icon
          leading: Icon(icon,
              size: 35.0,
              color: highlight ? colors.onPrimary : colors.onSurface,
              shadows: [
                Shadow(color: colors.outline, offset: const Offset(-1.0, -1.0))
              ]),
          //Page title
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
