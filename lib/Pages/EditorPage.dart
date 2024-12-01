import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/MultimediaAddDialog.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XFloatingButton.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/services/InsertEntry.dart';
import 'package:provider/provider.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  Future<void> CreateEntry() async {
    await insertEntry(_titleController.text, _contentController.text,
        currentmood, DateTime.now().toString(), null, null, null);
  }

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  void setMood(Map<String, Color> mood) {
    setState(() {
      moods = mood;
    });
  }

  void setCurrentMoodString(String mood) {
    print(currentmood);
    setState(() {
      currentmood = mood;
    });
  }

  String currentmood = "Happy";
  Map<String, dynamic> moods = EntryItemMoods.happy;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "Editor Page",
          )),
      drawer: const XDrawer(
        currentPage: "editor",
      ),
      backgroundColor: colors.surface,
      body: Column(
        children: [
          XIconLabelButton(
            icon: Icons.mood,
            label: "What's your current mood?",
            customFontSize: 19.0,
            onclick: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MoodChangeDialog(
                    changeMoodFunction: setMood,
                    returnMood: setCurrentMoodString,
                  );
                }),
          ),
          XIconLabelButton(
            icon: Icons.image_outlined,
            label: "Add Multimedia",
            onclick: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Center(child: XMultimediaAddDialog());
                }),
          ),
          TitleBar(),
          ContentBox(),
          XIconLabelButton(
            icon: Icons.save_as_rounded,
            label: "Save Entry",
            onclick: () {
              CreateEntry();
            },
          )
        ],
      ),
      floatingActionButton: XFloatingButton(
        icon: Icons.remove_red_eye_outlined,
        //later pass arguments of uid of current document
        onclick: () => Navigator.pushReplacementNamed(context, "/view"),
      ),
    );
  }

  Expanded ContentBox() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        // decoration: BoxDecoration(),
        child: SingleChildScrollView(
          child: TextField(
            controller: _contentController,
            autofocus: true,
            enabled: true,
            style: TextStyle(color: moods["text"]),
            decoration: InputDecoration(
                hintText: "Enter your thoughts here!",
                hintStyle: TextStyle(color: moods["secondary"]),
                filled: true,
                fillColor: moods["surface"],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: moods["secondary"]))),
            minLines: 12,
            maxLines: 20,
          ),
        ),
      ),
    );
  }

  Padding TitleBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _titleController,
        decoration: InputDecoration(
            hintText: "Enter the title here...",
            hintStyle: TextStyle(color: moods["text"]),
            filled: true,
            fillColor: moods["surface"],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: moods["text"]))),
      ),
    );
  }
}

// ignore: must_be_immutable
class MoodChangeDialog extends StatefulWidget {
  void Function(Map<String, Color> mood)? changeMoodFunction;
  void Function(String currentmood) returnMood;
  MoodChangeDialog(
      {super.key, required this.changeMoodFunction, required this.returnMood});

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
                    print(value);
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
                widget.changeMoodFunction!(
                    EntryItemMoods.NameToColor(currentMood));
                Navigator.pop(context);
              },
              child: const Text("Done!")),
        ]);
  }
}
