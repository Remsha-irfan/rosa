import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rosa/resources/firestore_methods.dart';
import 'package:rosa/screens/price_offered.dart';

class ImageView extends StatefulWidget {
  String ImageUrl;
  String caption;
  String username;
  String postId;
  bool personal;
  ImageView(
      {super.key,
      required this.ImageUrl,
      required this.caption,
      required this.username,
      required this.postId,
      required this.personal});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                child: Image.network(
                  widget.ImageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                width: 370,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: widget.username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        WidgetSpan(
                            // alignment: PlaceholderAlignment.baseline,
                            // baseline: TextBaseline.alphabetic,
                            child: SizedBox(width: 10)),
                        TextSpan(
                            text: widget.caption,
                            style: TextStyle(fontSize: 18)),
                      ]),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              widget.personal
                  ? ElevatedButton(
                      onPressed: () {
                        FirestoreMethods()
                            .getAllBidsOfSpecificPost(widget.postId);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  PriceOffered_screen(postId: widget.postId)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          fixedSize: const Size(220, 50),
                          side: const BorderSide(color: Colors.black, width: 1),
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      child: Row(
                        children: [
                          SizedBox(width: 05),
                          FaIcon(
                            FontAwesomeIcons.servicestack,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Price Offered",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ))
                  : SizedBox()
            ],
          ),
        )),
      ),
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
        title: Text(
          widget.username,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// //import 'package:scholar_link/Screens/message_page.dart';

// class FriendsPage extends StatefulWidget {
//   const FriendsPage({Key? key}) : super(key: key);

//   @override
//   _FriendsPageState createState() => _FriendsPageState();
// }

// class _FriendsPageState extends State<FriendsPage> {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   final userCollection = FirebaseFirestore.instance.collection('User');

//   List<String> friendsList = [];
//   List<String> requestsList = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchFriendsData();
//     fetchRequestsData();
//   }

//   Future<void> fetchFriendsData() async {
//     final friendsData = await userCollection
//         .doc(currentUser!.email)
//         .collection('Friends')
//         .get();

//     setState(() {
//       friendsList = friendsData.docs
//           .map((doc) => doc.data()['username'] as String)
//           .toList();
//     });
//   }

//   Future<void> fetchRequestsData() async {
//     final currentUserEmail = currentUser!.email;
//     final friendRequestsRef =
//         userCollection.doc(currentUserEmail).collection('FriendRequests');

//     final friendRequestsSnapshot = await friendRequestsRef.get();

//     setState(() {
//       requestsList = friendRequestsSnapshot.docs
//           .map((doc) => doc.data()['sender'] as String)
//           .where((sender) =>
//               sender !=
//               currentUserEmail) // Exclude requests sent by the current user
//           .toList();
//     });
//   }

//   void sendFriendRequest(String friendName) {
//     final currentUserEmail = currentUser!.email;
//     final friendRequestData = {
//       'sender': currentUserEmail,
//       // Add any other relevant friend request data here
//     };

//     userCollection
//         .where('username', isEqualTo: friendName)
//         .get()
//         .then((querySnapshot) {
//       if (querySnapshot.docs.isNotEmpty) {
//         final recipientDoc = querySnapshot.docs.first;
//         final recipientEmail = recipientDoc.id;

//         userCollection
//             .doc(recipientEmail)
//             .collection('FriendRequests')
//             .doc(currentUserEmail)
//             .set(friendRequestData)
//             .then((_) {
//           setState(() {
//             requestsList.add(friendName);
//           });
//           // Friend request sent successfully
//         }).catchError((error) {
//           // Error occurred while sending friend request
//         });
//       } else {
//         // Friend not found with the provided username
//         // Handle this case accordingly
//       }
//     }).catchError((error) {
//       // Error occurred while querying for the recipient
//     });
//   }

//   void acceptFriendRequest(String friendName) async {
//     final currentUserDocRef = userCollection.doc(currentUser!.email);
//     final friendRequestsRef = currentUserDocRef.collection('FriendRequests');
//     final friendsRef = currentUserDocRef.collection('Friends');

//     final friendRequestQuerySnapshot = await friendRequestsRef
//         .where('sender', isEqualTo: friendName)
//         .limit(1)
//         .get();

//     final friendRequestDoc = friendRequestQuerySnapshot.docs.first;

//     final friendEmail = friendRequestDoc.data()['sender'];

//     await FirebaseFirestore.instance.runTransaction((transaction) async {
//       // Delete the friend request document
//       transaction.delete(friendRequestDoc.reference);

//       // Add the friend to the current user's friends collection
//       final friendData = {
//         'username': friendName,
//         // Add any other relevant friend data here
//       };
//       final friendDocRef = friendsRef.doc(friendEmail);
//       transaction.set(friendDocRef, friendData);

//       // Add the current user to the accepted friend's friends collection
//       final currentUserData = {
//         'username': currentUser!.email,
//         // Add any other relevant friend data here
//       };
//       final currentUserDocRef = userCollection.doc(currentUser!.email);
//       final currentUserFriendDocRef =
//           currentUserDocRef.collection('Friends').doc(currentUser!.email);
//       transaction.set(currentUserFriendDocRef, currentUserData);
//     }).then((_) {
//       setState(() {
//         requestsList.remove(friendName);
//         friendsList.add(friendName);
//       });
//       // Friend request accepted successfully
//     }).catchError((error) {
//       // Error occurred while accepting friend request
//     });
//   }

//   void rejectFriendRequest(String friendName) async {
//     final currentUserDocRef = userCollection.doc(currentUser!.email);
//     final friendRequestsRef = currentUserDocRef.collection('FriendRequests');

//     final friendRequestQuerySnapshot = await friendRequestsRef
//         .where('sender', isEqualTo: friendName)
//         .limit(1)
//         .get();

//     final friendRequestDoc = friendRequestQuerySnapshot.docs.first;

//     await friendRequestDoc.reference.delete().then((_) {
//       setState(() {
//         requestsList.remove(friendName);
//       });
//       // Friend request rejected successfully
//     }).catchError((error) {
//       // Error occurred while rejecting friend request
//     });
//   }

//   void goToMessagePage(String friendName) {
//     /* Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MessagePage(friendName: friendName),
//       ),
//     );*/
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         backgroundColor: Colors.amber,
//         centerTitle: true,
//         title: Text("Friends"),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search for friends...',
//               ),
//               onChanged: (value) {
//                 // Perform search operations based on entered value
//                 // Update friendsList with search results
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: friendsList.length,
//               itemBuilder: (context, index) {
//                 final friendName = friendsList[index];
//                 return ListTile(
//                   title: Row(
//                     children: [
//                       Icon(Icons.person, color: Colors.amber, size: 35),
//                       SizedBox(width: 8), // Add space between the icon and text
//                       Expanded(
//                         child: Text(
//                           friendName,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                       SizedBox(
//                           width:
//                               8), // Add space between the text and message icon
//                       Icon(Icons.message, color: Colors.amber, size: 35),
//                     ],
//                   ),
//                   onTap: () {
//                     // Perform specific actions when a friend's name is tapped
//                     goToMessagePage(friendName);
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Friend Requests',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           StreamBuilder<QuerySnapshot>(
//             stream: userCollection
//                 .doc(currentUser!.email)
//                 .collection('FriendRequests')
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Text('Error retrieving friend requests');
//               }

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               }

