import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journalmax/services/DataBaseService.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:path_provider/path_provider.dart';

//(files imported exported in total) to show in the dialogs
Stream<int> importDataFromFolder(
    BuildContext context, String? selectedFolder) async* {
  try {
    if (selectedFolder.toString() == "null") {
      showSnackBar("No folder Selected", context);
      return;
    }
    print(selectedFolder);
    yield 100;
  } on Exception {
    showSnackBar("Couldn't import files successfullyy", context);
    yield -1;
  }
}

Stream<int> exportDataToFolder(BuildContext context) async* {
  yield 0;

  //
  //declaring all the folders
  try {
    final Directory downloadsDirectory =
        Directory("/storage/emulated/0/Download");
    final Directory applicationDataDirectory =
        await getApplicationDocumentsDirectory();
    final Directory recordingStorage =
        Directory("${applicationDataDirectory.path}/Recordings");
    final Directory imageStorage =
        Directory("${applicationDataDirectory.path}/Images");
    if (!(await downloadsDirectory.exists())) {
      showSnackBar("Downloads folder not found!", context);
      return;
    }
    yield 1;

    //
    //create a file inside the Downloads Directory with epoch time for exporting
    final Directory saveLocation = Directory(
        "${downloadsDirectory.path}/JournalMax_Export_${DateTime.now().millisecondsSinceEpoch}");
    saveLocation.create();
    yield 5;

    //copy the recordings folder with custom copy
    if (recordingStorage.existsSync()) {
      await copyDirectory(
          recordingStorage, Directory("${saveLocation.path}/Recordings"));
    }
    yield 25;

    //
    //copy the images folder with custom copy
    if (imageStorage.existsSync()) {
      await copyDirectory(
          imageStorage, Directory("${saveLocation.path}/Images"));
    }
    yield 50;

    //fetch all the database entries
    List<Map<String, Object?>> databaseEntries = await getAllEntry();
    List<Map<String, Object?>> recordingProcessedDatabaseEntries = [];

    //recording field processing
    for (int i = 0; i < databaseEntries.length; i++) {
      final Map<String, Object?> entry = databaseEntries[i];
      //check if there's no audio_record saved
      if (entry["audio_record"].toString() == "null") {
        continue;
      }

      //split the path by "/" and get the last two elements i.e the 'Recordings' and file name
      final recordingAddress = entry["audio_record"].toString();
      final splitRecordingAddress = recordingAddress.split("/");
      final processedRecordingAddress =
          "${splitRecordingAddress[splitRecordingAddress.length - 2]}/${splitRecordingAddress.last}";

      //replace the existing audio_record field data with the processed one

      recordingProcessedDatabaseEntries.add({
        "id": entry["id"],
        "title": entry["title"],
        "content": entry["content"],
        "mood": entry["mood"],
        "location": entry["location"],
        "audio_record": processedRecordingAddress,
        "image": entry["image"],
        "date": entry["date"],
      });
    }
    yield 62;

    List<Map<String, Object?>> fullyProcessedDatabaseEntries = [];
    for (int i = 0; i < recordingProcessedDatabaseEntries.length; i++) {
      final entry = recordingProcessedDatabaseEntries[i];
      //check if there's no saved imageArray
      if (entry["image"].toString() == "null") {
        continue;
      }
      //get ImagePath array from stored by decoding json
      final List images = jsonDecode(entry["image"].toString());

      //split the imagePaths and get the path in "Images/xyz.png" format
      final List processedImages = [];
      for (dynamic imagePath in images) {
        final splitImagePath = imagePath.split("/");
        final processedImagePath =
            "${splitImagePath[splitImagePath.length - 2]}/${splitImagePath.last}";
        processedImages.add(processedImagePath);
      }

      //add the finally processed imagePaths into the fully processed array with jsonencode
      fullyProcessedDatabaseEntries.add({
        "id": entry["id"],
        "title": entry["title"],
        "content": entry["content"],
        "mood": entry["mood"],
        "location": entry["location"],
        "audio_record": entry["audio_record"],
        "image": jsonEncode(processedImages),
        "date": entry["date"],
      });
    }

    yield 68;

    final processedDatabaseEntries = fullyProcessedDatabaseEntries;
    yield 75;

    //json Encode
    final dataToSave = jsonEncode(processedDatabaseEntries);
    final File databaseJSON = File("${saveLocation.path}/database.json");
    await databaseJSON.create();
    yield 85;

    //write the final json Export
    await databaseJSON.writeAsString(dataToSave);
    yield 100;
  } on Exception {
    showSnackBar("Something Went Wrong!", context);
    print("error");
    yield -1;
  }
}

//custom function to copy an entire directory to a target because for some absurd
//reason dart:io doesnt support that by default
Future<void> copyDirectory(
    Directory orignalDirectory, Directory targetDirectory) async {
  if (!(await orignalDirectory.exists())) {
    throw Exception("Original File doesn't exist");
  }
  if (!(await targetDirectory.exists())) {
    await targetDirectory.create(recursive: true);
  }
  final List<FileSystemEntity> targetDirectoryFiles =
      await orignalDirectory.list().toList();
  for (FileSystemEntity file in targetDirectoryFiles) {
    if (file is File) {
      await file.copy("${targetDirectory.path}/${file.path.split("/").last}");
    } else if (file is Directory) {
      continue;
    }
  }
}
