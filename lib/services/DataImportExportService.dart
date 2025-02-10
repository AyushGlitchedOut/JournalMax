// The concept: Whenever we export the database, we first ask the user for a new name for the folder to save
// create the folder in Downloads folder
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/services/CRUD_Entry.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:path_provider/path_provider.dart';

//TODO: make both of them streams of double that return the work percentage completed
//(files imported exported in total) to show in the dialogs
//
Future<void> importDataFromFolder(BuildContext context) async {
  try {
    final FilePicker filepicker = FilePickerIO();
    final String? selectedFolder = await filepicker.getDirectoryPath();
    if (selectedFolder.toString() == "null") {
      showSnackBar("No folder Selected", context);
      return;
    }
    print(selectedFolder);
  } on Exception {
    throw Exception("Couldn't import Files Succesfully");
  }
}

Stream<int> exportDataToFolder(BuildContext context) async* {
  yield 0;
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
    //create a file inside the Downloads Directory with epoch time for exporting
    final Directory saveLocation = Directory(
        "${downloadsDirectory.path}/JournalMax_Export_${DateTime.now().millisecondsSinceEpoch}");
    saveLocation.create();
    yield 5;
    await copyDirectory(recordingStorage, saveLocation);
    yield 25;
    await copyDirectory(imageStorage, saveLocation);
    yield 50;

    final List<Map<String, Object?>> databaseEntries = await getAllEntry();
    // convert all the absolute file paths in database entries to just the file names
    //like we saved in the copy Directory function like Recordings/xy_Recording.m4a or
    // Images/69_aaaa-bbbb-cccc-dddd.jpg so that we can relatively access them when importing data back

    // **conversion logic**
    final processedDatabaseEntries = databaseEntries;
    yield 75;

    //json Encode
    final dataToSave = jsonEncode(processedDatabaseEntries);
    final File databaseJSON = File("${saveLocation.path}/database.json");
    await databaseJSON.create();
    yield 85;

    await databaseJSON.writeAsString(dataToSave);
    yield 100;
  } on Exception {
    showSnackBar("Something Went Wrong!", context);
    yield -1;
  }

  //copy the recordings and images folder to it
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
