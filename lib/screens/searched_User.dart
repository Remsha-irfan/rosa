import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosa/resources/contact_controller.dart';
import 'package:rosa/resources/firestore_methods.dart';
import 'package:rosa/Model/user.dart' as model;
import 'package:rosa/utils/widgets/follow_button.dart';
import '../providers/user_provider.dart';

class SerachedUser extends StatefulWidget {
  final searchedUser;
  SerachedUser({Key? key, required this.searchedUser}) : super(key: key);
  @override
  State<SerachedUser> createState() => _SerachedUserState();
}

class _SerachedUserState extends State<SerachedUser> {
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
                      Center(
                        child: Text(
                          widget.searchedUser['username'],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 05,
                          ),
                          buildStatColumn('Followers',
                              widget.searchedUser['followers'].length),
                          SizedBox(
                            width: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 75,
                                  backgroundImage: NetworkImage(
                                      widget.searchedUser['photoUrl']),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          buildStatColumn('Following',
                              widget.searchedUser['following'].length),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == user.uid
                              ? isFollowing
                                  ? followButton(
                                      function: () async {
                                        await FirestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          user.uid,
                                        );
                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                      backgroundColor: Colors.amber,
                                      borderColor: Colors.black,
                                      text: 'UnFollow',
                                      textColor: Colors.black)
                                  : followButton(
                                      function: () async {
                                        await FirestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          widget.searchedUser['uid'],
                                        );
                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                      backgroundColor: Colors.white,
                                      borderColor: Colors.black,
                                      text: 'Follow',
                                      textColor: Colors.black)
                              : Container()
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      //Text field input for field

                      Row(
                        children: [
                          Text(widget.searchedUser['field'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 05,
                          ),
                          // Text('Department',
                          //     style: TextStyle(
                          //         fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text('Contact On :',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () async {
                                await ContactController().makeCall(
                                    widget.searchedUser['phonenumber']);
                              },
                              icon: Icon(
                                Icons.call,
                                color: Colors.amber,
                              )),
                          IconButton(
                              onPressed: () async {
                                await ContactController()
                                    .doSMS(widget.searchedUser['phonenumber']);
                              },
                              icon: Icon(
                                Icons.message,
                                color: Colors.amber,
                              )),
                          IconButton(
                              onPressed: () async {
                                await ContactController()
                                    .sendMail(widget.searchedUser['email']);
                              },
                              icon: Icon(
                                Icons.email,
                                color: Colors.amber,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.amber,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.chevron_left,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              title: const Text(
                'ROSA',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
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