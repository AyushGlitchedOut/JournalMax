import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';

class MultimediaAddPage extends StatelessWidget {
  const MultimediaAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: XAppBar(title: "Add Multimedia"),
      ),
      drawer: const XDrawer(currentPage: "editor"),
      backgroundColor: colors.surface,
      body: Column(
        children: [
          const XIconLabelButton(icon: Icons.location_on, label: "Current Location"),
          const XIconLabelButton(icon: Icons.mic, label: "Record Voice"),
          const XIconLabelButton(icon: Icons.image, label: "Add images"),
          Center(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(colors.onSurface)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK")),
          )
        ],
      ),
      // body: AlertDialog(
      //   insetPadding: const EdgeInsets.only(top: 150),
      //   backgroundColor: colors.onSurface,
      //   actionsAlignment: MainAxisAlignment.start,
      //   alignment: Alignment.topCenter,
      //   shape: RoundedRectangleBorder(
      //       side: BorderSide(width: 2.0, color: colors.outline),
      //       borderRadius: BorderRadius.circular(15.0)),
      //   title: Center(
      //       child: Text(
      //     "Add Multimedia",
      //     style: TextStyle(color: colors.onPrimary),
      //   )),
      //   content: Column(
      //     mainAxisSize:
      //         MainAxisSize.min, // Prevents the column from expanding too much
      //     children: [
      //       XDialogButton(
      //           colors: colors,
      //           icon: Icons.location_on,
      //           title: "Current Location"),
      //       XDialogButton(
      //         colors: colors,
      //         title: "Record Voice",
      //         icon: Icons.mic,
      //       ),
      //       XDialogButton(
      //         colors: colors,
      //         title: "Add Images",
      //         icon: Icons.image,
      //       )
      //     ],
      //   ),
      //   actions: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         ElevatedButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: const Text("OK")),
      //         SizedBox(
      //           width: 15,
      //         ),
      //         ElevatedButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: const Text("Cancel")),
      //       ],
      //     )
      //   ],
      // ),
    );
  }
}
