import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journalmax/Pages/EditorPage.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

//
//

//
//
//
class XEntryItem extends StatelessWidget {
  final int id;
  final Map<String, Color> mood;
  final String title;
  final String date;
  final dynamic renderParent;
  const XEntryItem(
      {super.key,
      required this.mood,
      required this.date,
      required this.title,
      required this.id,
      required this.renderParent});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        DeleteDialog(context, id);
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => EditorPage(
                      createNewEntry: false,
                      UpdateId: id,
                    )));
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
              color: colors.surface,
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
                    date,
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

  Future<dynamic> DeleteDialog(BuildContext context, int id) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    HapticFeedback.selectionClick();
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
              'Do you Really want to delete this Entry? {id:$id}',
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
                              WidgetStatePropertyAll(colors.onPrimary)),
                      onPressed: () {
                        deleteEntry(id);
                        Navigator.of(context).pop();
                        renderParent();
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900]),
                      )),
                  const SizedBox(
                    width: 10.0,
                  ),
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
