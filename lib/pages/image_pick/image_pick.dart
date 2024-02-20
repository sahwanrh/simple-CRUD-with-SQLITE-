import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_/model/image_model.dart';
import 'package:sqflite_/service/db_image.dart';
import 'package:sqflite_/service/utility.dart';

class ImagePick extends StatefulWidget {
  const ImagePick({super.key});

  @override
  State<ImagePick> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  Future<File>? imageFile;
  Image? image;
  ImageDBHelper? imageDb;
  List<ImageModel?> lists = [];
  refreshImage() {
    imageDb?.getImage().then((value) {
      lists.clear();
      lists.addAll(value);
    });
  }

  pickImageFromGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
      String imgString = Utility.base64String(await imgFile!.readAsBytes());
      print(imgString);
      ImageModel imageModel = ImageModel(0, imgString);
      imageDb!.saveImage(imageModel);
      refreshImage();
    });
  }

  @override
  void initState() {
    super.initState();
    lists = [];
    imageDb = ImageDBHelper();
    refreshImage();
  }

  gridview() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        children: lists.map((e) {
          return Utility.imageFromBase64String(e?.name ?? "");
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                pickImageFromGallery();
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Flexible(child: gridview())],
        ),
      ),
    );
  }
}
