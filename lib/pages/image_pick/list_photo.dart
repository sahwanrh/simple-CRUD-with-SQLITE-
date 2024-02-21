import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_/model/photo_model.dart';
import 'package:sqflite_/pages/image_pick/photo.dart';
import 'package:sqflite_/service/db_photo.dart';

import 'detail_photo.dart';

class ListImage extends StatefulWidget {
  const ListImage({super.key});

  @override
  State<ListImage> createState() => _ListImageState();
}

class _ListImageState extends State<ListImage> {
  DbPhoto db = DbPhoto();
  List<Photo>? photoList;

  @override
  Widget build(BuildContext context) {
    if (photoList == null) {
      photoList = List<Photo>.empty(); //List<Photo>[];
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: SizedBox(
        height: 200,
        child: ListView.builder(
          itemCount: photoList == null ? 0 : photoList?.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 6,
              child: ListTile(
                title: Text(this.photoList![index].title),
                leading:
                    Image.memory(base64Decode(this.photoList![index].photos)),
                //subtitle: Text('123'),
                trailing: IconButton(
                    onPressed: () {
                      delete(context, photoList![index]);
                    },
                    icon: Icon(Icons.delete)),
                onTap: () {
                  this.photoList![index];
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(PhotoWidget());
        },
        child: Icon(Icons.logout),
      ),
    );
  }

  void navCamera(Photo? photo) async {
    bool result = await Get.to(DetailPhoto(
      photo: photo!,
    ));
    if (result != true) {
      updateListView();
    }
  }

  void delete(BuildContext context, Photo photo) async {
    int result = await db.deletePhoto(photo.id);
    if (result != 0) {
      showDialogg();
      updateListView();
    }
  }

  showDialogg() {
    Get.snackbar('Sukses', 'Berhasil');
  }

  void updateListView() {
    final Future<Database> dbFuture = db.initDb();
    dbFuture.then((database) {
      Future<List<Photo>> futureListPhoto = db.getImageList();
      futureListPhoto.then((imageList) {
        setState(() {
          this.photoList = imageList;
          this.photoList!.length = photoList!.length;
          print(dbFuture.toString());
        });
      });
    });
  }
}
