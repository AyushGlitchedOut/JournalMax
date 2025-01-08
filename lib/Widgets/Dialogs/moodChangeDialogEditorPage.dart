import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XSnackBar.dart';
import 'package:journalmax/models/EntryModel.dart';

class MoodChangeDialog extends StatefulWidget {
  final void Function(String currentmood) returnMood;
  const MoodChangeDialog({super.key, required this.returnMood});

  @override
  State<MoodChangeDialog> createState() => _MoodChangeDialogState();
}

class _MoodChangeDialogState extends State<MoodChangeDialog> {
  String currentMood = "Happy";
  final moods = EntryItemMoods.moods;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return AlertDialog(
        insetPadding: const EdgeInsets.only(top: 85),
        backgroundColor: colors.onSurface,
        actionsAlignment: MainAxisAlignment.start,
        alignment: Alignment.topCenter,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.0, color: colors.outline),
            borderRadius: BorderRadius.circular(15.0)),
        title: Center(
            child: Text(
          "Choose your current Mood",
          style: TextStyle(color: colors.onPrimary),
        )),
        content: Column(
            children: moods.map<Widget>((mood) {
          return Container(
              child: Row(
            children: [
              Radio(
                  activeColor: Colors.red,
                  fillColor: WidgetStatePropertyAll(Colors.grey.shade500),
                  value: mood,
                  groupValue: currentMood,
                  onChanged: (value) {
                    widget.returnMood(currentMood);
                    setState(() {
                      currentMood = value!;
                    });
                  }),
              Text(
                mood,
                style: TextStyle(color: colors.onPrimary, fontSize: 17.0),
              ),
            ],
          ));
        }).toList()),
        actions: [
          ElevatedButton(
              onPressed: () {
                widget.returnMood(currentMood);
                showSnackBar('Changed Entry Mood To $currentMood', context);
                Navigator.pop(context);
              },
              child: const Text("Done!")),
        ]);
  }
}
