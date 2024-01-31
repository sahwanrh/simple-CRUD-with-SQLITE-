import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_/service/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allData = [];
  bool isLoading = true;
  void _refreshData() async {
    final data = await SqlHelper.getAllData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  final TextEditingController titleC = TextEditingController();
  final TextEditingController descC = TextEditingController();
  void addData() async {
    await SqlHelper.createDate(titleC.text, descC.text);
    _refreshData();
  }

  void updateData(int id) async {
    await SqlHelper.updateDate(id, titleC.text, descC.text);
    _refreshData();
  }

  void deleteData(int id) async {
    await SqlHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Data Has deleted'),
        backgroundColor: Colors.pink));
    _refreshData();
  }

  void showBottomSheet_(int? id) async {
    if (id != null) {
      final existingData = allData.firstWhere((element) => element['id'] == id);
      titleC.text = existingData['title'];
      descC.text = existingData['desc'];
    }
    showModalBottomSheet(
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  top: 30,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: titleC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Title'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLines: 4,
                    controller: descC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Description'),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            addData();
                          }
                          if (id != null) {
                            updateData(id);
                          }
                          titleC.text = "";
                          descC.text = "";
                          Get.back();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(id == null ? 'Add Data' : 'Update Data'),
                        )),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRUD With SQFLite'), centerTitle: true),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: allData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: ListTile(
                    title: Text(
                      allData[index]['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    subtitle: Text(allData[index]['desc']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              showBottomSheet_(allData[index]['id']);
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  title: 'Hapus',
                                  content: Text(
                                      'Anda yakin ingin menghapus ${allData[index]['title']} ?'),
                                  cancel: OutlinedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('Cancel')),
                                  confirm: ElevatedButton(
                                    onPressed: () {
                                      deleteData(allData[index]['id']);
                                      Get.back();
                                    },
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.pink)),
                                  ));
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.pink,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet_(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
