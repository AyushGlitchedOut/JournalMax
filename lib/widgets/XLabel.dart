import 'package:flutter/material.dart';

//Simple label that is used to display sections of a page
// ignore: must_be_immutable
class XLabel extends StatelessWidget {
  final String label;
  Color? color;
  XLabel({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.all(7.0),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: color ?? colors.onSurface,
            shadows: const [
              Shadow(
                  offset: Offset(1.5, 1.5), color: Colors.grey, blurRadius: 2)
            ]),
      ),
    );
  }
}
