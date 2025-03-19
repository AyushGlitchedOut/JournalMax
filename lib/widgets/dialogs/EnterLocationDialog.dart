import 'package:flutter/material.dart';
import 'package:journalmax/services/DataBaseService.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/widgets/XToggle.dart';
import 'package:journalmax/services/GetLocation.dart';

//Dialog for entering the location in multimediadd page
class EnterLocationDialog extends StatefulWidget {
  //reporting method to report the location
  final void Function(String location) reportLocation;
  final int contentId;
  const EnterLocationDialog(
      {super.key, required this.reportLocation, required this.contentId});

  @override
  State<EnterLocationDialog> createState() => _EnterLocationDialogState();
}

class _EnterLocationDialogState extends State<EnterLocationDialog> {
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ColorScheme colors = Theme.of(context).colorScheme;
    return Dialog(
      insetPadding: const EdgeInsets.all(0.0),
      elevation: 5.0,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.0, color: colors.outline),
          borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: size.height * 0.55,
        width: size.width * 0.95,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Title
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "Attach Location",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            LocationDialogBody(
              contentId: widget.contentId,
              reportLocation: widget.reportLocation,
              controller: _locationController,
            ),
            LocationDialogActions(
              widget: widget,
              context: context,
              colors: colors,
              locationController: _locationController,
            )
          ],
        ),
      ),
    );
  }
}

//Location Body
class LocationDialogBody extends StatefulWidget {
  final void Function(String location) reportLocation;
  final int contentId;
  final TextEditingController controller;
  const LocationDialogBody(
      {super.key,
      required this.contentId,
      required this.reportLocation,
      required this.controller});

  @override
  State<LocationDialogBody> createState() => _LocationDialogBodyState();
}

class _LocationDialogBodyState extends State<LocationDialogBody> {
  //to show location or co-ordinates
  bool showInCoordinates = false;

  //to get location from entry of the given EntryId
  Future<void> getLocationFromEntry() async {
    final result = await getEntryById(widget.contentId);
    //return "Not Entered!" for null
    final String obtainedLocation =
        result.first["location"].toString() == "null"
            ? "Not Entered!"
            : result.first["location"].toString();
    widget.controller.text = obtainedLocation;
  }

  //Method called to actually obtain the location and set the Text-Field
  Future<void> syncLocation(BuildContext context) async {
    widget.controller.text = "Loading.....";
    try {
      String result = "Unknown";
      //get location in co-rdinates or place name
      if (showInCoordinates) {
        final coordinates = await getLocationInCoordinates();
        result =
            '${coordinates.latitude.toStringAsFixed(5)} , ${coordinates.longitude.toStringAsFixed(5)}';
      } else {
        result = await getLocationInName();
      }

      widget.controller.text = result;
    } catch (exception) {
      widget.controller.text = "Not found";
      showSnackBar(exception.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    //get Location after loading the UI
    getLocationFromEntry();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController locationController = widget.controller;
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Sync button to load the location upon clicking
              IconButton(
                  onPressed: () => syncLocation(context),
                  icon: const Icon(
                    Icons.sync,
                    size: 30.0,
                    applyTextScaling: true,
                  )),
              //Text field that has the actual data (can be both entered by system or by user)
              Expanded(
                  child: TextField(
                controller: locationController,
                autocorrect: false,
                onSubmitted: (value) {},
                style: const TextStyle(),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colors.outline,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colors.outline,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0))),
                    hintText: "Enter a location or get automatically",
                    hintStyle:
                        TextStyle(fontSize: 12.0, color: colors.tertiary)),
              ))
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        //toggle to whether show in co-ordinates or name
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
    );
  }
}

//Location Actions
class LocationDialogActions extends StatelessWidget {
  const LocationDialogActions({
    super.key,
    required this.widget,
    required this.locationController,
    required this.context,
    required this.colors,
  });

  final EnterLocationDialog widget;
  final TextEditingController locationController;
  final BuildContext context;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //Ok button to report the location
          actionButton(
              onclick: () {
                widget.reportLocation(locationController.text == "null"
                    ? "Not Entered!"
                    : locationController.text);
                Navigator.of(context).pop();
              },
              text: "Done",
              isForDeleteOrCancel: false,
              colors: colors)
        ],
      ),
    );
  }
}
