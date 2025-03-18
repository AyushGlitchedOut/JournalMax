import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/pages/%5BTestPage%5D.dart';
import 'package:journalmax/pages/CollectionPage.dart';
import 'package:journalmax/pages/EditorPage.dart';
import 'package:journalmax/pages/FindDiary.dart';
import 'package:journalmax/pages/Homepage.dart';
import 'package:journalmax/pages/SettingsPage.dart';
import 'package:journalmax/services/CleanCache.dart';
import 'package:journalmax/themes/ThemeProvider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  App({super.key});

  //All the App Routes
  final Map<String, WidgetBuilder> routes = {
    "/homepage": (context) => const HomePage(),
    "/settings": (context) => const SettingsPage(),
    "/find": (context) => FindDiaryEntryPage(),
    "/editor": (context) => EditorPage(
          createNewEntry: true,
        ),
    "/collection": (context) => const CollectionPage(),
    if (kDebugMode) "/test": (context) => const TestPage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: "JournalMax",
      theme: Provider.of<Themeprovider>(context).themeData,
      initialRoute: "/homepage",
      routes: routes,
    );
  }
}

//Main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await clearCache();
  runApp(ChangeNotifierProvider(
    create: (context) => Themeprovider(),
    child: App(),
  ));
}
