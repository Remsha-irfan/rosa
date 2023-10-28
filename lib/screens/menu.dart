import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rosa/resources/auth_methods.dart';
import 'package:rosa/screens/all_Services_of_current_user.dart';
import 'package:rosa/screens/approved_Services_of_specific_user.dart';
import 'package:rosa/screens/login.dart';
import 'package:rosa/utils/widgets/postcard.dart';

class menu extends StatefulWidget {
  const menu({super.key});

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  @override
  // void initState() {
  //   getallPosts();
  //   super.initState();
  // }

  // getallPosts() async {
  //   UserProvider userProvider = Provider.of(context, listen: false);
  //   print(userProvider.getPost.length);
  //   await userProvider.refreshPost();
  // }

  @override
  Widget build(BuildContext context) {
    //UserProvider user = Provider.of(context, listen: false);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  PostCard(snap: snapshot.data!.docs[index].data()));
        },
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
          'ROSA',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25),
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
}

/* () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: AlertDialog(
                                        title: const Text("Sign Out"),
                                        content: const Text(
                                            "Are you Sure to Sign Out?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                await AuthMethods().signOut();
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login()),
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
                            },*/
