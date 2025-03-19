import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return introductionPage(context);
  }
}

IntroductionScreen introductionPage(BuildContext context) {
  Future<void> setShowIntroPageToFalse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("showIntroPage", false);
  }

  return IntroductionScreen(
    pages: [page1],
    onDone: () {
      Navigator.pushNamed(context, "/homepage");
      setShowIntroPageToFalse();
    },
    showDoneButton: true,
    done: const Text("Done"),
    showNextButton: true,
    next: const Text("Next"),
  );
}

//Introduction Page
final page1 = PageViewModel(
    title: "Welcome To JournalMax",
    body: "A minimalist journaling App for Android");

//Create and edit entries
final page2 = PageViewModel();

//Add multimedia to you journals
final page3 = PageViewModel();

//View Entries
final page4 = PageViewModel();

//Delete Entries
final page5 = PageViewModel();
