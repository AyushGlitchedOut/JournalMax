import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/MultimediaAddDialog.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XDropDown.dart';
import 'package:journalmax/Widgets/XFloatingButton.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/EntryItem.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final TextEditingController _controller = TextEditingController();

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
          _MoodDropDown(),
          XIconLabelButton(
            icon: Icons.image_outlined,
            label: "Add Multimedia",
            onclick: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Center(child: MultimediaAddDialog());
                }),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(5.0),
              // decoration: BoxDecoration(),
              child: SingleChildScrollView(
                child: TextField(
                  controller: _controller,
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
                  minLines: 13,
                  maxLines: 20,
                ),
              ),
            ),
          ),
          XIconLabelButton(
            icon: Icons.save_as_rounded,
            label: "Save Entry",
            onclick: () {
              print(_controller.text);
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

  XDropdown _MoodDropDown() {
    return XDropdown(
      label: "Mood",
      list: const [
        "happy",
        "sad",
        "angry",
        "excited",
        "mundane",
        "surprised",
        "frustrated",
        "doubtful",
        "anxious"
      ],
      onchange: (value) {
        // if (value == "happy") {setState((){moods = EntryItemMoods.};happy}
        // else if (value == "happy") {setState((){moods = EntryItemMoods.};happy}
        switch (value) {
          case "happy":
            setState(() {
              moods = EntryItemMoods.happy;
            });
            print(moods);
            break;
          case "sad":
            setState(() {
              moods = EntryItemMoods.sad;
            });
            print(moods);
            break;
          case "angry":
            setState(() {
              moods = EntryItemMoods.angry;
            });
            print(moods);
            break;
          case "excited":
            setState(() {
              moods = EntryItemMoods.excited;
            });
            print(moods);
            break;
          case "mundane":
            setState(() {
              moods = EntryItemMoods.mundane;
            });
            print(moods);
            break;
          case "surprised":
            setState(() {
              moods = EntryItemMoods.surprised;
            });
            print(moods);
            break;
          case "frustrated":
            setState(() {
              moods = EntryItemMoods.frustrated;
            });
            print(moods);
            break;
          case "doubtful":
            setState(() {
              moods = EntryItemMoods.doubtful;
            });
            print(moods);
            break;
          case "anxious":
            setState(() {
              moods = EntryItemMoods.anxious;
            });
            print(moods);
            break;
          default:
        }
      },
    );
  }
}