//               final friendRequestsSnapshot = snapshot.data!;
//               if (friendRequestsSnapshot.size == 0) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Text('No friend requests.'),
//                 );
//               }

//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: friendRequestsSnapshot.docs.length,
//                 itemBuilder: (context, index) {
//                   final friendRequest = friendRequestsSnapshot.docs[index];
//                   final data = friendRequest.data() as Map<String, dynamic>;
//                   final sender = data['sender'] as String?;
//                   if (sender == null || sender == currentUser!.email) {
//                     // Skip the friend request sent by the current user or if sender is null
//                     return Container();
//                   }
//                   return ListTile(
//                     title: Text(sender),
//                     onTap: () {
//                       // Perform specific actions when a friend request is tapped
//                       CircularProgressIndicator();
//                     },
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.check),
//                           onPressed: () {
//                             acceptFriendRequest(sender);
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close),
//                           onPressed: () {
//                             rejectFriendRequest(sender);
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//           ElevatedButton(
//             style: ButtonStyle(
//                 backgroundColor:
//                     MaterialStateProperty.all<Color>(Colors.amber)),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   String newFriendName = '';
//                   return AlertDialog(
//                     title: Text('Add Friend'),
//                     content: TextField(
//                       onChanged: (value) {
//                         newFriendName = value;
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'Enter friend name',
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(color: Colors.amber),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (newFriendName.isNotEmpty) {
//                             sendFriendRequest(newFriendName);
//                           }
//                           Navigator.pop(context);
//                         },
//                         child: Text('Add'),
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStateProperty.all<Color>(Colors.amber)),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//             child: Text('Add Friend'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /*import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:provider/provider.dart';

