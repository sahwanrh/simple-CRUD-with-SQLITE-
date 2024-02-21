import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_/model/photo_model.dart';

class DbPhoto {
  static DbPhoto? dbPhoto;
  static Database? _database;
  String? tblFoto = 'tblFoto';
  String? colId = 'id';
  String? colFoto = 'foto';
  String? colTitle = 'title';
  // factory DbPhoto (){
  //   if(dbPhoto == null){
  //     dbPhoto = DbPhoto
  //   }
  // }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return database;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'photo.db';
    var photoDb = await openDatabase(path, version: 1, onCreate: createDb);
    return photoDb;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $tblFoto ($colId INTEGER PRIMARY KEY,$colFoto TEXT,$colTitle TEXT)''');
  }

  Future<List<Map<String, dynamic>>> getPhotoMapLis() async {
    Database db = await this.database;
    var result = await db.query(tblFoto!);
    return result;
  }

  Future<int> insertPhoto(Photo photo) async {
    Database db = await this.database;
    var result = db.insert(tblFoto!, photo.toMap());
    return result;
  }

  Future<int> updatePhoto(Photo photo) async {
    Database db = await this.database;
    var result = db.update(tblFoto!, photo.toMap(),
        where: '$colId=?', whereArgs: [photo.photos]);
    return result;
  }

  Future<int> deletePhoto(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tblFoto where $colId=$id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> value =
        await db.rawQuery('SELECT COUNT (*) FROM $tblFoto');
    int? result = Sqflite.firstIntValue(value);
    return result!;
  }

  Future<List<Photo>> getImageList() async {
    var photoMapList = await getPhotoMapLis();
    int count = photoMapList.length;
    List<Photo>? listPhoto;
    for (int i = 0; i < count; i++) {
      listPhoto!.add(Photo.fromMap(photoMapList[i]));
    }
    return listPhoto!;
  }
}
