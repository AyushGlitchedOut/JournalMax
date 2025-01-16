import 'dart:convert';
import 'dart:io';
import "package:path_provider/path_provider.dart";
import "package:uuid/uuid.dart";

Future<String> writeTempImagesToFile(
    {required List<File> tempImages, required int EntryId}) async {
  try {
    final Directory storage = await getApplicationDocumentsDirectory();
    final String storageLocation = storage.path;
    final List<String> storedImages = [];
    var uuid = const Uuid();
//TODO: prevent saving files twice by deleting files with the same ENtryID at start already
    for (File file in tempImages) {
      final String fileUUID = uuid.v6();
      final String fileExtension = file.path.split('.').last;
      String saveFileAt =
          '$storageLocation/${EntryId}_$fileUUID.$fileExtension';
      final File savedFile = await file.copy(saveFileAt);
      storedImages.add(savedFile.path);
    }
    final String storedImagesJSON = jsonEncode(storedImages);
    return storedImagesJSON;
  } on MissingPlatformDirectoryException {
    throw Exception("Error opening storage file for the app");
  } catch (e) {
    print(e);
    throw Exception("Error Saving Gallery Images to Storage");
  }
}
