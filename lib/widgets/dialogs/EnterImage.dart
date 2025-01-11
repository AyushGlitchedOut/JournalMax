
import "package:flutter/material.dart";
import "package:journalmax/widgets/dialogs/DialogElevatedButton.dart";

class EnterImageDialog extends StatelessWidget {
  const EnterImageDialog({super.key});

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
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "Attach Images",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            imageViewer(colors, context),
            dialogActions(colors, context)
          ],
        ),
      ),
    );
  }

  Padding dialogActions(ColorScheme colors, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          actionButton(
              onclick: () {
                //open up image picker
              },
              text: "Add more",
              isForDelete: false,
              colors: colors),
          const SizedBox(
            width: 15.0,
          ),
          actionButton(
              onclick: () {
                //implement image saving logic
                Navigator.of(context).pop();
              },
              text: "Done",
              isForDelete: false,
              colors: colors)
        ],
      ),
    );
  }

  Row imageViewer(ColorScheme colors, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        imageViewerArrow(colors: colors, isLeft: true),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                    color: colors.shadow,
                    blurRadius: 1.0,
                    offset: const Offset(1, 1)),
                BoxShadow(
                    color: colors.shadow,
                    blurRadius: 1.0,
                    offset: const Offset(-1, -1)),
                BoxShadow(
                    color: colors.shadow,
                    blurRadius: 1.0,
                    offset: const Offset(1, -1)),
                BoxShadow(
                    color: colors.shadow,
                    blurRadius: 1.0,
                    offset: const Offset(-1, 1))
              ],
          //border: Border.all(color: colors.onSurface, width: 2.0),
)          ,child: const Placeholder(),
        ),
        imageViewerArrow(colors: colors, isLeft: false)
      ],
    );
  }

  Container imageViewerArrow(
      {required ColorScheme colors, required bool isLeft}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
            stops: const [0.7, 0.85],
            begin: isLeft ? Alignment.topLeft : Alignment.topRight,
            end: isLeft ? Alignment.bottomRight : Alignment.bottomLeft,
            colors: [colors.onSurface, Colors.grey]),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          isLeft ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
          color: colors.primary,
          size: 30.0,
          shadows: [Shadow(color: colors.shadow, offset: const Offset(1.0, 1.0))],
        ),
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(CircleBorder()),
        ),
      ),
    );
  }
}
