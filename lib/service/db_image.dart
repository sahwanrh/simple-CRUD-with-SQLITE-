import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_/model/image_model.dart';

class ImageDBHelper {
  static final ImageDBHelper _instance = ImageDBHelper._instance;

  static Database? db;
  initDb() async {
    Directory docDirectory = await getApplicationCacheDirectory();
    String path = join(docDirectory.path, "image.db");
    var theDB = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE user (
          int INTEGER PRIMARY KEY,
          name TEXT,
      )''');
    });
    return theDB;
  }

  Future<int> saveImage(ImageModel imageModel) async {
    var dbClient = db;
    int res = await dbClient!.insert('user', imageModel.toMap());
    return res;
  }

  Future<List<ImageModel>> getImage() async {
    var dbClient = db;
    List<Map<String, dynamic>> lists =
        await dbClient!.rawQuery('SELECT * FROM user');
    List<ImageModel> images = [];
    for (var i = 0; i < lists.length; i++) {
      images.add(ImageModel.fromMap(lists[i]));
    }
    ;
    return images;
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}
