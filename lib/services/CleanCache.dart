import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<void> clearCache() async {
  try {
    final Directory cacheDirectory = await getApplicationCacheDirectory();
    final List<FileSystemEntity> filesToDelete =
        await cacheDirectory.list().toList();
    for (FileSystemEntity file in filesToDelete) {
      await file.delete(recursive: true);
    }
  } on MissingPlatformDirectoryException {
    throw Exception("Cache Directory inaccesible!");
  } on Exception {
    throw Exception("Something Went Wrong");
  }
}
