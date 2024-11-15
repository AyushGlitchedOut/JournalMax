import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/services/UploadToGoogleDrive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "Synchronize",
          )),
      drawer: const XDrawer(
        currentPage: "sync",
      ),
      backgroundColor: colors.surface,
      body: Column(
        children: [
          SyncProgress(colors: colors),
          const XIconLabelButton(
            icon: Icons.add_to_drive,
            label: "Sync your Files to Google Drive",
            onclick: uploadToGoogleDrive,
            customFontSize: 16.0,
          )
        ],
      ),
    );
  }
}

class SyncProgress extends StatefulWidget {
  const SyncProgress({
    super.key,
    required this.colors,
  });

  final ColorScheme colors;

  @override
  State<SyncProgress> createState() => _SyncProgressState();
}

class _SyncProgressState extends State<SyncProgress> {
  Future<void> getGmail() async {
    final prefs = await SharedPreferences.getInstance();
    String res = prefs.getString("gmail") ?? "Not found";
    setState(() {
      email = res;
    });
  }

  String email = "not Given";
  @override
  void initState() {
    getGmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: widget.colors.onSurface,
          // border: Border.all(
          //   color: colors.outline,
          // ),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: widget.colors.primary, offset: const Offset(-1.5, -1.5)),
            BoxShadow(
                color: widget.colors.shadow, offset: const Offset(1.5, 1.5))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              email,
              style: TextStyle(
                  color: widget.colors.onPrimary,
                  fontSize: 22.0,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
