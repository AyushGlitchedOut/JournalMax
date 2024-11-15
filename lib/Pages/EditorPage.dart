import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/MultimediaAddDialog.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XFloatingButton.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  void setMood(Map<String, Color> mood) {
    setState(() {
      moods = mood;
    });
  }

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
          Padding(
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
          ),
          Expanded(
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
          ),
          XIconLabelButton(
            icon: Icons.save_as_rounded,
            label: "Save Entry",
            onclick: () {
              print(_contentController.text);
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
}

//   XDropdown _MoodDropDown() {
//     return XDropdown(
//       label: "Mood",
//       onchange: (value) {
//         // if (value == "happy") {setState((){moods = EntryItemMoods.};happy}
//         // else if (value == "happy") {setState((){moods = EntryItemMoods.};happy}
//         switch (value) {
//           case "happy":
//             setState(() {
//               moods = EntryItemMoods.happy;
//             });
//             print(moods);
//             break;
//           case "sad":
//             setState(() {
//               moods = EntryItemMoods.sad;
//             });
//             print(moods);
//             break;
//           case "angry":
//             setState(() {
//               moods = EntryItemMoods.angry;
//             });
//             print(moods);
//             break;
//           case "excited":
//             setState(() {
//               moods = EntryItemMoods.excited;
//             });
//             print(moods);
//             break;
//           case "mundane":
//             setState(() {
//               moods = EntryItemMoods.mundane;
//             });
//             print(moods);
//             break;
//           case "surprised":
//             setState(() {
//               moods = EntryItemMoods.surprised;
//             });
//             print(moods);
//             break;
//           case "frustrated":
//             setState(() {
//               moods = EntryItemMoods.frustrated;
//             });
//             print(moods);
//             break;
//           case "doubtful":
//             setState(() {
//               moods = EntryItemMoods.doubtful;
//             });
//             print(moods);
//             break;
//           case "anxious":
//             setState(() {
//               moods = EntryItemMoods.anxious;
//             });
//             print(moods);
//             break;
//           default:
//         }
//       },
//     );
//   }
// }

class MoodChangeDialog extends StatefulWidget {
  void Function(Map<String, Color> mood)? changeMoodFunction;
  MoodChangeDialog({super.key, required this.changeMoodFunction});

  @override
  State<MoodChangeDialog> createState() => _MoodChangeDialogState();
}

class _MoodChangeDialogState extends State<MoodChangeDialog> {
  String currentMood = "happy";
  List<String> moods = [
    "Happy",
    "Sad",
    "Angry",
    "Excited",
    "Mundane",
    "Surprised",
    "Frustrated",
    "Doubtful",
    "Anxious"
  ];

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
                switch (currentMood) {
                  case "Happy":
                    widget.changeMoodFunction!(EntryItemMoods.happy);
                    print(currentMood);
                    break;
                  case "Sad":
                    widget.changeMoodFunction!(EntryItemMoods.sad);
                    print(currentMood);
                    break;
                  case "Angry":
                    widget.changeMoodFunction!(EntryItemMoods.angry);
                    print(currentMood);
                    break;
                  case "Excited":
                    widget.changeMoodFunction!(EntryItemMoods.excited);
                    print(currentMood);
                    break;
                  case "Mundane":
                    widget.changeMoodFunction!(EntryItemMoods.mundane);
                    print(currentMood);
                    break;
                  case "Surprised":
                    widget.changeMoodFunction!(EntryItemMoods.surprised);
                    print(currentMood);
                    break;
                  case "Frustrated":
                    widget.changeMoodFunction!(EntryItemMoods.frustrated);
                    print(currentMood);
                    break;
                  case "Doubtful":
                    widget.changeMoodFunction!(EntryItemMoods.doubtful);
                    print(currentMood);
                    break;
                  case "Anxious":
                    widget.changeMoodFunction!(EntryItemMoods.anxious);
                    print(currentMood);
                    break;
                  default:
                }
                Navigator.pop(context);
              },
              child: const Text("Done!")),
        ]);
  }
}
