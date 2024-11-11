import 'package:flutter/material.dart';

class XLabel extends StatelessWidget {
  final String label;
  const XLabel({super.key, required this.label});

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
            color: colors.onSurface),
      ),
    );
  }
}
