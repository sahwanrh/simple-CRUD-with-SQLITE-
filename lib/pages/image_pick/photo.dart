import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_/model/photo_model.dart';
import 'package:sqflite_/pages/image_pick/detail_photo.dart';
import 'package:sqflite_/service/db_photo.dart';

import 'list_photo.dart';

class PhotoWidget extends StatefulWidget {
  const PhotoWidget({super.key});

  @override
  State<PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  DbPhoto db = DbPhoto();
  Photo? photo;
  XFile? imgFile;
  String imageData = '';
  getImage(BuildContext context) async {
    var photos = await ImagePicker().pickImage(source: ImageSource.gallery);
    final bytes = await photos!.readAsBytes();
    final image_now = base64Encode(bytes);
    // var img = await ImagePicker().pickImage(source: ImageSource.camera);
    final XFile? xFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //XFile file = XFile(img!.path);
    setState(() {
      imgFile = xFile!;
      imageData = image_now;
      print(image_now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Container(
              height: 200,
              color: Colors.amber,
              child: imgFile == null
                  ? Center(child: Text('Tidak ada data'))
                  : Image.file(File(imgFile!.path)),
            ),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPhoto(
                          photo: Photo(0, imageData, ''),
                        ),
                      ));
                  //Get.to(DetailPhoto(photo: ''));
                },
                child: Text('SUBMIT')),
            ElevatedButton(
                onPressed: () {
                  Get.to(ListImage());
                },
                child: Text('Go to List'))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage(context);
        },
        child: Center(
          child: Icon(Icons.camera_alt),
        ),
      ),
    );
  }

  // void addPhotos() async {
  //   int result;
  //   if(photo != null){
  //     result = await
  //   }
  // }
}
