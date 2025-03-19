import 'package:flutter/material.dart';
import 'package:journalmax/models/EntryItemMoods.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/widgets/XSnackBar.dart';

//Dialog in editor page to change the mood to save in the entry
class MoodChangeDialog extends StatefulWidget {
  //setState funtion to change the mood in editor page
  final void Function(String currentmood) returnMood;
  //already set mood
  final String? currentmood;
  const MoodChangeDialog(
      {super.key, required this.returnMood, required this.currentmood});

  @override
  State<MoodChangeDialog> createState() => _MoodChangeDialogState();
}

class _MoodChangeDialogState extends State<MoodChangeDialog> {
  String currentMood = "Happy";
  final moods = EntryItemMoods.moods;

  @override
  void initState() {
    //set mood in widget to obtained mood from editor page
    currentMood = widget.currentmood!;
    super.initState();
  }

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
                //map over the list of moods in the model and create an option for each mood
                children: moods.map<Widget>((mood) {
          return Row(
            children: [
              //Radiobutton
              Radio(
                  activeColor: Colors.red,
                  fillColor: WidgetStatePropertyAll(Colors.grey.shade500),
                  value: mood,
                  groupValue: currentMood,
                  //onclick that changes the reports te selected mood and changes the currentmood
                  onChanged: (value) {
                    widget.returnMood(currentMood);
                    setState(() {
                      currentMood = value!;
                    });
                  }),
              //The label of the color
              Text(
                mood,
                style: const TextStyle(fontSize: 17.0),
              ),
            ],
          );
        }).toList())),
        actions: [
          //upon clicking the OK button, return the entry to the editor page and display a snackbar of the changed color
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            actionButton(
                onclick: () {
                  widget.returnMood(currentMood);
                  showSnackBar('Changed Entry Mood To $currentMood', context);
                  Navigator.pop(context);
                },
                text: "OK",
                isForDeleteOrCancel: false,
                colors: colors)
          ])
        ]);
  }
}
