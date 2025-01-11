import 'package:flutter/material.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
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
        actionsAlignment: MainAxisAlignment.start,
        alignment: Alignment.topCenter,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.0, color: colors.outline),
            borderRadius: BorderRadius.circular(15.0)),
        title: const Center(
            child: Text(
          "Choose your current Mood",
          style: TextStyle(fontSize: 25.0),
        )),
        content: SingleChildScrollView(
            child: Column(
                children: moods.map<Widget>((mood) {
          return Row(
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
                style: const TextStyle(fontSize: 17.0),
              ),
            ],
          );
        }).toList())),
        actions: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            actionButton(
                onclick: () {
                  widget.returnMood(currentMood);
                  showSnackBar('Changed Entry Mood To $currentMood', context);
                  Navigator.pop(context);
                },
                text: "OK",
                isForDelete: false,
                colors: colors)
          ])
        ]);
  }
}
