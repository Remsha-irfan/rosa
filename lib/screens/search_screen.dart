import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rosa/responsive/mobile_Screen.dart';
import 'package:rosa/screens/image.dart';
import 'package:rosa/screens/searched_User.dart';
import 'package:rosa/screens/view_pdf_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController search = TextEditingController();
  bool isShowUser = false;
  @override
  void dispose() {
    super.dispose();
    search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //UserProvider user = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const mobileScreenLayout()),
            );
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
            color: Colors.black,
          ),
        ),
        title: TextFormField(
          controller: search,
          enableSuggestions: true,
          decoration: InputDecoration(
            labelText: 'Search for a user',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .where('username', isGreaterThanOrEqualTo: search.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SerachedUser(
                                    searchedUser: (snapshot.data! as dynamic)
                                        .docs[index]))),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['photoUrl']!),
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']!),
                        ),
                      );
                    });
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    itemCount: snapshot.data!.docs.toList().length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 3),
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs.toList();
                      return data[index]['uid']! ==
                              FirebaseAuth.instance.currentUser!.uid
                          //  user.getPost[index].uid! ==
                          // FirebaseAuth.instance.currentUser!.uid
                          ? SizedBox()
                          : Container(
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
                                                      ['imgPostUrl']!,
                                                  caption: data[index]
                                                      ['description']!,
                                                  username: data[index]
                                                      ['username']!,
                                                  postId: data[index]
                                                      ['postId']!,
                                                  personal: false)),
                                        );
                                      },
                                      child: Image.network(
                                          data[index]['imgPostUrl']!,
                                          fit: BoxFit.cover),
                                    )
                                  : data[index]['pdfPostUrl']!.isNotEmpty
                                      ? Center(
                                          child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewPDFScreen(
                                                              pdfUrl: data[
                                                                      index][
                                                                  'pdfPostUrl']!,
                                                              username: data[
                                                                      index]
                                                                  ['username']!,
                                                            )));
                                              },
                                              icon: FaIcon(
                                                FontAwesomeIcons.filePdf,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ))
                                      : Container(
                                          height: 350,
                                          width: double.infinity,
                                          child: Center(
                                            child: Text(
                                              'No Posts',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 50),
                                            ),
                                          ),
                                        ),
                            );
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
    );
  }
}
/*return GridView.builder(
                  itemCount: user.getPost.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 3),
                  itemBuilder: (context, index) {
                    return user.getPost[index].uid! ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? SizedBox()
                        : Container(
                            height: 140,
                            width: 140,
                            color: Colors.black12,
                            child: user.getPost[index].imgPostUrl!.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ImageView(
                                                ImageUrl: user
                                                    .getPost[index].imgPostUrl!,
                                                caption: user.getPost[index]
                                                    .description!,
                                                username: user
                                                    .getPost[index].username!,
                                                postId:
                                                    user.getPost[index].postId!,
                                                personal: false)),
                                      );
                                    },
                                    child: Image.network(
                                        user.getPost[index].imgPostUrl!,
                                        fit: BoxFit.cover),
                                  )
                                : user.getPost[index].pdfPostUrl!.isNotEmpty
                                    ? Center(
                                        child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewPDFScreen(
                                                            pdfUrl: user
                                                                .getPost[index]
                                                                .pdfPostUrl!,
                                                            username: user
                                                                .getPost[index]
                                                                .username!,
                                                          )));
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.filePdf,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ))
                                    : Container(
                                        height: 350,
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            'No Posts',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 50),
                                          ),
                                        ),
                                      ),
                          );
                  },
                );*/