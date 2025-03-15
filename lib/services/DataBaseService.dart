import 'dart:io';

import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/CleanCache.dart';
import 'package:journalmax/services/InitDataBase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//Create
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

Future<List<Map<String, Object?>>> getAllEntry() async {
  try {
    final db = await Initdatabase().database;
    final res = db.query("items");
    return res;
  } on Exception {
    throw Exception("Error retrieving all the Entries in DataBase");
  }
}

Future<List<Map<String, Object?>>> getEntryById(int id) async {
  try {
    final db = await Initdatabase().database;
    final res = await db.query("items", where: "id = ?", whereArgs: [id]);
    return res;
  } on Exception {
    throw Exception("Error getting a specific Entry by Id");
  }
}

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

Future<void> deleteEntry(int Entryid) async {
  try {
    //Delete items in storage
    final Directory storage = await getApplicationDocumentsDirectory();
    final Directory imageStorage = Directory("${storage.path}/Images");
    final Directory recordingStorage = Directory("${storage.path}/Recordings");

    if (!await imageStorage.exists()) {
      final imageFiles = await imageStorage.list().toList();
      for (FileSystemEntity file in imageFiles) {
        final String fileName = file.path.split("/").last;
        final String fileID = fileName.split("_").first;
        if (fileID == Entryid.toString()) {
          file.delete();
        }
      }
    }

    if (!await recordingStorage.exists()) {
      final recordingFiles = await recordingStorage.list().toList();

      for (FileSystemEntity file in recordingFiles) {
        final String fileName = file.path.split("/").last;
        final String fileID = fileName.split("_").first;
        if (fileID == Entryid.toString()) {
          file.delete();
        }
      }
    }

    //wipe cache
    await clearCache();

    //Wipe DB
    final db = await Initdatabase().database;
    db.delete("items", where: "id = ?", whereArgs: ["$Entryid"]);
  } on MissingPlatformDirectoryException {
    throw Exception("Unable to Delete Stored Files");
  } on Exception {
    throw Exception("Error deleting an Entry by Id");
  }
}

Future<void> wipeOrdeleteAllEntry() async {
  try {
    //Delete Items in Storage
    final Directory storage = await getApplicationDocumentsDirectory();
    final Directory imageDirectory = Directory("${storage.path}/Images");
    final Directory recordingsDirectory =
        Directory("${storage.path}/Recordings");
    if (await imageDirectory.exists()) {
      await imageDirectory.delete(recursive: true);
    }
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
Future<int> getNumberOfEntries() async {
  try {
    final db = await Initdatabase().database;
    final result = await db.rawQuery('SELECT COUNT(*) AS count FROM items');
    return result.isNotEmpty ? result.first["count"] as int : 0;
  } on Exception {
    return 0;
  }
}
