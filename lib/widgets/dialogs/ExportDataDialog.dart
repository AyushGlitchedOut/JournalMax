import 'package:flutter/material.dart';
import 'package:journalmax/services/DataBaseService.dart';
import 'package:journalmax/services/DataImportExportService.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';

class ExportDataDialog extends StatefulWidget {
  const ExportDataDialog({super.key});

  @override
  State<ExportDataDialog> createState() => _ExportDataDialogState();
}

class _ExportDataDialogState extends State<ExportDataDialog> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.all(0.0),
      elevation: 5.0,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.0, color: colors.outline),
          borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width * 0.95,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(
                child: Text(
                  "Import Data From Folder",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
              ),
              const ExportDataDialogBody(),
              ExportDataDialogActions(context: context, colors: colors)
            ],
          ),
        ),
      ),
    );
  }
}

class ExportDataDialogActions extends StatelessWidget {
  const ExportDataDialogActions({
    super.key,
    required this.context,
    required this.colors,
  });

  final BuildContext context;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          actionButton(
              onclick: () {
                //cancel logic
                Navigator.pop(context);
              },
              text: "Cancel",
              isForDeleteOrCancel: true,
              colors: colors),
          const SizedBox(
            width: 15.0,
          ),
          actionButton(
              onclick: () {
                //exit logic
                Navigator.pop(context);
              },
              text: "OK",
              isForDeleteOrCancel: false,
              colors: colors)
        ],
      ),
    );
  }
}

class ExportDataDialogBody extends StatefulWidget {
  const ExportDataDialogBody({
    super.key,
  });

  @override
  State<ExportDataDialogBody> createState() => _ExportDataDialogBodyState();
}

class _ExportDataDialogBodyState extends State<ExportDataDialogBody> {
  Future<void> setNumberOfEntries() async {
    noOfEntries = await getNumberOfEntries();
    setState(() {});
  }

  int noOfEntries = 0;
  Stream<int>? exportStream;
  bool exportCompleted = false;

  void exportData() {
    if (exportCompleted) return;
    setState(() {
      exportStream = exportDataToFolder(context);
    });
  }

  @override
  void initState() {
    super.initState();
    setNumberOfEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: exportStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data! == 100) {
                exportCompleted = true;
              }
              return snapshot.hasData
                  ? Column(
                      children: [
                        Text(
                          "${snapshot.data}% Complete",
                          style: const TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500),
                        ),
                        LinearProgressIndicator(
                          value: snapshot.data!.toDouble() / 100,
                          minHeight: 15.0,
                        )
                      ],
                    )
                  : const Column(
                      children: [
                        Text(
                          "Click the Button To Begin Export",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500),
                        ),
                        LinearProgressIndicator(
                          value: 0.0,
                          minHeight: 15.0,
                        )
                      ],
                    );
            }),
        const SizedBox(
          height: 20.0,
        ),
        XIconLabelButton(
          icon: Icons.upload,
          label: "Export $noOfEntries Entries to Your Storage",
          onclick: () => exportData(),
          customFontSize: 14.0,
        )
      ],
    );
  }
}
