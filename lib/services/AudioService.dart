import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> saveTempAudioToFile(
    {required String tempAudioFile, required int entryId}) async {
  if (tempAudioFile == "null") {
    return "null";
  }
  try {
    final Directory storageDirectory = await getApplicationDocumentsDirectory();
    final String storagePath = storageDirectory.path;
    final Directory recordingsDirectory = Directory("$storagePath/Recordings");
    if (!await recordingsDirectory.exists()) {
      await recordingsDirectory.create();
    }
    final String finalFilePath =
        "${recordingsDirectory.path}/${entryId}_audio.m4a";
    if (finalFilePath == tempAudioFile) {
      return finalFilePath;
    }
    final File cachedAudioFile = File(tempAudioFile);
    final result = await cachedAudioFile.copy(finalFilePath);
    print("cachelength: ${await cachedAudioFile.length()}");
    print("actual file length${await result.length()}");
    return finalFilePath;
  } on MissingPlatformDirectoryException {
    throw Exception("Error Opening storage");
  } on Exception {
    throw Exception("Error Saving Audio To Storage");
  }
}
