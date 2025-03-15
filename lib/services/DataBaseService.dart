import 'dart:io';

import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/CleanCache.dart';
import 'package:journalmax/services/InitDataBase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//all exceptions have snackbars to throw generic messages on errors
//all platform exceptions show messages if folders arent accesible

//Create

//create a new entry in database based on given Entry object
Future<void> pushEntry(Entry entry) async {
  try {
    final db = await Initdatabase().database;
    await db.insert(
        "items",
        {
          "title": entry.title,
          "content": entry.content,
          "mood": entry.mood,
          "location": entry.location,
          "audio_record": entry.audioRecord,
          "image": entry.image,
          "date":
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  } on Exception {
    throw Exception("Error inserting Entry to DataBase");
  }
}

// Read

//get all the entries from the given search query
Future<List<Map<String, Object?>>> getEntry(String query) async {
  try {
    final db = await Initdatabase().database;
    final res =
        await db.query("items", where: "title LIKE ?", whereArgs: ["%$query%"]);
    return res;
  } on Exception {
    throw Exception("Error getting Entries by query");
  }
}

//get all entries (dump the entire database)
Future<List<Map<String, Object?>>> getAllEntry() async {
  try {
    final db = await Initdatabase().database;
    final res = db.query("items");
    return res;
  } on Exception {
    throw Exception("Error retrieving all the Entries in DataBase");
  }
}

//get a specific entry by its ID
Future<List<Map<String, Object?>>> getEntryById(int id) async {
  try {
    final db = await Initdatabase().database;
    final res = await db.query("items", where: "id = ?", whereArgs: [id]);
    return res;
  } on Exception {
    throw Exception("Error getting a specific Entry by Id");
  }
}

//get the 10 most recent entries by their id (limit:)
Future<List<Map<String, dynamic>>> getRecentEntries() async {
  try {
    final db = await Initdatabase().database;
    return await db.query(
      'items',
      orderBy: 'id DESC',
      limit: 10,
    );
  } on Exception {
    throw Exception("Error getting the most Recent Entries");
  }
}

//Update

//update the entry with an ID to find it and an entry object to update its contents
Future<void> updateEntry(int id, Entry entry) async {
  try {
    final db = await Initdatabase().database;
    db.update(
        "items",
        {
          "title": entry.title,
          "content": entry.content,
          "mood": entry.mood.toString(),
          "location": entry.location,
          "audio_record": entry.audioRecord,
          "image": entry.image,
          "date":
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
        },
        where: "id = $id",
        conflictAlgorithm: ConflictAlgorithm.replace);
  } on Exception {
    throw Exception("Error updating an Entry");
  }
}

//Delete

//delete a specific entry by its id
Future<void> deleteEntry(int entryId) async {
  try {
    //Specify the directories
    final Directory storage = await getApplicationDocumentsDirectory();
    final Directory imageStorage = Directory("${storage.path}/Images");
    final Directory recordingStorage = Directory("${storage.path}/Recordings");

    //delete all files with the given EntryId in image folder
    if ((await imageStorage.exists())) {
      final imageFiles = await imageStorage.list().toList();
      for (FileSystemEntity file in imageFiles) {
        final String fileName = file.path.split("/").last;
        final String fileID = fileName.split("_").first;
        if (fileID == entryId.toString()) {
          file.delete();
        }
      }
    }

    //delete all the files with the given EntryId in recordings folder
    if (await recordingStorage.exists()) {
      final recordingFiles = await recordingStorage.list().toList();

      for (FileSystemEntity file in recordingFiles) {
        final String fileName = file.path.split("/").last;
        final String fileID = fileName.split("_").first;
        if (fileID == entryId.toString()) {
          file.delete();
        }
      }
    }

    //wipe cache
    await clearCache();

    //Wipe DB
    final db = await Initdatabase().database;
    db.delete("items", where: "id = ?", whereArgs: ["$entryId"]);
  } on MissingPlatformDirectoryException {
    throw Exception("Unable to Delete Stored Files");
  } on Exception {
    throw Exception("Error deleting an Entry by Id");
  }
}

//clear the entire storage deleting all entires and deleting the folders for file storage
Future<void> wipeOrdeleteAllEntry() async {
  try {
    //specify the directories
    final Directory storage = await getApplicationDocumentsDirectory();
    final Directory imageDirectory = Directory("${storage.path}/Images");
    final Directory recordingsDirectory =
        Directory("${storage.path}/Recordings");

    //delete the images Directory
    if (await imageDirectory.exists()) {
      await imageDirectory.delete(recursive: true);
    }

    //delete the recordingsDirectory
    if (await recordingsDirectory.exists()) {
      await recordingsDirectory.delete(recursive: true);
    }

    //clear cache
    await clearCache();

    //Wipe DB
    final db = await Initdatabase().database;
    await db.delete("items");
  } on MissingPlatformDirectoryException {
    throw Exception("Unable to Delete Stored Files");
  } on Exception {
    throw Exception("Error wiping the Database");
  }
}

//Miscellanous

//get the number of entries stored in the database
Future<int> getNumberOfEntries() async {
  try {
    final db = await Initdatabase().database;
    final result = await db.rawQuery('SELECT COUNT(*) AS count FROM items');
    return result.isNotEmpty ? result.first["count"] as int : 0;
  } on Exception {
    return 0;
  }
}
