import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/pages/%5BTestPage%5D.dart';
import 'package:journalmax/pages/CollectionPage.dart';
import 'package:journalmax/pages/EditorPage.dart';
import 'package:journalmax/pages/FindDiary.dart';
import 'package:journalmax/pages/Homepage.dart';
import 'package:journalmax/pages/IntroductionPage.dart';
import 'package:journalmax/pages/SettingsPage.dart';
import 'package:journalmax/services/CleanCache.dart';
import 'package:journalmax/themes/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  //All the App Routes
  final Map<String, WidgetBuilder> routes = {
    "/homepage": (context) => const HomePage(),
    "/settings": (context) => const SettingsPage(),
    "/find": (context) => FindDiaryEntryPage(),
    "/editor": (context) => EditorPage(
          createNewEntry: true,
        ),
    "/collection": (context) => const CollectionPage(),
    "/intro": (context) => const IntroductionPage(),
    if (kDebugMode) "/test": (context) => const TestPage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: "JournalMax",
      theme: Provider.of<Themeprovider>(context).themeData,
      home: FutureBuilder(
          future: SharedPreferences.getInstance().then((prefs) {
            return prefs.getBool("showIntroPage");
          }),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? snapshot.data == null
                    ? const IntroductionPage()
                    : const HomePage()
                : const IntroductionPage();
          }),
      routes: routes,
    );
  }
}

//Main function
void main() async {
  if (kDebugMode) print("App Started");
  WidgetsFlutterBinding.ensureInitialized();
  await clearCache();
  runApp(ChangeNotifierProvider(
    create: (context) => Themeprovider(),
    child: const App(),
  ));
}
