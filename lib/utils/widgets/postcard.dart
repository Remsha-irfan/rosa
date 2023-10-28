import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rosa/resources/firestore_methods.dart';
import 'package:rosa/screens/coment_screen.dart';
import 'package:rosa/screens/ServicesCharges_screen.dart';
import 'package:rosa/screens/view_pdf_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await FirestoreMethods().viewPost(widget.snap['postId'],
            FirebaseAuth.instance.currentUser!.uid, widget.snap['views']);
      },
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                      .copyWith(right: 0),
                  child: Row(children: [
                    widget.snap['profImage']!.isNotEmpty
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(widget.snap['profImage']))
                        : SizedBox(),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.snap['username']!,
                      // user.getPost[index].username!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
                //image and PDF section
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: widget.snap['imgPostUrl'].isNotEmpty
                        ? Image.network(widget.snap['imgPostUrl'],
                            fit: BoxFit.cover)
                        : widget.snap['pdfPostUrl'].isNotEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewPDFScreen(
                                                    pdfUrl: widget
                                                        .snap['pdfPostUrl'],
                                                    username: widget
                                                        .snap['username']!,
                                                  )));
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.filePdf,
                                      size: 50,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ))
                            : SizedBox(
                                /* child: Text(
                          user.getPost[index].description,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),*/
                                )),
                //Like, Comment Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await FirestoreMethods().likePost(
                                widget.snap['postId']!,
                                FirebaseAuth.instance.currentUser!.uid,
                                widget.snap['likes'],
                              );
                            },
                            icon: widget.snap['likes'].contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                  )),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Commentscreen(
                                        postId: widget.snap['postId']!,
                                      )));
                            },
                            icon: Icon(
                              Icons.comment_outlined,
                            )),
                        IconButton(
                            onPressed: () async {
                              if (widget.snap['imgPostUrl']!.isNotEmpty ||
                                  widget.snap['pdfPostUrl']!.isNotEmpty) {
                                http.Response response = await http.get(
                                    Uri.parse(
                                        widget.snap['imgPostUrl']!.isNotEmpty
                                            ? widget.snap['imgPostUrl']!
                                            : widget.snap['pdfPostUrl']!));
                                Directory dir = await getTemporaryDirectory();
                                File imgFile = File('${dir.path}/imgfile.png');
                                File pdfFile = File('${dir.path}/pdffile.pdf');
                                widget.snap['imgPostUrl']!.isNotEmpty
                                    ? await imgFile
                                        .writeAsBytes(response.bodyBytes)
                                    : await pdfFile
                                        .writeAsBytes(response.bodyBytes);
                                widget.snap['imgPostUrl']!.isNotEmpty
                                    ? await Share.shareXFiles(
                                        [XFile(imgFile.path)])
                                    : await Share.shareXFiles(
                                        [XFile(pdfFile.path)]);
                              }
                            },
                            icon: Icon(
                              Icons.send,
                            )),
                      ],
                    ),
                    widget.snap['status'] == 'sold'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Working..',
                              style: TextStyle(),
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ServicesChargesScreen(
                                      snap: widget.snap)));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.design_services),
                                SizedBox(
                                  width: 05,
                                ),
                                Text('Services'),
                              ],
                            ))
                    //  IconButton(
                    //     onPressed: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => ServicesChargesScreen(
                    //               snap: widget.snap)));
                    //     },
                    //     icon: FaIcon(FontAwesomeIcons.buyNLarge)),
                  ],
                ),
                //Description
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.snap['likes'].length} Likes',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '${widget.snap['views'].length} views',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 8),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: widget.snap['username'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                WidgetSpan(
                                    // alignment: PlaceholderAlignment.baseline,
                                    // baseline: TextBaseline.alphabetic,
                                    child: SizedBox(width: 05)),
                                TextSpan(
                                    text: widget.snap['description'],
                                    style: TextStyle(fontSize: 14)),
                              ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          widget.snap['datePublished'].toString(),
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ),
                      Divider(
                        color: Colors.amber,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}



/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosa/providers/user_provider.dart';
import 'package:rosa/resources/firestore_methods.dart';
import 'package:rosa/screens/coment_screen.dart';
import 'package:rosa/screens/view_pdf_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  @override
  void initState() {
    getallPosts();
    getcomment();
    super.initState();
  }

  void getcomment() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
  }

  getallPosts() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    //print(userProvider.getPost.length);
    await userProvider.refreshPost();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of(context, listen: false);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        itemCount: user.getPost.length,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                      .copyWith(right: 0),
                  child: Row(children: [
                    user.getPost[index].profImage!.isNotEmpty
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(user.getPost[index].profImage!))
                        : SizedBox(),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      user.getPost[index].username!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
                //image and PDF section
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewPDFScreen(
                                                      pdfUrl: user
                                                          .getPost[index]
                                                          .pdfPostUrl!)));
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.filePdf,
                                      size: 50,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ))
                            : SizedBox(
                                /* child: Text(
                          user.getPost[index].description,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),*/
                                )),
                //Like, Comment Section
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                              user.getPost[index].postId!,
                              user.getPost[index].uid!,
                              user.getPost[index].likes);
                        },
                        icon: user.getPost[index].likes
                                .contains(user.getPost[index].uid)
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                              )),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Commentscreen(
                                    postId: user.getPost[index].postId!,
                                  )));
                        },
                        icon: Icon(
                          Icons.comment_outlined,
                        )),
                    IconButton(
                        onPressed: () async {
                          if (user.getPost[index].imgPostUrl!.isNotEmpty ||
                              user.getPost[index].pdfPostUrl!.isNotEmpty) {
                            http.Response response = await http.get(Uri.parse(
                                user.getPost[index].imgPostUrl!.isNotEmpty
                                    ? user.getPost[index].imgPostUrl!
                                    : user.getPost[index].pdfPostUrl!));
                            Directory dir = await getTemporaryDirectory();
                            File imgFile = File('${dir.path}/imgfile.png');
                            File pdfFile = File('${dir.path}/pdffile.pdf');
                            user.getPost[index].imgPostUrl!.isNotEmpty
                                ? await imgFile.writeAsBytes(response.bodyBytes)
                                : await pdfFile
                                    .writeAsBytes(response.bodyBytes);
                            user.getPost[index].imgPostUrl!.isNotEmpty
                                ? await Share.shareXFiles([XFile(imgFile.path)])
                                : await Share.shareXFiles(
                                    [XFile(pdfFile.path)]);
                          }
                        },
                        icon: Icon(
                          Icons.send,
                        )),
                    SizedBox(
                      width: 215,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bookmark,
                        )),
                  ],
                ),
                //Description
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.getPost[index].likes.length} Likes',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 8),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: widget.snap['uid'],
                                    // user.getPost[index].username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                WidgetSpan(
                                    // alignment: PlaceholderAlignment.baseline,
                                    // baseline: TextBaseline.alphabetic,
                                    child: SizedBox(width: 10)),
                                TextSpan(
                                    text: user.getPost[index].description,
                                    style: TextStyle(fontSize: 14)),
                              ]),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'view comments',
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          user.getPost[index].datePublished,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ),
                      Divider(
                        color: Colors.amber,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
*/