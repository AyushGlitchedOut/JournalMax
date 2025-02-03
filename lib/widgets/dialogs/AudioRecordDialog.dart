import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:journalmax/services/AudioService.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecordDialog extends StatefulWidget {
  const AudioRecordDialog({super.key});

  @override
  State<AudioRecordDialog> createState() => _AudioRecordDialogState();
}

class _AudioRecordDialogState extends State<AudioRecordDialog> {
  String tempAudioFilePath = "";
  void setTempAudioFilePath(String query) {
    setState(() {
      tempAudioFilePath = query;
    });
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
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(
                child: Text("Record Audio",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500)),
              ),
              AudioRecorderBody(
                setTempAudioFilePath: setTempAudioFilePath,
              ),
              audioRecorderActions(
                colors: colors,
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding audioRecorderActions({required ColorScheme colors}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
        child: Row(
          children: [
            actionButton(
                onclick: () {
                  Navigator.pop(context);
                },
                text: "Cancel",
                isForDelete: true,
                colors: colors),
            actionButton(
                onclick: () {
                  if (tempAudioFilePath == "") {
                    return;
                  }
                  final result = saveTempAudioToFile(tempAudioFilePath);
                  Navigator.pop(context);
                },
                text: "Done",
                isForDelete: false,
                colors: colors)
          ],
        ));
  }
}

// ignore: must_be_immutable
class AudioRecorderBody extends StatefulWidget {
  AudioRecorderBody({super.key, required this.setTempAudioFilePath});
  void Function(String query) setTempAudioFilePath;

  @override
  State<AudioRecorderBody> createState() => _AudioRecorderBodyState();
}

class _AudioRecorderBodyState extends State<AudioRecorderBody> {
  int timeElapsed = 0;
  Timer? _timer;
  final FlutterSoundRecorder _recorder =
      FlutterSoundRecorder(logLevel: Level.warning);

  Future<void> initRecorder() async {
    if (await Permission.microphone.request() == PermissionStatus.denied) {
      showSnackBar("Permission is Denied:(", context);
      final PermissionStatus result = await Permission.microphone.request();
      if (result != PermissionStatus.granted) {
        showSnackBar("Permission Denied Again :(", context);
        return;
      }
    }

    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(const Duration(seconds: 1));

    await _recorder.startRecorder(toFile: "audio");
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Prevent multiple timers
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        timeElapsed++;
      });
    });
  }

  void _pauseRecording() async {
    await _recorder.pauseRecorder();
    _timer?.cancel(); // Stop time counting
    setState(() {});
  }

  void _resumeRecording() async {
    await _recorder.resumeRecorder();
    _startTimer(); // Resume time counting
    setState(() {});
  }

  void _stopRecording() async {
    if (_recorder.isStopped) return;

    final result = await _recorder.stopRecorder();
    _recorder.setSubscriptionDuration(Duration.zero);
    _timer?.cancel();
    setState(() {
      timeElapsed = 0; // Reset time after stopping
    });

    widget.setTempAudioFilePath(result ?? "");
  }

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _timer?.cancel(); // Clean up timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String minutes = (timeElapsed ~/ 60).toString().padLeft(2, "0");
    final String seconds = (timeElapsed % 60).toString().padLeft(2, "0");

    return Column(
      children: [
        Text("$minutes:$seconds"),
        LinearProgressIndicator(
          value: _recorder.isRecording
              ? _recorder.isPaused
                  ? 0.0
                  : null
              : 0.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_recorder.isStopped) return;
                _recorder.isRecording ? _pauseRecording() : _resumeRecording();
              },
              child: const Text("Pause/Play"),
            ),
            ElevatedButton(
              onPressed: _stopRecording,
              child: const Text("Stop Recording"),
            ),
          ],
        ),
      ],
    );
  }
}
