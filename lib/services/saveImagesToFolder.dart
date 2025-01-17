import 'dart:convert';
import 'dart:io';
import "package:path_provider/path_provider.dart";
import "package:uuid/uuid.dart";

Future<String> writeTempImagesToFile(
    {required List<File> tempImages, required int EntryId}) async {
  try {
    //Initialising and getting values
    const Uuid uuid = Uuid();
    final Directory storage = await getApplicationDocumentsDirectory();

    final List<String> storedImagePaths = [];
    final String storageLocation = storage.path;
    for (File file in tempImages) {
      final String randomUUID = uuid.v6();
      final String fileExtension = file.path.split(".").last;
      String fileSaveLocation =
          '$storageLocation/${EntryId}_$randomUUID.$fileExtension';
      final File savedFile = await file.copy(fileSaveLocation);
      storedImagePaths.add(savedFile.path);
    }

    //Delete all the Entries with the same EntryID already existing
    final List<FileSystemEntity> storedFiles = await storage.list().toList();
    for (FileSystemEntity file in storedFiles) {
      final String fileName = file.path.split("/").last;
      final String fileID = fileName.split("_").first;
      if (storedImagePaths.contains(file.path)) {
        continue;
      }
      if (fileID == EntryId.toString()) {
        await file.delete();
      } else {
        print("NOOOO");
      }
    }

    //get the temporary images and store each of them in permanent storage with random UUID

    final String storedImagePathsJSON = jsonEncode(storedImagePaths);
    return storedImagePathsJSON;
    // final Directory storage = await getApplicationDocumentsDirectory();
    // final String storageLocation = storage.path;
    // final List<String> storedImages = [];
    // var uuid = const Uuid();
    // //TODO: prevent saving files twice by deleting files with the same ENtryID at start already
    // final List<FileSystemEntity> files = await storage.list().toList();
    // for (FileSystemEntity file in files) {
    //   final String fileName = file.path.split("/").last;
    //   if (fileName.split("_").first == EntryId.toString()) {
    //     await file.delete();
    //   }
    // }
  } on MissingPlatformDirectoryException {
    throw Exception("Error opening storage file for the app");
  } catch (e) {
    print(e);
    throw Exception("Error Saving Gallery Images to Storage");
  }
}
