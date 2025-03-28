import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:image_picker/image_picker.dart";
import "package:journalmax/services/DataBaseService.dart";
import "package:journalmax/themes/ThemeProvider.dart";
import "package:journalmax/widgets/XSnackBar.dart";
import "package:journalmax/widgets/dialogs/DialogElevatedButton.dart";
import "package:provider/provider.dart";

//Dialog to enter images in the MultimediaAddPage
class EnterImageDialog extends StatefulWidget {
  //method to report the images
  final void Function(List<File> images) reportImages;
  final int contentId;
  const EnterImageDialog(
      {super.key, required this.reportImages, required this.contentId});
  @override
  State<EnterImageDialog> createState() => _EnterImageDialogState();
}

class _EnterImageDialogState extends State<EnterImageDialog> {
  //actual array of images
  List<File> images = [];

  //method to get the images from the entry of the given Id
  Future<void> getImagesFromEntry() async {
    final result = await getEntryById(widget.contentId);

    //check if there are images or not and
    final String obtainedImages = result.first["image"].toString() == "null"
        ? "[]"
        : result.first["image"].toString();

    //decode the data
    final imageArray = jsonDecode(obtainedImages);

    //loop over the data and add each to file array
    for (var image in imageArray) {
      images.add(File(image));
    }
  }

  //select files from the gallery to enter using the ImagePicker Api
  Future<void> addImages() async {
    List<XFile> loadedImages;

    //pick the images and get XFile array
    try {
      loadedImages = await ImagePicker().pickMultiImage(limit: 6);
    } on PlatformException {
      showSnackBar("Permission Error/Access Error", context);
      return;
    } on Exception {
      showSnackBar("Error selecting files from Gallery", context);
      return;
    }
    //convert XFile array to File array
    final List<File> selectedImages = loadedImages.map((value) {
      return File(value.path);
    }).toList();

    //add the files and re-render
    setState(() {
      images.addAll(selectedImages);
    });
  }

  @override
  void initState() {
    //first obtain the images from entry, add the Images from picker while the UI loads
    Future.delayed(Duration.zero, () async {
      await getImagesFromEntry();
      await addImages();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    //size dimensions of the screen
    final Size size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.all(0.0),
      elevation: 5.0,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.0, color: colors.outline),
          borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: size.height * 0.75,
        width: size.width * 0.95,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Title
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "Attach Images",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                            offset: Offset(1.5, 1.5),
                            color: Colors.grey,
                            blurRadius: 2)
                      ]),
                ),
              ),
            ),
            ImageViewer(
              images: images,
            ),
            ImageDialogActions(
                colors: colors,
                getImages: addImages,
                imageReporter: () {
                  widget.reportImages(images);
                })
          ],
        ),
      ),
    );
  }
}

//Actions
class ImageDialogActions extends StatelessWidget {
  final ColorScheme colors;
  final Future<void> Function() getImages;
  final void Function() imageReporter;
  const ImageDialogActions(
      {super.key,
      required this.colors,
      required this.getImages,
      required this.imageReporter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //add More images actions to open up image Picker and add more images
          actionButton(
              onclick: () {
                getImages();
              },
              text: "Add more",
              isForDeleteOrCancel: false,
              colors: colors),
          const SizedBox(
            width: 15.0,
          ),
          //Button to close the dialog and save the images
          actionButton(
              onclick: () async {
                try {
                  imageReporter();
                } catch (e) {
                  showSnackBar(e.toString(), context);
                }
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

//Body (Reusable)
// ignore: must_be_immutable
class ImageViewer extends StatefulWidget {
  ImageViewer({super.key, required this.images});
  //list of files to view
  List<File> images;
  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  //variables for switching and movement
  int currentPageIndex = 0;
  bool noMoreLeft = true;
  bool noMoreRight = false;

  @override
  Widget build(BuildContext context) {
    //if there's no image
    bool noImageSelected = widget.images.isEmpty;

    final ColorScheme colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Left arrow
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
              });
            },
            disabled: noMoreLeft,
            context: context),

        //The actual image
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: noImageSelected
              //Display fallbak image if no image is there
              ? const Image(
                  fit: BoxFit.contain, image: AssetImage("assets/NoImage.png"))
              : widget.images[currentPageIndex].existsSync()
                  ? Image.file(
                      //file from the provided image array
                      fit: BoxFit.contain,
                      widget.images[currentPageIndex])
                  : const Image(
                      fit: BoxFit.contain,
                      //display error image if file doesnt exist
                      image: AssetImage("assets/ErrorImage.png")),
        ),

        //Right arrow
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
              });
            },
            disabled: noMoreRight,
            context: context)
      ],
    );
  }

  Container imageViewerArrow(
      {required ColorScheme colors,
      required bool isLeft,
      void Function()? onclick,
      required bool disabled,
      required BuildContext context}) {
    final isDarkMode =
        Provider.of<Themeprovider>(context, listen: false).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: disabled
            //gradient for whether the arrow can move or not
            ? const LinearGradient(
                colors: [Colors.transparent, Colors.transparent])
            : LinearGradient(
                stops: const [0.7, 0.85],
                begin: isLeft ? Alignment.topLeft : Alignment.topRight,
                end: isLeft ? Alignment.bottomRight : Alignment.bottomLeft,
                colors: [
                  colors.onSurface,
                  isDarkMode ? Colors.grey : Colors.grey[700]!
                ]),
      ),
      child: IconButton(
        disabledColor: Colors.transparent,
        onPressed: onclick,
        icon: Icon(
          //left or right icon
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
