import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/services/DataImportExportService.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';

class ImportDataDialog extends StatefulWidget {
  const ImportDataDialog({super.key});

  @override
  State<ImportDataDialog> createState() => _ImportDataDialogState();
}

class _ImportDataDialogState extends State<ImportDataDialog> {
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
              const ImportDataDialogBody(),
              ImportDataDialogActions(context: context, colors: colors)
            ],
          ),
        ),
      ),
    );
  }
}

class ImportDataDialogActions extends StatelessWidget {
  const ImportDataDialogActions({
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

class ImportDataDialogBody extends StatefulWidget {
  const ImportDataDialogBody({
    super.key,
  });

  @override
  State<ImportDataDialogBody> createState() => _ImportDataDialogBodyState();
}

class _ImportDataDialogBodyState extends State<ImportDataDialogBody> {
  final FilePicker filepicker = FilePickerIO();
  String? selectedFolder = "(Not found)";
  Stream<int>? importStream;
  bool importCompleted = false;

  void importData() {
    if (importCompleted) return;
    setState(() {
      importStream = importDataFromFolder(context, selectedFolder);
    });
  }

  Future<void> getDirectory() async {
    selectedFolder = await filepicker.getDirectoryPath();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: importStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data! == 100) {
                importCompleted = true;
              }
              return snapshot.hasData
                  ? Column(
                      children: [
                        Text(
                            "Target Directory: ${selectedFolder ?? "No Folder Selected"}"),
                        const SizedBox(height: 10.0),
                        LinearProgressIndicator(
                          value: snapshot.data!.toDouble() / 100,
                          minHeight: 15.0,
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Text("Target Directory: $selectedFolder"),
                        const SizedBox(height: 10.0),
                        const LinearProgressIndicator(
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
          icon: Icons.download,
          label: "Import Entries From the Folder",
          onclick: () => importData(),
          customFontSize: 14.0,
        ),
        XIconLabelButton(
          icon: Icons.folder_copy,
          label: "Reselect Folder",
          onclick: () async {
            await getDirectory();
            importStream = null;
            importCompleted = false;
            setState(() {});
          },
        )
      ],
    );
  }
}
