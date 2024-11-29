import 'package:flutter/material.dart';

//
//

//
//
//
final class EntryItemMoods {
  static Map<String, Color> NameToColor(String name) {
    switch (name) {
      case "Happy":
        return happy;
      case "Sad":
        return sad;
      case "Angry":
        return angry;
      case "Excited":
        return excited;
      case "Mundane":
        return mundane;
      case "Surprised":
        return surprised;
      case "Frustrated":
        return frustrated;
      case "Doubtful":
        return doubtful;
      case "Anxious":
        return anxious;
      default:
        return happy;
    }
  }

  static List<String> moods = [
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

  static Map<String, Color> angry = {
    "surface": Colors.red.shade200,
    "text": Colors.blue.shade800,
    "secondary": Colors.purple.shade900
  };

  static Map<String, Color> sad = {
    "surface": Colors.blueGrey.shade300,
    "text": Colors.blue.shade600,
    "secondary": Colors.indigo.shade900
  };

  static Map<String, Color> happy = {
    "surface": Colors.yellow.shade300,
    "text": Colors.orange.shade700,
    "secondary": Colors.green.shade700
  };

  static Map<String, Color> excited = {
    "surface": Colors.orange.shade300,
    "text": Colors.deepOrange.shade600,
    "secondary": Colors.redAccent.shade700
  };

  static Map<String, Color> mundane = {
    "surface": Colors.grey.shade300,
    "text": Colors.grey.shade700,
    "secondary": Colors.brown.shade700
  };

  static Map<String, Color> surprised = {
    "surface": Colors.purple.shade200,
    "text": Colors.indigo.shade700,
    "secondary": Colors.deepPurple.shade900
  };

  static Map<String, Color> frustrated = {
    "surface": Colors.redAccent.shade100,
    "text": Colors.red.shade700,
    "secondary": Colors.deepOrange.shade900
  };

  static Map<String, Color> doubtful = {
    "surface": Colors.blueGrey.shade200,
    "text": Colors.blue.shade700,
    "secondary": Colors.indigo.shade900
  };

  static Map<String, Color> anxious = {
    "surface": Colors.orange.shade100,
    "text": Colors.brown.shade800,
    "secondary": Colors.red.shade700
  };
}

class XEntryItem extends StatelessWidget {
  final Map<String, Color> mood;
  final String title;
  final DateTime date;
  const XEntryItem(
      {super.key, required this.mood, required this.date, required this.title});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        DeleteDialog(context);
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: mood["surface"],
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: mood["secondary"]!, offset: const Offset(1.5, 1.5)),
              BoxShadow(color: mood["text"]!, offset: const Offset(-1.5, -1.5))
            ]),
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15.0,
            ),
            Icon(
              Icons.circle,
              size: 10.0,
              color: colors.primary,
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: mood.isEmpty ? colors.primary : mood["text"]),
                    maxLines: 1,
                  ),
                  Text(
                    '${date.year}/${date.month}/${date.day}',
                    style: TextStyle(
                        fontSize: 15.0,
                        color:
                            mood.isEmpty ? colors.primary : mood["secondary"]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> DeleteDialog(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.only(top: 200),
            contentPadding: const EdgeInsets.all(20.0),
            actionsPadding: const EdgeInsets.all(20.0),
            backgroundColor: colors.onSurface,
            actionsAlignment: MainAxisAlignment.start,
            alignment: Alignment.topCenter,
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 2.0, color: colors.outline),
                borderRadius: BorderRadius.circular(15.0)),
            title: Center(
                child: Text(
              "Do you Really want to delete this Entry?",
              style: TextStyle(color: colors.onPrimary),
              textAlign: TextAlign.center,
            )),
            actions: [
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(colors.secondary)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900]),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"))
                ],
              )),
            ],
          );
        });
  }
}
