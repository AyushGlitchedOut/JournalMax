import 'package:flutter/material.dart';
import 'package:journalmax/pages/SettingsPage.dart';
import 'package:journalmax/services/DataSyncService.dart';
import 'package:journalmax/widgets/ContentBox.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';
import 'package:journalmax/widgets/XLabel.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<int>? syncProgressStream;

    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "Synchronise",
          )),
      drawer: const XDrawer(
        currentPage: "sync",
      ),
      backgroundColor: colors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          contentBox(
            child: Container(),
            colors: colors,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          XLabel(
            label: "Login Status",
            /* placeholder for checking login status*/
            color: Colors.red,
          ),
          XIconLabelButton(
            icon: Icons.add_to_drive,
            label: "Sync to Google Drive",
            onclick: () async {
              if (!(await networkAvailable(
                  context, (await getPreferenceToUseMobileData())))) {
                return;
              }
            },
            customFontSize: 16.0,
          ),
          XIconLabelButton(
            icon: Icons.cloud_download_rounded,
            label: "Download From Google Drive",
            customFontSize: 16.0,
            onclick: () async {
              if (!(await networkAvailable(
                  context, (await getPreferenceToUseMobileData())))) {
                return;
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const UseWifiAlert();
                      });
                },
                icon: Icon(
                  Icons.info_outline,
                  size: 30.0,
                  color: Colors.blue[800],
                )),
          )
        ],
      ),
    );
  }
}

class UseWifiAlert extends StatelessWidget {
  const UseWifiAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("Alert!"),
              ],
            ),
          ),
        ],
      ),
      content: const Text(
          """Synchronising to Google Drive should only be done over Wifi connection with no bandwidth limit because the app will make several requests for information and upload/download the entirety of the data stored, including the audio and image files which for a large data store can cost a lot of bandwidth. If you still want to proceed using mobile data, disable the protection option in settings"""),
      actions: [
        actionButton(
            onclick: () {
              Navigator.pop(context);
            },
            text: "OK",
            isForDeleteOrCancel: false,
            colors: colors),
        actionButton(
            onclick: () {
              Navigator.pushNamed(context, "/settings");
            },
            text: "Disable It",
            isForDeleteOrCancel: true,
            colors: colors)
      ],
    );
  }
}
