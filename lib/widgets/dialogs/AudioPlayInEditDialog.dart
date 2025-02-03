import 'package:flutter/material.dart';

class AudioPlayInEditModeDialog extends StatefulWidget {
  const AudioPlayInEditModeDialog({super.key});

  @override
  State<AudioPlayInEditModeDialog> createState() =>
      _AudioPlayInEditModeDialogState();
}

class _AudioPlayInEditModeDialogState extends State<AudioPlayInEditModeDialog> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Dialog(
      insetPadding: const EdgeInsets.all(0.0),
      elevation: 5.0,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.0, color: colors.outline),
          borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 0.95,
      ),
    );
  }
}
