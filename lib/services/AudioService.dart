import 'dart:io';

import 'package:path_provider/path_provider.dart';

//Function to save a temporary audio file into app Data connected to the entry of the given Entry Id. Used in the
//editor page (multimedia feature) and import dialog (import-export feature)

Future<String> saveTempAudioToFile(
    {required String tempAudioFile, required int entryId}) async {
  //check if the temporary file path is available or not

  if (tempAudioFile == "null") {
    return "null";
  }

  try {
    //the app data directory
    final Directory applicationDataDirectory =
        await getApplicationDocumentsDirectory();
    final String storagePath = applicationDataDirectory.path;

    //the recordings folder in app data directory
    final Directory recordingsDirectory = Directory("$storagePath/Recordings");

    //check if the recordings folder exists and create if it doesnt
    if (!await recordingsDirectory.exists()) {
      await recordingsDirectory.create();
    }

    //concatenate the final path of the audio with recordings folder, entryID and extension
    final String finalFilePath =
        "${recordingsDirectory.path}/${entryId}_audio.m4a";

    //check if the given temporaryAudioFile is the actually the same as final path to store (an already processed
    // entry is given again) so to return right there
    if (finalFilePath == tempAudioFile) {
      return finalFilePath;
    }

    //copy the cachedFile of temporary file into the finalFilepath
    final File cachedAudioFile = File(tempAudioFile);
    await cachedAudioFile.copy(finalFilePath);

    // return the final file path for storing
    return finalFilePath;
  } on MissingPlatformDirectoryException {
    //throw exception if directory not available

    throw Exception("Error Opening storage");
  } on Exception {
    //throw generic exception
    throw Exception("Error Saving Audio To Storage");
  }
}
