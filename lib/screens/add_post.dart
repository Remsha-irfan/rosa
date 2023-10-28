import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:rosa/resources/firestore_methods.dart';
import 'package:rosa/screens/all_Services_of_current_user.dart';
import 'package:rosa/screens/approved_Services_of_specific_user.dart';
import 'package:rosa/screens/reusable_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _imgFile;
  String? pickedfile;
  Uint8List? _Pdffile;
  FilePickerResult? Pdffile;
  final TextEditingController _des = TextEditingController();
  final TextEditingController _ServicePrice = TextEditingController();
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadpdf(String fileName, File file) async {
    final ref = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final UploadTask = ref.putFile(file);
    await UploadTask.whenComplete(() {});
    final downloadlink = await ref.getDownloadURL();
    return downloadlink;
  }

  Future pickFile() async {
    Pdffile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (Pdffile != null) {
      _Pdffile = await File(Pdffile!.files[0].path!).readAsBytes();
      setState(() {
        print(Pdffile.toString());
        pickedfile = 'pdf';
        print(Pdffile!.files[0].path!);
      });
    }
  }

  Future _selectImage(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 25,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Take a Photo"),
                  ],
                ),
                onPressed: () async {
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _imgFile = file;
                    pickedfile = 'image';
                  });
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.image,
                      size: 25,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Chosse from Gallary"),
                  ],
                ),
                onPressed: () async {
                  Uint8List file = await pickImage(ImageSource.gallery);

                  setState(() {
                    _imgFile = file;
                    pickedfile = 'image';
                  });
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.cancel,
                      size: 25,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Cancel"),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _des.dispose();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    //model.
    final user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading
                ? LinearProgressIndicator(
                    color: Colors.black,
                  )
                : Container(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                children: [
                  TextField(
                    controller: _des,
                    decoration: InputDecoration(
                      labelText: 'What do you want to talk about?',
                      hintText: 'What do you want to talk about?',
                      labelStyle: const TextStyle(color: Colors.black),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    maxLength: 100,
                  ),
                  TextField(
                    controller: _ServicePrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Services Prices?',
                      hintText: 'Services Price?',
                      labelStyle: const TextStyle(color: Colors.black),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    // maxLength: 100,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  pickedfile == 'pdf'
                      ? Container(
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(blurRadius: 11, color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFFFFFFFF), width: 1)),
                          child: PDFView(
                            pdfData: _Pdffile,
                          ),
                        )
                      : pickedfile == 'image'
                          ? Container(
                              height: 350,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 11, color: Colors.grey)
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xFFFFFFFF),
                                      width: 1)),
                              child: Image.memory(
                                _imgFile!,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Container(
                              height: 350,
                              width: double.infinity,
                              child: Center(
                                child: Text('No file picked'),
                              ),
                            ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        width: 120,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(blurRadius: 11, color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFFFFFFFF), width: 1)),
                        child: IconButton(
                          onPressed: () async {
                            await _selectImage(context);
                            if (_imgFile != null) {
                              print(_imgFile.toString());
                            }
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.image,
                            size: 50,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 120,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(blurRadius: 11, color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFFFFFFFF), width: 1)),
                        child: IconButton(
                          onPressed: pickFile,
                          icon: FaIcon(
                            FontAwesomeIcons.filePdf,
                            size: 50,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: Padding(
          padding: EdgeInsets.zero,
          child: PopupMenuButton(
              itemBuilder: ((context) => [
                    PopupMenuItem(
                        child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AllServicesOfSpecificUserScreen()),
                            );
                          },
                          icon: const Icon(
                            Icons.group,
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AllServicesOfSpecificUserScreen()),
                            );
                          },
                          child: const Text(
                            "Services",
                            style: TextStyle(
                              color: Color.fromARGB(238, 8, 8, 8),
                            ),
                          ),
                        )
                      ],
                    )),
                    PopupMenuItem(
                        child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ApprovedServicesOfSpecificUserScreen()),
                            );
                          },
                          icon: const Icon(
                            Icons.local_activity,
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ApprovedServicesOfSpecificUserScreen()),
                            );
                          },
                          child: const Text(
                            "Confirmed Services",
                            style: TextStyle(
                              color: Color.fromARGB(238, 8, 8, 8),
                            ),
                          ),
                        )
                      ],
                    )),
                    PopupMenuItem(
                        child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            AppSettings.openAppSettings();
                          },
                          icon: const Icon(
                            Icons.settings,
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppSettings.openAppSettings();
                          },
                          child: const Text(
                            "Settings",
                            style: TextStyle(
                              color: Color.fromARGB(238, 8, 8, 8),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ]),
              child: Icon(
                Icons.menu,
                size: 30,
                color: Colors.black,
              )),
        ),
        centerTitle: true,
        title: const Text(
          'Post',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              try {
                String res = await FirestoreMethods().uploadPost(
                    _des.text,
                    pickedfile == 'pdf'
                        ? {'key': "pdf", "data": _Pdffile}
                        : pickedfile == 'image'
                            ? {'key': "img", "data": _imgFile}
                            : null,
                    FirebaseAuth.instance.currentUser!.uid,
                    user.username,
                    user.photoUrl,
                    int.parse(_ServicePrice.text));
                if (res == 'success') {
                  setState(() {
                    _isLoading = false;
                  });
                  showSnackBar('Posted!', context);
                } else {
                  setState(() {
                    _isLoading = false;
                  });
                  showSnackBar(res, context);
                }
              } catch (e) {
                showSnackBar(e.toString(), context);
              }
            },
            child: Text(
              "Post",
              style: TextStyle(
                color: Color.fromARGB(238, 8, 8, 8),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*  TextButton(
            onPressed: () async {
              await FirestoreMethods().uploadPost(
                  _des.text,
                  pickedfile == 'pdf'
                      ? {'key': "pdf", "data": _Pdffile}
                      : pickedfile == 'image'
                          ? {'key': "img", "data": _imgFile}
                          : null,
                  FirebaseAuth.instance.currentUser!.uid,
                  user.username,
                  user.photoUrl);
            },
            child: Text(
                    "Post",
                    style: TextStyle(
                      color: Color.fromARGB(238, 8, 8, 8),
                      fontSize: 20,
                    ),
                  ),
          ),*/