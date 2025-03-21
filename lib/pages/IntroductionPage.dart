import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final pageController = PageController();
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void nextPage() async {
    await pageController.nextPage(
        duration: const Duration(milliseconds: 250), curve: Curves.bounceOut);

    setState(() {
      isLastPage = (pageController.page == 3.0); //set to number of pages -1
    });
  }

  void skipIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("showIntroPage", false);
    Navigator.pushReplacementNamed(context, "/homepage");
  }

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
                  onPageChanged: (page) {
                    setState(() {
                      isLastPage = (page == 3); //number of pages -1
                    });
                  },
                  controller: pageController,
                  allowImplicitScrolling: true,
                  children: const [Page()],
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
                    onclick: () => skipIntro(context),
                    text: "Skip",
                    isForDeleteOrCancel: false,
                    colors: colors),
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

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: colors.outline)),
      child: const Text("Page"),
    );
  }
}
