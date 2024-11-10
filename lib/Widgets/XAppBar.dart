import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class XAppBar extends StatelessWidget {
  final String title;
  const XAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return AppBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.menu_rounded, color: colors.onPrimary, shadows: [
          Shadow(color: colors.shadow, offset: Offset(-1.5, -1.5))
        ]),
        // onPressed: () {},
        style: ButtonStyle(
            iconSize: WidgetStatePropertyAll(35.0),
            shadowColor: WidgetStatePropertyAll(colors.shadow)),
      ),
      backgroundColor: colors.onSurface,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
              color: colors.onPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 23.0,
              shadows: [
                Shadow(color: colors.shadow, offset: Offset(-1.5, -1.5))
              ]),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2.0, color: colors.outline),
                          borderRadius: BorderRadius.circular(2.0)),
                      title: Text("Exit App"),
                      content: Text("Do you really want to exit the App"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            child: Text("OK")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"))
                      ],
                    );
                  });
            },
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.exit_to_app,
                  size: 35.0,
                  color: colors.onPrimary,
                  shadows: [
                    Shadow(color: colors.shadow, offset: Offset(-1.5, -1.5))
                  ]),
            ))
      ],
    );
  }
}
