import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XToggle.dart';
import 'package:journalmax/services/getLocation.dart';

class enterLocationDialog extends StatefulWidget {
  const enterLocationDialog({super.key});

  @override
  State<enterLocationDialog> createState() => _enterLocationDialogState();
}

class _enterLocationDialogState extends State<enterLocationDialog> {
  TextEditingController _locationController = TextEditingController();
  bool showInCoordinates = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Dialog(
      insetPadding: EdgeInsets.all(0.0),
      elevation: 5.0,
      shadowColor: colors.shadow,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
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
                          onPressed: () async {
                            _locationController.text = showInCoordinates
                                ? await getLocationInCoordinates()
                                : await getLocationInName();
                          },
                          icon: Icon(
                            Icons.sync,
                            size: 30.0,
                            applyTextScaling: true,
                          )),
                      Container(
                        child: Expanded(
                            child: TextField(
                          controller: _locationController,
                          autocorrect: false,
                          onSubmitted: (value) {},
                          style: TextStyle(),
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.outline,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.outline,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              hintText: "Enter a location or get automatically",
                              hintStyle: TextStyle(
                                  fontSize: 12.0, color: colors.tertiary)),
                        )),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                XToggle(
                  title: "Show in Coordinates",
                  value: showInCoordinates,
                  onclick: (value) {
                    setState(() {
                      showInCoordinates = !showInCoordinates;
                      print(showInCoordinates);
                    });
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
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(colors.secondary),
                          elevation: const WidgetStatePropertyAll(5.0),
                          shadowColor: WidgetStatePropertyAll(colors.shadow)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
