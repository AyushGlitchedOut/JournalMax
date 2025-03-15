import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/AudioService.dart';
import 'package:journalmax/services/DataBaseService.dart';
import 'package:journalmax/services/ImageService.dart';
import 'package:journalmax/services/InsertEntry.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:path_provider/path_provider.dart';

Stream<int> importDataFromFolder(
    BuildContext context, String? selectedFolder) async* {
  try {
    if (selectedFolder.toString() == "null") {
      showSnackBar("No folder Selected", context);
      return;
    }
    yield 1;

    // jsondecode the data from stored database.json
    final Directory importDirectory = Directory(selectedFolder!);
    final File storedJSONDb = File("${importDirectory.path}/database.json");
    if (!(await storedJSONDb.exists())) {
      showSnackBar("Invalid import folder", context);
      yield -1;
      return;
    }
    final String JSONDbData = await storedJSONDb.readAsString();
    final List<dynamic> decodedEntries = jsonDecode(JSONDbData);
    yield 25;

    //the main logic for inserting each individual entry
    for (int i = 0; i < decodedEntries.length; i++) {
      //yield 50% if half the entries are imported
      if (i > decodedEntries.length / 2) {
        yield 50;
      }
      //create a new entry with the data from the imported entry
      final entry = decodedEntries[i];
      await insertEntry(
          entry["title"],
          entry["content"],
          entry["mood"],
          entry["date"],
          entry["location"],
          entry["audio_record"],
          entry["image"]);

      //get the entry of the newly created entry
      final insertedEntryId = (await getRecentEntries()).first["id"];
      print(insertedEntryId);

      //insert a recording using the recordingService on the id of the newly created entry
      final String recordingPath =
          "${importDirectory.path}/${entry["audio_record"]}";
      final savedRecordingPath = await saveTempAudioToFile(
          tempAudioFile: recordingPath, entryId: insertedEntryId);

      //insert the images using imageService on the id of the newly created entry
      final List imagePaths = jsonDecode(entry["image"]);
      List<File> imageFilesToStore = [];
      for (final imagePath in imagePaths) {
        final actualImagePath = "${importDirectory.path}/$imagePath";
        imageFilesToStore.add(File(actualImagePath));
      }
      final savedImagePaths = await writeTempImagesToFile(
          tempImages: imageFilesToStore, entryId: insertedEntryId);

      //update the newly created entry with the new paths to the imported recording and image files
      updateEntry(
          insertedEntryId,
          Entry(
              title: entry["title"],
              content: entry["content"],
              mood: entry["mood"],
              date: entry["date"],
              image: savedImagePaths,
              location: entry["location"],
              audioRecord: savedRecordingPath));
      //
    }
    //complete the stream
    yield 75;
    yield 100;
  } on Exception {
    showSnackBar("Import Failed", context);
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
    await saveLocation.create();
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
    showSnackBar("Export Failed", context);
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
