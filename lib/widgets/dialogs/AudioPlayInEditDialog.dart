import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:journalmax/services/DataBaseService.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/widgets/dialogs/AudioRecordDialog.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:logger/logger.dart';

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
    final Size size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.all(0.0),
      elevation: 5.0,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.0, color: colors.outline),
          borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width * 0.95,
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
              AudioPlayInEditModeDialogActions(
                  widget: widget, context: context, colors: colors)
            ],
          ),
        ),
      ),
    );
  }
}

class AudioPlayInEditModeDialogActions extends StatelessWidget {
  const AudioPlayInEditModeDialogActions({
    super.key,
    required this.widget,
    required this.context,
    required this.colors,
  });

  final AudioPlayInEditModeDialog widget;
  final BuildContext context;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          reportRecordingFile: widget.reportRecordingFunction);
                    });
              },
              text: "Record Again",
              isForDeleteOrCancel: false,
              colors: colors),
          const SizedBox(
            width: 15.0,
          ),
          actionButton(
              onclick: () {
                Navigator.pop(context);
              },
              text: "Done",
              isForDeleteOrCancel: false,
              colors: colors)
        ],
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
  final FlutterSoundPlayer _player = FlutterSoundPlayer(logLevel: Level.error);
  File? audioFile;

  Future<void> getAudioFromId() async {
    try {
      final data = await getEntryById(widget.contentId);
      final audio = data[0]["audio_record"];
      audioFile = File(audio.toString());
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future<void> initPlayer() async {
    await getAudioFromId();
    if (audioFile == null || !audioFile!.existsSync()) {
      showSnackBar("Something Went Wrong :(", context);
      return;
    }
    try {
      await _player.openPlayer();
      await _player.setSubscriptionDuration(const Duration(milliseconds: 250));
      await _player.startPlayer(
          fromURI: audioFile!.path,
          whenFinished: () {
            setState(() {});
          });
      setState(() {});
    } on Exception {
      showSnackBar("Something Went Wrong :(", context);
    }
  }

  Future<void> disposePlayer() async {
    await _player.stopPlayer();
    await _player.closePlayer();
    await _player.setSubscriptionDuration(Duration.zero);
  }

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    double? playerProgress = 0.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        playerProgressIndicator(playerProgress),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            audioPlayInEditDialogBodyButton(
                colors,
                _player.isStopped
                    ? initPlayer
                    : () async {
                        if (_player.isStopped) return;
                        _player.isPaused
                            ? await _player.resumePlayer()
                            : await _player.pausePlayer();
                        setState(() {});
                      },
                _player.isStopped
                    ? Icons.replay_outlined
                    : _player.isPaused
                        ? Icons.play_arrow
                        : Icons.pause_circle,
                _player.isStopped
                    ? const LinearGradient(
                        colors: [Colors.transparent, Colors.transparent])
                    : LinearGradient(
                        stops: const [0.7, 0.85],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colors.onSurface, Colors.grey]))
          ],
        )
      ],
    );
  }

  StreamBuilder<PlaybackDisposition> playerProgressIndicator(
      double? playerProgress) {
    return StreamBuilder(
      stream: _player.onProgress,
      builder: (context, snapshot) {
        if (_player.isStopped) {
          playerProgress = 0.0;

          return Column(
            children: [
              const Text(
                "--:--",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
              ),
              LinearProgressIndicator(
                value: playerProgress,
                minHeight: 15.0,
              ),
            ],
          );
        } else if (snapshot.hasData) {
          playerProgress = (snapshot.data!.position.inMilliseconds > 0)
              ? snapshot.data!.position.inMilliseconds /
                  snapshot.data!.duration.inMilliseconds
              : 0.0;

          final String minutes = (snapshot.data!.position.inSeconds ~/ 60)
              .toString()
              .padLeft(2, "0");
          final String seconds = (snapshot.data!.position.inSeconds % 60)
              .toString()
              .padLeft(2, "0");
          return Column(
            children: [
              Text(
                "$minutes:$seconds",
                style: const TextStyle(
                    fontSize: 25.0, fontWeight: FontWeight.w500),
              ),
              LinearProgressIndicator(
                value: playerProgress,
                minHeight: 15.0,
              ),
            ],
          );
        } else {
          return Column(children: [
            const Text("00:00",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500)),
            LinearProgressIndicator(
              value: playerProgress,
              minHeight: 15.0,
            ),
          ]);
        }
      },
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
