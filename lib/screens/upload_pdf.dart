/*import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rosa/screens/pdf_viewer.dart';
import 'package:share_plus/share_plus.dart';

class Uploadpdfscreen extends StatefulWidget {
  const Uploadpdfscreen({super.key});

  @override
  State<Uploadpdfscreen> createState() => _UploadpdfscreenState();
}

class _UploadpdfscreenState extends State<Uploadpdfscreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfData = [];

  Future<String> uploadpdf(String fileName, File file) async {
    final ref = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final UploadTask = ref.putFile(file);
    await UploadTask.whenComplete(() {});
    final downloadlink = await ref.getDownloadURL();
    return downloadlink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      final downloadlink = await uploadpdf(fileName, file);
      await _firestore.collection("pdfs").add({
        "name": fileName,
        "url": downloadlink,
      });
      print("Pdf uploaded sucessfully");
    }
  }

  void getAllpdf() async {
    final results = await _firestore.collection("pdfs").get();
    pdfData = results.docs.map((e) => e.data()).toList();
    setState(() {});
  }

  void sharepdf() async {
    final results = await _firestore.collection("pdfs").get();
    pdfData = results.docs.map((e) => e.data()).toList();
    await Share.shareFiles(pdfData[0]['url']);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllpdf();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          itemCount: pdfData.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              pdfviewerScreen(pdfUrl: pdfData[index]['url']),
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          pdfData[index]['name'],
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: sharepdf,
                          icon: const Icon(
                            Icons.send,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload_file), onPressed: pickFile),
    );
  }
}
*/