import 'dart:convert';
import 'dart:io';
import "package:path_provider/path_provider.dart";
import "package:uuid/uuid.dart";

Future<String> writeTempImagesToFile(
    {required List<File> tempImages, required int entryId}) async {
  try {
    //Initialising and getting values
    const Uuid uuid = Uuid();

    //get the app data directory
    final Directory applicationDataDirectory =
        await getApplicationDocumentsDirectory();

    //get the images directory and check if it exists
    final Directory storage =
        Directory("${applicationDataDirectory.path}/Images");
    if (!await storage.exists()) {
      await storage.create();
    }

    final List<String> storedImagePaths = [];
    final String storageLocation = storage.path;

    //loop over the given temporary images
    for (File file in tempImages) {
      final String randomUUID = uuid.v6();
      final String fileExtension = file.path.split(".").last;

      //create a path for the final image path with image directory, entryid, uuid, and extension
      String fileSaveLocation =
          '$storageLocation/${entryId}_$randomUUID.$fileExtension';

      //copy the temporary file to permanent location
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
      if (fileID == entryId.toString()) {
        await file.delete();
      }
    }

    //get the temporary images and store each of them in permanent storage with random UUID

    final String storedImagePathsJSON = jsonEncode(storedImagePaths);
    return storedImagePathsJSON;
  } on MissingPlatformDirectoryException {
    //error for folder not available
    throw Exception("Error opening storage file for the app");
  } catch (e) {
    //generic exception
    throw Exception("Error Saving Gallery Images to Storage");
  }
}
