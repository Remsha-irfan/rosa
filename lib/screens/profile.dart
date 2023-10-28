import 'dart:typed_data';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rosa/resources/storage_method.dart';
import 'package:rosa/screens/all_Services_of_current_user.dart';
import 'package:rosa/screens/approved_Services_of_specific_user.dart';
import 'package:rosa/screens/login.dart';
import 'package:rosa/screens/reusable_widget.dart';
import 'package:rosa/Model/user.dart' as model;
import '../providers/user_provider.dart';
import '../resources/auth_methods.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _file;
  TextEditingController name = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController field = TextEditingController();

  final bool _isLoading = false;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getUSerData();
    UserProvider userProvider = Provider.of(context, listen: false);
    name.text = userProvider.getUser.username;
    Phone.text = userProvider.getUser.phonenumber;
    field.text = userProvider.getUser.field;
    followers = userProvider.getUser.followers!.length;
    following = userProvider.getUser.following!.length;
    isFollowing = userProvider.getUser.followers!
        .contains(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  getUSerData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    field.dispose();
    Phone.dispose();
  }

  Future uploadEdited(username, file, field, phonenumber) async {
    String photoUrl = '';
    if (file != null) {
      print('inside upload image');
      photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
    } else {
      photoUrl = '';
    }
    var store = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await store.set({
      "username": username,
      "photoUrl": photoUrl,
      "field": field,
      "phonenumber": phonenumber,
    }, SetOptions(merge: true));
    print('updated');
  }

  Future _selectImage(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select The Profile Picture'),
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
                    _file = file;
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
                    _file = file;
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
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Edit Profile!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 05,
                          ),
                          buildStatColumn('Followers', followers),
                          SizedBox(
                            width: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                _file != null
                                    ? CircleAvatar(
                                        radius: 75,
                                        backgroundImage: MemoryImage(_file!),
                                      )
                                    : CircleAvatar(
                                        radius: 75,
                                        backgroundImage:
                                            NetworkImage(user.photoUrl),
                                      ),
                                Positioned(
                                  bottom: 1,
                                  left: 110,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.amber,
                                    child: IconButton(
                                      onPressed: () async {
                                        await _selectImage(context);
                                        if (_file != null) {
                                          print(_file.toString());
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.add_a_photo_outlined),
                                      color: Colors.black,
                                      iconSize: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          buildStatColumn('Following', following),
                        ],
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      Divider(
                        color: Colors.amber,
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      //Text field input for username
                      resusableContainer(reusableTextField(
                        user.username,
                        "Change Username",
                        Icons.person_outline,
                        false,
                        name,
                        (value) => value!.isEmpty ? 'Enter Valid name' : null,
                      )),
                      const SizedBox(
                        height: 18,
                      ),

                      //text field input for field
                      resusableContainer(reusableTextField(
                        user.field,
                        "Change Field",
                        Icons.work,
                        false,
                        field,
                        (value) => value!.isEmpty ? 'Enter Valid Field' : null,
                      )),
                      const SizedBox(
                        height: 18,
                      ),
                      //text field input for phone number
                      resusableContainer(reusableTextField(
                        user.phonenumber,
                        "Change phone Number",
                        Icons.phone,
                        false,
                        Phone,
                        (value) => value!.length != 11
                            ? 'Enter Valid Phone number'
                            : null,
                      )),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () => uploadEdited(
                              name.text, _file, field.text, Phone.text),
                          /* {
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc('uid')
                          .update(user.toJson());
                    },*/
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              fixedSize: const Size(250, 50),
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  "Save Changes",
                                  style: TextStyle(
                                    color: Color.fromARGB(238, 8, 8, 8),
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.white,
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
                'ROSA',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            child: AlertDialog(
                              title: const Text("Sign Out"),
                              content: const Text("Are you Sure to Sign Out?"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await AuthMethods().signOut();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                      );
                                    },
                                    child: const Text("YES")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("NO"))
                              ],
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(String label, int num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 70),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 03,
        ),
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}























































/*

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rosa/screens/reusable_widget.dart';
import 'package:rosa/Model/user.dart' as model;
import '../providers/user_provider.dart';
import '../utils/follow_button.dart';
import 'menu.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollowing = false;
  /* var userData = {};
  int postLen = 0;
  int following = 0;
  int followers = 0;
  bool isFollowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    //setState(() {
    // isLoading = true;
    //  });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();

      //get post LENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      //postLen = userSnap.data()!['posts'].length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      //isLoading = false;
    });
  }*/

  TextEditingController name1 = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                 SizedBox(
                    width: 50,
                  ),
                  buildStatColumn('follwers', 20),
                  SizedBox(
                    width: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        // _image != null?
                        /* CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!))
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://www.vectorstock.com/royalty-free-vector/default-avatar-profile-icon-vector-18942370'),
                                ),*/
                        Positioned(
                          child: IconButton(
                            onPressed: () {},
                            //selectImage
                            icon: Icon(Icons.add_a_photo),
                          ),
                          bottom: -10,
                          left: 80,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  buildStatColumn('follwers', 20),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FirebaseAuth.instance.currentUser!.uid == widget.uid?
              CustomButton(
                text: "Edit Profile",
                borderColor: Colors.black,
                textColor: Colors.black,
                backgroundColor: Colors.amber,
                function: () {},
              ):
               isFollowing
                      ? CustomButton(
                          text: "Unfollow",
                          borderColor: Colors.black,
                          textColor: Colors.black,
                          backgroundColor: Colors.amber,
                          function: () {},
                        )
                      : CustomButton(
                          text: "Follow",
                          borderColor: Colors.black,
                          textColor: Colors.black,
                          backgroundColor: Colors.amber,
                          function: () {},
                        ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "Enter username", "name", Icons.person_outline, false, name1),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "Enter Email", "Email", Icons.person_outline, false, Email),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Phone Number", "Phone Number",
                  Icons.person_outline, false, Phone),
              SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", "Password",
                  Icons.person_outline, false, Password),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Color.fromARGB(238, 8, 8, 8),
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: Colors.amber,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.chevron_left,
                size: 30,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            title: Text(
              'ROSA',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => menu()),
                  );
                },
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ]));
  }

  Column buildStatColumn(String label, int num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 70),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 03,
        ),
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rosa/screens/menu.dart';
import 'package:rosa/screens/reusable_widget.dart';
import '../providers/user_provider.dart';
import '../utils/follow_button.dart';
import 'package:rosa/Model/user.dart' as model;

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    //setState(() {
    // isLoading = true;
    //  });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();

      //get post LENGTH
      /* var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      //postLen = userSnap.data()!['posts'].length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});*/
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      //isLoading = false;
    });
  }

  TextEditingController name1 = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    buildStatColumn('follwers', 20),
                    SizedBox(
                      width: 30,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          // _image != null?
                          /* CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!))
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://www.vectorstock.com/royalty-free-vector/default-avatar-profile-icon-vector-18942370'),
                                ),*/
                          Positioned(
                            child: IconButton(
                              onPressed: () {},
                              //selectImage
                              icon: Icon(Icons.add_a_photo),
                            ),
                            bottom: -10,
                            left: 80,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    buildStatColumn('follwers', 20),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: "Edit Profilr",
                  borderColor: Colors.black,
                  textColor: Colors.black,
                  backgroundColor: Colors.amber,
                  function: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Username", "name",
                    Icons.person_outline, false, name1),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter Email", "Email", Icons.person_outline, false, Email),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Phone Number", "Phone Number",
                    Icons.person_outline, false, Phone),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", "Password",
                    Icons.person_outline, false, Password),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Color.fromARGB(238, 8, 8, 8),
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
            backgroundColor: Colors.amber,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.chevron_left,
                size: 30,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            title: Text(
              'ROSA',
              //userData['username'],
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => menu()),
                  );
                },
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ]));
  }

  Column buildStatColumn(String label, int num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 70),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 03,
        ),
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
*/