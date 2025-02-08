import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:journalmax/services/CRUD_Entry.dart';
import 'package:journalmax/widgets/dialogs/AudioRecordDialog.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';

class AudioPlayInEditModeDialog extends StatefulWidget {
  final int contentId;
  final void Function(String query) reportRecordingFunction;
  const AudioPlayInEditModeDialog(
      {super.key,
      required this.contentId,
      required this.reportRecordingFunction});

  @override
  State<AudioPlayInEditModeDialog> createState() =>
      _AudioPlayInEditModeDialogState();
}

class _AudioPlayInEditModeDialogState extends State<AudioPlayInEditModeDialog> {
  @override
  void initState() {
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
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(
                child: Text(
                  "Play Saved Recording",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
              ),
              AudioPlayInEditDialogBody(
                contentId: widget.contentId,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    actionButton(
                        onclick: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AudioRecordDialog(
                                    entryID: widget.contentId,
                                    reportRecordingFile:
                                        widget.reportRecordingFunction);
                              });
                        },
                        text: "Record Again",
                        isForDelete: false,
                        colors: colors),
                    const SizedBox(
                      width: 15.0,
                    ),
                    actionButton(
                        onclick: () {
                          Navigator.pop(context);
                        },
                        text: "Done",
                        isForDelete: false,
                        colors: colors)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AudioPlayInEditDialogBody extends StatefulWidget {
  final int contentId;
  const AudioPlayInEditDialogBody({super.key, required this.contentId});

  @override
  State<AudioPlayInEditDialogBody> createState() =>
      _AudioPlayInEditDialogBodyState();
}

class _AudioPlayInEditDialogBodyState extends State<AudioPlayInEditDialogBody> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool isLoading = false;
  File? audioFile;

  Future<void> getAudioFromId() async {
    setState(() {
      isLoading = true;
    });
    final data = await getEntryById(widget.contentId);
    final audio = data[0]["audio_record"];
    audioFile = File(audio.toString());
    print(audioFile!.readAsBytesSync());
    setState(() {
      isLoading = false;
    });
  }

  Future<void> initPlayer() async {
    await getAudioFromId();
    _player.openPlayer();
    _player.startPlayer(fromURI: audioFile!.path);
  }

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //put streambuilder here
        const Text("00:00"),
        const LinearProgressIndicator(
          value: null,
          minHeight: 15.0,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            audioPlayInEditDialogBodyButton(colors, () {
              // play pause the player
              _player.stopPlayer();
            },
                Icons.play_arrow_rounded,
                LinearGradient(
                    stops: const [0.7, 0.85],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colors.onSurface, Colors.grey]))
          ],
        )
      ],
    );
  }

  Container audioPlayInEditDialogBodyButton(ColorScheme colors,
      void Function() onclick, IconData icon, Gradient background) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: background,
      ),
      child: IconButton(
        disabledColor: Colors.transparent,
        onPressed: onclick,
        icon: Icon(
          icon,
          color: colors.primary,
          size: 50.0,
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
