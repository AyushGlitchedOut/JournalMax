import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:journalmax/services/CRUD_Entry.dart";
import "package:journalmax/widgets/dialogs/DialogElevatedButton.dart";

class EnterImageDialog extends StatefulWidget {
  final void Function(List<File> images) reportImages;
  final int contentId;
  const EnterImageDialog(
      {super.key, required this.reportImages, required this.contentId});

  @override
  State<EnterImageDialog> createState() => _EnterImageDialogState();
}

class _EnterImageDialogState extends State<EnterImageDialog> {
  List<File> images = [];

  Future<void> getImagesFromEntry() async {
    final result = await getEntryById(widget.contentId);
    final String images = result.first["image"].toString() == "null"
        ? "None"
        : result.first["image"].toString();
    print(images);
  }

  Future<void> addImages() async {
    final List<XFile> loadedImages =
        await ImagePicker().pickMultiImage(limit: 6);
    final List<File> selectedImages = loadedImages.map((value) {
      return File(value.path);
    }).toList();
    setState(() {
      images.addAll(selectedImages);
    });
  }

  @override
  void initState() {
    getImagesFromEntry();
    addImages();
    super.initState();
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
            ImageViewer(
              images: images,
            ),
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
                addImages();
              },
              text: "Add more",
              isForDelete: false,
              colors: colors),
          const SizedBox(
            width: 15.0,
          ),
          actionButton(
              onclick: () {
                widget.reportImages(images);
                Navigator.of(context).pop();
              },
              text: "Done",
              isForDelete: false,
              colors: colors)
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ImageViewer extends StatefulWidget {
  ImageViewer({super.key, required this.images});
  List<File> images;
  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  int currentPageIndex = 0;
  bool noMoreLeft = true;
  bool noMoreRight = false;

  @override
  Widget build(BuildContext context) {
    bool noImageSelected = widget.images.isEmpty;
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        imageViewerArrow(
            colors: colors,
            isLeft: true,
            onclick: () {
              setState(() {
                //check if its the first picture
                if (currentPageIndex == 0) {
                  noMoreLeft = true;
                  return;
                } else {
                  noMoreLeft = false;
                }

                //shift the pageIndex
                currentPageIndex -= 1;
                noMoreRight = false;
                print(currentPageIndex);
              });
            },
            disabled: noMoreLeft),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: colors.surface,
            // boxShadow: [
            //   BoxShadow(
            //       color: colors.shadow,
            //       blurRadius: 1.0,
            //       offset: const Offset(1, 1)),
            //   BoxShadow(
            //       color: colors.shadow,
            //       blurRadius: 1.0,
            //       offset: const Offset(-1, -1)),
            //   BoxShadow(
            //       color: colors.shadow,
            //       blurRadius: 1.0,
            //       offset: const Offset(1, -1)),
            //   BoxShadow(
            //       color: colors.shadow,
            //       blurRadius: 1.0,
            //       offset: const Offset(-1, 1))
            // ],
          ),
          child: noImageSelected
              ? const Image(
                  fit: BoxFit.contain, image: AssetImage("assets/NoImage.png"))
              : Image.file(
                  fit: BoxFit.contain, widget.images[currentPageIndex]),
        ),
        imageViewerArrow(
            colors: colors,
            isLeft: false,
            onclick: () {
              setState(() {
                //check if its the last picture
                if (currentPageIndex + 1 >= widget.images.length) {
                  noMoreRight = true;
                  return;
                } else {
                  noMoreRight = false;
                }

                //shift pageIndex by 1
                currentPageIndex += 1;
                noMoreLeft = false;
                print(currentPageIndex);
              });
            },
            disabled: noMoreRight)
      ],
    );
  }

  Container imageViewerArrow(
      {required ColorScheme colors,
      required bool isLeft,
      void Function()? onclick,
      required bool disabled}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: disabled
            ? const LinearGradient(
                colors: [Colors.transparent, Colors.transparent])
            : LinearGradient(
                stops: const [0.7, 0.85],
                begin: isLeft ? Alignment.topLeft : Alignment.topRight,
                end: isLeft ? Alignment.bottomRight : Alignment.bottomLeft,
                colors: [colors.onSurface, Colors.grey]),
      ),
      child: IconButton(
        disabledColor: Colors.transparent,
        onPressed: onclick,
        icon: Icon(
          isLeft ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
          color: colors.primary,
          size: 30.0,
          shadows: [
            Shadow(color: colors.shadow, offset: const Offset(1.0, 1.0))
          ],
        ),
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(CircleBorder()),
        ),
      ),
    );
  }
}
