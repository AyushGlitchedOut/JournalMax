import 'package:flutter/material.dart';

class XDialogButton extends StatelessWidget {
  const XDialogButton(
      {super.key,
      required this.colors,
      required this.icon,
      required this.title,
      this.onclick});

  final ColorScheme colors;
  final String title;
  final IconData icon;
  final void Function()? onclick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: colors.onSurface,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: colors.shadow, offset: const Offset(1.5, 1.5)),
            BoxShadow(color: colors.outline, offset: const Offset(-1.5, -1.5))
          ]),
      child: ElevatedButton(
          style: ButtonStyle(
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  side: BorderSide(color: colors.outline),
                  borderRadius: BorderRadius.circular(10.0))),
              padding: WidgetStateProperty.all(const EdgeInsets.all(5.0)),
              alignment: Alignment.topLeft),
          onPressed: onclick,
          child: Row(
            children: [
              Icon(
                icon,
                size: 40.0,
                color: colors.onPrimary,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20.0, color: colors.tertiary),
              )
            ],
          )),
    );
  }
}
