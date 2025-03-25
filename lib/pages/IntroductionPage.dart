import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';

//the introduction page to show at the start of the app
class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  //initialise variables
  final pageController = PageController();
  bool isLastPage = false;

  //dispose the pagecontroller with the page
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  //Turn to next page
  void nextPage() async {
    await pageController.nextPage(
        duration: const Duration(milliseconds: 400), curve: Curves.ease);

    //if the page is the last page has appeared then set isLastPage = true;
    setState(() {
      isLastPage = (pageController.page == 5.0); //set to number of pages -1
    });
  }

  //skip the intro and get to the homepage (same as done )
  void skipIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("showIntroPage", false);
    Navigator.pushReplacementNamed(context, "/homepage");
  }

  //some as skip but after all the pages run out
  void doneIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("showIntroPage", false);
    Navigator.pushReplacementNamed(context, "/homepage");
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                margin: const EdgeInsets.only(top: 15.0),
                height: MediaQuery.of(context).size.height,
                child: PageView(
                  //set isLastPage upon scrolling as well
                  onPageChanged: (page) {
                    setState(() {
                      isLastPage = (page == 5); //number of pages -1
                    });
                  },
                  controller: pageController,
                  allowImplicitScrolling: true,
                  children: const [
                    //page1: Intro page
                    Page(
                        title: "Welcome to JournalMax!",
                        subtext:
                            "An open source and minimalist journaling app for android",
                        images: ["assets/AppIcon.png"]),

                    //Page 2: Create Entries
                    Page(
                        title: "Create Entries!",
                        subtext:
                            "Create Journal Entries to store your memories",
                        images: ["assets/screenshots/EditorPage.png"]),

                    //Page 3: Multimedia
                    Page(
                        title: "More than text!",
                        subtext:
                            "Store multimedia like voice, images and location data",
                        images: [
                          "assets/screenshots/AddLocation.png",
                          "assets/screenshots/AddImages.png",
                          "assets/screenshots/RecordAudio.png"
                        ]),

                    //Page 4: View the entries
                    Page(
                      title: "Revisit them!",
                      subtext:
                          "View the entries later in well-formatted manner",
                      images: [
                        "assets/screenshots/Homepage.png",
                        "assets/screenshots/CollectionPage.png",
                        "assets/screenshots/ViewerPage.png"
                      ],
                    ),

                    //Page 5: Delete the entries
                    Page(
                        title: "To delete them",
                        subtext: "Just long press the items",
                        images: ["assets/screenshots/DeleteEntry.png"]),

                    //Page 6:Last page
                    Page(
                        title: "And much more!",
                        subtext:
                            "Features designed for ease of use, simplicity and usability",
                        images: [
                          "assets/screenshots/FindEntry.png",
                          "assets/screenshots/Settings.png"
                        ])
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              spacing: 10.0,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                actionButton(
                    //skip button
                    onclick: () => skipIntro(context),
                    text: "Skip",
                    isForDeleteOrCancel: false,
                    colors: colors),
                // done/next button
                actionButton(
                    onclick: () => isLastPage ? doneIntro(context) : nextPage(),
                    text: isLastPage ? "Done" : "Next",
                    isForDeleteOrCancel: false,
                    colors: colors)
              ],
            ),
          )
        ],
      ),
    );
  }
}

//A single page widget
class Page extends StatelessWidget {
  final String title;
  final String subtext;
  final List<String> images;

  const Page(
      {super.key,
      required this.title,
      required this.subtext,
      required this.images});

  //method to display images
  Widget displayImage(String asset, Color shadow, Color outline, Size size,
      {bool haveToPutThreeImages = false}) {
    final bool isAppIcon = asset == "assets/AppIcon.png";
    return SizedBox(
      width: isAppIcon
          ? 304
          : haveToPutThreeImages
              ? size.width * 0.33
              : size.width * 0.42,
      height: isAppIcon
          ? 244
          : haveToPutThreeImages
              ? size.height * 0.33
              : size.height * 0.42,
      child: AspectRatio(
        aspectRatio: isAppIcon ? 128 / 126 : 1600 / 720,
        child: Image(
          frameBuilder: (context, image, frame, loadedSync) {
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: outline),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(4, 4),
                          color: shadow,
                          blurRadius: 4.0)
                    ]),
                child: image);
          },
          image: AssetImage(asset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //the imagesBox which renders images based on if there's 1,2, or 3 images
  Widget imagesBox(Color shadow, Color outline, Size size, int imagesLength) {
    final moreThan1 = imagesLength > 1;
    final moreThan2 = imagesLength > 2;

    final Widget box = moreThan1
        ? moreThan2
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10.0,
                    children: [
                      displayImage(images[0], shadow, outline, size,
                          haveToPutThreeImages: true),
                      displayImage(images[1], shadow, outline, size,
                          haveToPutThreeImages: true)
                    ],
                  ),
                  displayImage(images[2], shadow, outline, size,
                      haveToPutThreeImages: true)
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.0,
                children: [
                  displayImage(images[0], shadow, outline, size),
                  displayImage(images[1], shadow, outline, size)
                ],
              )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10.0,
            children: [displayImage(images[0], shadow, outline, size)],
          );

    return box;
  }

  @override
  Widget build(BuildContext context) {
    final imagesLength = images.length;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;

    // ignore: sized_box_for_whitespace
    return Container(
      height: size.height,
      width: size.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10.0,
          children: [
            Expanded(
                child: Container(
                    child: imagesBox(
                        colors.shadow, colors.outline, size, imagesLength))),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: colors.primary,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                        shadows: const [
                          Shadow(
                              offset: Offset(1.5, 1.5),
                              color: Colors.grey,
                              blurRadius: 2)
                        ]),
                  ),
                )),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subtext,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(fontSize: 15.0, color: colors.onSurface),
                    ),
                  ),
                )
              ],
            )
          ]),
    );
  }
}
