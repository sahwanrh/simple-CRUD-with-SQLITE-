import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_/model/photo_model.dart';
import 'package:sqflite_/service/db_photo.dart';

class DetailPhoto extends StatefulWidget {
  const DetailPhoto({super.key, required this.photo});
  final Photo photo;

  @override
  State<DetailPhoto> createState() => _DetailPhotoState();
}

class _DetailPhotoState extends State<DetailPhoto> {
  DbPhoto db = DbPhoto();
  Photo? photo;
  final titleC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    titleC.text = photo!.title;
    final decodeBytes = base64Decode(photo!.photos);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              color: Colors.teal,
              child: Image.memory(decodeBytes),
            ),
            SizedBox(height: 15),
            TextField(
              onChanged: (value) {
                updateTitle();
              },
              controller: titleC,
              decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            ElevatedButton(
                onPressed: () {
                  save();
                },
                child: Text('ADD')),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Get.back();
  }

  void updateTitle() async {
    photo!.title = titleC.text;
  }

  void save() async {
    moveToLastScreen();
    int result;
    if (photo?.id != null) {
      result = await db.updatePhoto(photo!);
    } else {
      result = await db.insertPhoto(photo!);
    }
  }
}
