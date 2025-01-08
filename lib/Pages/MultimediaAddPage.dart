import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/Dialogs/EnterLocationDialog.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';

class MultimediaAddPage extends StatelessWidget {
  final void Function(String location) saveLocation;
  const MultimediaAddPage({super.key, required this.saveLocation});

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
                    return enterLocationDialog(
                      reportLocation: saveLocation,
                    );
                  });
            },
          ),
          const XIconLabelButton(icon: Icons.mic, label: "Record Voice"),
          const XIconLabelButton(icon: Icons.image, label: "Add images"),
          Center(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(colors.onSurface),
                    elevation: const WidgetStatePropertyAll(2.0)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                      color: colors.onPrimary, fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    );
  }
}
