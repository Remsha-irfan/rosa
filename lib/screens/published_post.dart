import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosa/providers/user_provider.dart';
import 'package:rosa/resources/auth_methods.dart';
import 'package:rosa/resources/firestore_methods.dart';
import 'package:rosa/screens/Published_pdfScreen.dart';
import 'package:rosa/screens/all_Services_of_current_user.dart';
import 'package:rosa/screens/approved_Services_of_specific_user.dart';
import 'package:rosa/screens/image.dart';
import 'package:rosa/screens/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CurrentUserPosts extends StatefulWidget {
  const CurrentUserPosts({super.key});

  @override
  State<CurrentUserPosts> createState() => _CurrentUserPostsState();
}

class _CurrentUserPostsState extends State<CurrentUserPosts> {
  @override
  void initState() {
    grtPublishedPosts();
    super.initState();
  }

  grtPublishedPosts() async {
    final user = Provider.of<UserProvider>(context);
    await user.refreshSpecificUserPost();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data!.docs.toList().length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs.toList();
                    return Stack(children: [
                      Container(
                        height: 140,
                        width: 140,
                        color: Colors.black12,
                        child: data[index]['imgPostUrl']!.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ImageView(
                                              ImageUrl: data[index]
                                                  ['imgPostUrl'],
                                              caption: data[index]
                                                  ['description'],
                                              username: data[index]['username'],
                                              postId: data[index]['postId'],
                                              personal: true,
                                            )),
                                  );
                                },
                                child: Image.network(data[index]['imgPostUrl'],
                                    fit: BoxFit.cover),
                              )
                            : data[index]['pdfPostUrl']!.isNotEmpty
                                ? Center(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PublishedPdfView(
                                                          pdfUrl: data[index]
                                                              ['pdfPostUrl'],
                                                          caption: data[index]
                                                              ['description'],
                                                          username: data[index]
                                                              ['username'],
                                                          postId: data[index]
                                                              ['postId'],
                                                          personal: true)));
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.filePdf,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            'PDF FILE',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ],
                                  ))
                                : Container(
                                    height: 350,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        'No Posts',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 50),
                                      ),
                                    ),
                                  ),
                      ),
                      Positioned(
                        left: 95,
                        child: IconButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: AlertDialog(
                                      title: const Text("Delete Post"),
                                      content: const Text(
                                          "Are you Sure to Delete the post?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              await FirestoreMethods()
                                                  .deletePost(
                                                      data[index]['postId']!);
                                              Navigator.of(context).pop;
                                            },
                                            child: Text("YES")),
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
                          icon: const Icon(Icons.more_vert),
                          color: Colors.white,
                          iconSize: 35,
                        ),
                      ),
                    ]);
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('something went wrong'),
                );
              } else {
                return Center(
                  child: Text('loading...'),
                );
              }
            }),
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

/*import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosa/providers/user_provider.dart';
import 'package:rosa/resources/auth_methods.dart';
import 'package:rosa/resources/firestore_methods.dart';
import 'package:rosa/screens/login.dart';
import 'package:rosa/screens/view_pdf_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CurrentUserPosts extends StatefulWidget {
  const CurrentUserPosts({super.key});

  @override
  State<CurrentUserPosts> createState() => _CurrentUserPostsState();
}

class _CurrentUserPostsState extends State<CurrentUserPosts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        child: GridView.builder(
          itemCount: user.getCurrentUSerPost.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
          itemBuilder: (context, index) {
            return Stack(children: [
              Container(
                height: 140,
                width: 140,
                color: Colors.black12,
                child: user.getPost[index].imgPostUrl!.isNotEmpty
                    ? Image.network(user.getPost[index].imgPostUrl!,
                        fit: BoxFit.cover)
                    : user.getPost[index].pdfPostUrl!.isNotEmpty
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ViewPDFScreen(
                                          pdfUrl: user
                                              .getPost[index].pdfPostUrl!)));
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.filePdf,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                              /*   SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            'PDF FILE',
                                            style: TextStyle(color: Colors.white),
                                          )
                                          ),*/
                            ],
                          ))
                        : Container(
                            height: 350,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'No Posts',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 50),
                              ),
                            ),
                          ),
              ),
              Positioned(
                left: 95,
                child: IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            child: AlertDialog(
                              title: const Text("Delete Post"),
                              content: const Text(
                                  "Are you Sure to Delete the post?"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await FirestoreMethods().deletePost(
                                          user.getPost[index].postId!);
                                      Navigator.of(context).pop;
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
                  icon: const Icon(Icons.more_vert),
                  color: Colors.white,
                  iconSize: 35,
                ),
              ),
            ]);
          },
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
                            /*   Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Newsfeed()),
                            );*/
                          },
                          icon: const Icon(
                            Icons.feed,
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Text(
                          "Newsfeed",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
                          ),
                        )
                      ],
                    )),
                    PopupMenuItem(
                        child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            /* Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Groupscreen()),
                            );*/
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
                        const Text(
                          "Groups/Forms",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
                          ),
                        )
                      ],
                    )),
                    PopupMenuItem(
                        child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            /* Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Friendscreen()),
                            );*/
                          },
                          icon: const Icon(
                            Icons.group_work,
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Text(
                          "Friends",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
                          ),
                        )
                      ],
                    )),
                    PopupMenuItem(
                        child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            /*  Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Messagescreen()),
                            );*/
                          },
                          icon: const Icon(
                            Icons.message_outlined,
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Text(
                          "Message",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
                          ),
                        )
                      ],
                    )),
                    PopupMenuItem(
                        child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications,
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Text(
                          "Notification",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
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
                        const Text(
                          "Setting",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
                          ),
                        )
                      ],
                    )),
                    PopupMenuItem(
                        child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.feedback,
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Text(
                          "Feedback",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
                          ),
                        )
                      ],
                    )),
                  ]),
              child: const Icon(
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

*/