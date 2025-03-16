import 'package:flutter/material.dart';
import 'package:journalmax/pages/ViewerPage.dart';
import 'package:journalmax/widgets/dialogs/EntryDeleteDialog.dart';

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
        deleteDialog(context, id, renderParent);
      },
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
}
