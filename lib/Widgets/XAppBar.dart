import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XExitDialog.dart';

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
          Shadow(color: colors.shadow, offset: const Offset(-1.5, -1.5))
        ]),
        // onPressed: () {},
        style: ButtonStyle(
            iconSize: const WidgetStatePropertyAll(35.0),
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
                Shadow(
                    color: colors.shadow,
                    offset: const Offset(-1.5, -1.5),
                    blurRadius: 1.0)
              ]),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              XExitDialog(context);
            },
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.exit_to_app,
                  size: 35.0,
                  color: colors.onPrimary,
                  shadows: [
                    Shadow(
                        color: colors.shadow, offset: const Offset(-1.5, -1.5))
                  ]),
            ))
      ],
    );
  }
}
