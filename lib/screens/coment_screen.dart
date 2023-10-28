import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rosa/utils/widgets/comment_card.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';

class Commentscreen extends StatefulWidget {
  String postId;
  Commentscreen({
    super.key,
    required this.postId,
  });

  @override
  State<Commentscreen> createState() => _CommentscreenState();
}

class _CommentscreenState extends State<Commentscreen> {
  TextEditingController textc1 = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    textc1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of(context, listen: false);
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, Snapshot) {
            if (Snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: (Snapshot.data as dynamic).docs.length,
              itemBuilder: (context, index) => commentcard(
                  snap: (Snapshot.data as dynamic).docs[index].data()),
            );
          }),
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
          'Comments',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 15, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(user.getUser.photoUrl),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 16, right: 8.0),
              child: TextField(
                controller: textc1,
                decoration: InputDecoration(
                    hintText: 'Comment as ${user.getUser.username}',
                    border: InputBorder.none),
              ),
            )),
            TextButton(
                onPressed: () async {
                  await FirestoreMethods().PostComment(
                    widget.postId,
                    textc1.text,
                    user.getUser.uid,
                    user.getUser.username,
                    user.getUser.photoUrl,
                  );
                  setState(() {
                    textc1.text = "";
                  });
                },
                child: Text(
                  "Post",
                  style: TextStyle(color: Colors.amber, fontSize: 18),
                ))
          ],
        ),
      )),
    );
  }
}