// import '../providers/user_provider.dart';

// class imagescreen extends StatefulWidget {
//   Uint8List file;
//   imagescreen({super.key, required this.file});

//   @override
//   State<imagescreen> createState() => _imagescreenState();
// }

// class _imagescreenState extends State<imagescreen> {
//   @override
//   void initState() {
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     UserProvider user = Provider.of(context, listen: false);
//     return Scaffold(
//         body: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: Image.network(
//                                   user.getPost.im,
//                                   fit: BoxFit.cover)));
//   }
// }*/



// // show full screen
// /* Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: PDFView(pdfData: widget.file))*/


// //pdf view
//             /*import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
// import 'package:flutter/material.dart';

// class pdfviewerScreen extends StatefulWidget {
//   final String pdfUrl;
//   const pdfviewerScreen({super.key, required this.pdfUrl});

//   @override
//   State<pdfviewerScreen> createState() => _pdfviewerScreenState();
// }

// class _pdfviewerScreenState extends State<pdfviewerScreen> {
//   PDFDocument? document;

//   void initialisePdf() async {
//     document = await PDFDocument.fromURL(widget.pdfUrl);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     initialisePdf();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: document != null
//             ? PDFViewer(
//                 document: document!,
//               )
//             : Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.black,
//                 ),
//               ));
//   }
// }*/



// //upload pdf
// /*import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:rosa/screens/pdf_viewer.dart';
// import 'package:share_plus/share_plus.dart';

// class Uploadpdfscreen extends StatefulWidget {
//   const Uploadpdfscreen({super.key});

//   @override
//   State<Uploadpdfscreen> createState() => _UploadpdfscreenState();
// }

// class _UploadpdfscreenState extends State<Uploadpdfscreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> pdfData = [];

//   Future<String> uploadpdf(String fileName, File file) async {
//     final ref = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
//     final UploadTask = ref.putFile(file);
//     await UploadTask.whenComplete(() {});
//     final downloadlink = await ref.getDownloadURL();
//     return downloadlink;
//   }

//   void pickFile() async {
//     final pickedFile = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//     if (pickedFile != null) {
//       String fileName = pickedFile.files[0].name;
//       File file = File(pickedFile.files[0].path!);
//       final downloadlink = await uploadpdf(fileName, file);
//       await _firestore.collection("pdfs").add({
//         "name": fileName,
//         "url": downloadlink,
//       });
//       print("Pdf uploaded sucessfully");
//     }
//   }

//   void getAllpdf() async {
//     final results = await _firestore.collection("pdfs").get();
//     pdfData = results.docs.map((e) => e.data()).toList();
//     setState(() {});
//   }

//   void sharepdf() async {
//     final results = await _firestore.collection("pdfs").get();
//     pdfData = results.docs.map((e) => e.data()).toList();
//     await Share.shareFiles(pdfData[0]['url']);

//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     getAllpdf();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GridView.builder(
//           itemCount: pdfData.length,
//           gridDelegate:
//               SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//           itemBuilder: (context, index) {
//             return Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               pdfviewerScreen(pdfUrl: pdfData[index]['url']),
//                         ));
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Text(
//                           pdfData[index]['name'],
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         IconButton(
//                           onPressed: sharepdf,
//                           icon: const Icon(
//                             Icons.send,
//                             size: 20,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ));
//           }),
//       floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.upload_file), onPressed: pickFile),
//     );
//   }
// }
// */

// //button
// /*import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   Function()? function;
//   Color? backgroundColor;
//   Color borderColor;
//   String? text;
//   Color? textColor;

//   CustomButton({
//     Key? key,
//     this.function,
//     this.backgroundColor,
//     required this.borderColor,
//     this.text,
//     this.textColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 2.0),
//       child: TextButton(
//         onPressed: function,
//         child: Container(
//           decoration: BoxDecoration(
//               color: backgroundColor,
//               border: Border.all(
//                 color: borderColor,
//               )),
//           alignment: Alignment.center,
//           width: 100,
//           height: 27,
//           child: Text(
//             text!,
//             style: TextStyle(
//               color: textColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }*/
