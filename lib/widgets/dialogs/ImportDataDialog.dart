import 'package:flutter/material.dart';
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

class ImportDataDialogBody extends StatelessWidget {
  const ImportDataDialogBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
