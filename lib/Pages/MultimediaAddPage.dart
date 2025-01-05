import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/EnterLocationDialog.dart';
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
        child: XAppBar(title: "Multimedia"),
      ),
      drawer: const XDrawer(currentPage: "editor"),
      backgroundColor: colors.surface,
      body: Column(
        children: [
          XIconLabelButton(
            icon: Icons.location_on,
            label: "Current Location",
            onclick: () {
              // use stateful builder to update the dialog
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return enterLocationDialog();
                  });
            },
          ),
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
    );
  }
}
