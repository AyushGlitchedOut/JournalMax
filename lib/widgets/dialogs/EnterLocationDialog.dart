import 'package:flutter/material.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/widgets/XToggle.dart';
import 'package:journalmax/services/GetLocation.dart';

class EnterLocationDialog extends StatefulWidget {
  final void Function(String location) reportLocation;
  const EnterLocationDialog({super.key, required this.reportLocation});

  @override
  State<EnterLocationDialog> createState() => _EnterLocationDialogState();
}

class _EnterLocationDialogState extends State<EnterLocationDialog> {
  final TextEditingController _locationController = TextEditingController();
  bool isLoading = false;
  bool showInCoordinates = false;
  Future<void> syncLocation(BuildContext context) async {
    _locationController.text = "Loading.....";
    try {
      String result = "Unknown";
      if (showInCoordinates) {
        final coordinates = await getLocationInCoordinates();
        result =
            '${coordinates.latitude.toStringAsFixed(5)} , ${coordinates.longitude.toStringAsFixed(5)}';
      } else {
        result = await getLocationInName();
      }
      _locationController.text = result;
    } catch (exception) {
      _locationController.text = "Not found";
      showSnackBar(exception.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Dialog(
      insetPadding: const EdgeInsets.all(0.0),
      elevation: 5.0,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.0, color: colors.outline),
          borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "Attach Location",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => syncLocation(context),
                          icon: const Icon(
                            Icons.sync,
                            size: 30.0,
                            applyTextScaling: true,
                          )),
                      Expanded(
                          child: TextField(
                        controller: _locationController,
                        autocorrect: false,
                        onSubmitted: (value) {},
                        style: const TextStyle(),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: colors.outline,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: colors.outline,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0))),
                            hintText: "Enter a location or get automatically",
                            hintStyle: TextStyle(
                                fontSize: 12.0, color: colors.tertiary)),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                XToggle(
                  title: "Show in Coordinates",
                  value: showInCoordinates,
                  onclick: (value) {
                    setState(() {
                      showInCoordinates = !showInCoordinates;
                    });
                    syncLocation(context);
                  },
                  customFontSize: 19.0,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  actionButton(
                      onclick: () {
                        widget.reportLocation(_locationController.text);
                        Navigator.of(context).pop();
                      },
                      text: "Done",
                      isForDelete: false,
                      colors: colors)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
