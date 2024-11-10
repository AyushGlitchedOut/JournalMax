import 'package:flutter/material.dart';
import 'package:journalmax/Pages/CollectionPage.dart';
import 'package:journalmax/Pages/EditorPage.dart';
import 'package:journalmax/Pages/FindDiary.dart';
import 'package:journalmax/Pages/Homepage.dart';
import 'package:journalmax/Pages/SettingsPage.dart';
import 'package:journalmax/Pages/SyncPage.dart';
import 'package:journalmax/Pages/ViewerPage.dart';
import 'package:journalmax/Themes/themes.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  App({super.key});

  final Map<String, WidgetBuilder> routes = {
    "/homepage": (context) => HomePage(),
    "/ssettings": (context) => SettingsPage(),
    "/sync": (context) => SyncPage(),
    "/view": (context) => ViewerPage(),
    "find": (context) => FindDiaryEntryPage(),
    "/editor": (context) => EditorPage(),
    "/collection": (context) => CollectionPage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: "JornalMax",
      theme: lightmode,
      initialRoute: "/homepage",
      routes: routes,
    );
  }
}

void main() {
  // runApp(ChangeNotifierProvider(
  //   create: (context) => null,
  //   child: const App(),
  // ));
  runApp(App());
}
