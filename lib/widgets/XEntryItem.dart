import 'package:flutter/material.dart';
import 'package:journalmax/pages/ViewerPage.dart';
import 'package:journalmax/widgets/dialogs/EntryDeleteDialog.dart';

//Widget used all over the app to represent a single Entry
//
class XEntryItem extends StatelessWidget {
  final int id;
  final Map<String, Color> mood;
  final String title;
  final String date;
  //a method given to entry so that if its deleted, it re-renders the parent widget to refelct that change
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
      //Open the entry delete dialog if its long pressed
      onLongPressStart: (LongPressStartDetails details) {
        deleteDialog(context, id, renderParent);
      },
      //navigate to viewer page for viewing the entry upon clicking
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ViewerPage(
                      providedEntryId: id,
                    )));
        await Future.delayed(const Duration(milliseconds: 500));
        renderParent();
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
            //A circle icon acting as a bullet
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
                  //The title of the entry
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: mood.isEmpty ? colors.primary : mood["text"]),
                    maxLines: 1,
                  ),
                  //The date of creation
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
}
