import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

//a function to clear the cache as it can build up from the stored temporary files
Future<void> clearCache() async {
  try {
    //get the Cache Directory
    final Directory cacheDirectory = await getApplicationCacheDirectory();

    //get the files to delete by listing the cache firectory out
    final List<FileSystemEntity> filesToDelete =
        await cacheDirectory.list().toList();

    //loop over all the files and delete every single one
    for (FileSystemEntity file in filesToDelete) {
      await file.delete(recursive: true);
    }
    if (kDebugMode) print("Cleared Cache!");
  } on MissingPlatformDirectoryException {
    //exception if cache directory is unavailable
    throw Exception("Cache Directory inaccesible!");
  } on Exception {
    //generic exception
    throw Exception("Something Went Wrong");
  }
}
