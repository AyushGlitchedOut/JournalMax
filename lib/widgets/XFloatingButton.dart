import 'package:flutter/material.dart';

//Floating button used for going to Editor or Viewer Page
class XFloatingButton extends StatelessWidget {
  final void Function()? onclick;
  final IconData icon;
  const XFloatingButton({super.key, this.onclick, required this.icon});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return FloatingActionButton(
      onPressed: onclick ?? () {},
      shape: CircleBorder(side: BorderSide(color: colors.outline, width: 1.0)),
      foregroundColor: colors.primary,
      backgroundColor: colors.onPrimary,
      child: Icon(
        icon,
        size: 40.0,
        shadows: [
          BoxShadow(
            color: colors.shadow,
            offset: const Offset(-1.0, -1.0),
          ),
          BoxShadow(
            color: colors.tertiary,
            offset: const Offset(1.0, 1.0),
          ),
        ],
      ),
    );
  }
}
