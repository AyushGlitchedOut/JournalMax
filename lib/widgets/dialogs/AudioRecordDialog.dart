import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:journalmax/themes/ThemeProvider.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

//The dialog to open when recording the audio in multimediadd page
class AudioRecordDialog extends StatefulWidget {
  final int entryID;
  final void Function(String audioFilePath) reportRecordingFile;
  const AudioRecordDialog(
      {super.key, required this.entryID, required this.reportRecordingFile});

  @override
  State<AudioRecordDialog> createState() => _AudioRecordDialogState();
}

class _AudioRecordDialogState extends State<AudioRecordDialog> {
  //file path of the temporary audio file obtained from recorder
  String tempAudioFilePath = "";

  //method to set the tempAudioFile Path
  void setTempAudioFilePath(String query) {
    setState(() {
      tempAudioFilePath = query;
    });
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
              //The title
              const Center(
                child: Text("Record Audio",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                              offset: Offset(1.5, 1.5),
                              color: Colors.grey,
                              blurRadius: 2)
                        ])),
              ),
              AudioRecorder(
                setTempAudioFilePath: setTempAudioFilePath,
              ),
              AudioRecorderActions(
                  context: context,
                  tempAudioFilePath: tempAudioFilePath,
                  widget: widget,
                  colors: colors)
            ],
          ),
        ),
      ),
    );
  }
}

//Actions of the dialog
class AudioRecorderActions extends StatelessWidget {
  const AudioRecorderActions({
    super.key,
    required this.context,
    required this.tempAudioFilePath,
    required this.widget,
    required this.colors,
  });

  final BuildContext context;
  final String tempAudioFilePath;
  final AudioRecordDialog widget;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //Exit the dialog
            actionButton(
                onclick: () {
                  Navigator.pop(context);
                },
                text: "Cancel",
                isForDeleteOrCancel: true,
                colors: colors),
            const SizedBox(
              width: 15.0,
            ),
            //report the recording file (if it exists) and exit the dialog
            actionButton(
                onclick: () {
                  if (tempAudioFilePath == "") {
                    return;
                  }
                  widget.reportRecordingFile(tempAudioFilePath);
                  Navigator.pop(context);
                },
                text: "Done",
                isForDeleteOrCancel: false,
                colors: colors)
          ],
        ));
  }
}

//Body of the recorder
// ignore: must_be_immutable
class AudioRecorder extends StatefulWidget {
  AudioRecorder({super.key, required this.setTempAudioFilePath});
  void Function(String query) setTempAudioFilePath;

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  //timeElpased and timer for storing the recording time manually
  int timeElapsed = 0;
  Timer? _timer;

  //the sound recorder
  final FlutterSoundRecorder _recorder =
      FlutterSoundRecorder(logLevel: Level.warning);

  //to initialise and configure the recorder
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
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));

    await _recorder.startRecorder(toFile: "audio");
    _startTimer();
  }

  //configure and start the timer
  void _startTimer() {
    _timer?.cancel(); // Prevent multiple timers
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        timeElapsed++;
      });
    });
  }

  //pause the ongoing recording
  void _pauseRecording() async {
    if (_recorder.isStopped) return;
    await _recorder.pauseRecorder();
    _timer?.cancel(); // Stop time counting
    setState(() {});
  }

  //resume paused recording
  void _resumeRecording() async {
    if (_recorder.isStopped) return;
    await _recorder.resumeRecorder();
    _startTimer(); // Resume time counting
    setState(() {});
  }

  //stop the recording and save it (also stop the timer)
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
    //initialise the recorder
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    //dispose the recorder
    _recorder.closeRecorder();
    _timer?.cancel(); // Clean up timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isDarkMode =
        Provider.of<Themeprovider>(context, listen: false).isDarkMode;

    //minutes and second passed to display in the UI
    final String minutes = (timeElapsed ~/ 60).toString().padLeft(2, "0");
    final String seconds = (timeElapsed % 60).toString().padLeft(2, "0");

    return Column(
      children: [
        //time elapsed label
        Text(
          "$minutes:$seconds",
          style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                    offset: Offset(1.5, 1.5), color: Colors.grey, blurRadius: 2)
              ]),
        ),
        //progress indicator just for aesthetics
        LinearProgressIndicator(
          value: _recorder.isRecording
              ? _recorder.isPaused
                  ? 0.0
                  : null
              : 0.0,
          minHeight: 15.0,
        ),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          //play/pause button
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            recordAudioDialogBodyButton(colors, () {
              //pause or play recording based on state
              _recorder.isPaused ? _resumeRecording() : _pauseRecording();
            },
                _recorder.isPaused ? Icons.play_arrow_rounded : Icons.pause,
                _recorder.isStopped
                    ? const LinearGradient(
                        colors: [Colors.transparent, Colors.transparent])
                    : LinearGradient(
                        stops: const [0.7, 0.85],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colors.onSurface,
                          isDarkMode ? Colors.grey : Colors.grey[700]!
                        ])),
            //stop/submit button
            recordAudioDialogBodyButton(colors, () {
              _stopRecording();
            },
                Icons.stop_circle_outlined,
                LinearGradient(
                    stops: const [0.7, 0.85],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.onSurface,
                      isDarkMode ? Colors.grey : Colors.grey[700]!
                    ]))
          ],
        ),
      ],
    );
  }

  //reusabel button for play/pause and stop buttons (also used in audio Player)
  Container recordAudioDialogBodyButton(ColorScheme colors,
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
