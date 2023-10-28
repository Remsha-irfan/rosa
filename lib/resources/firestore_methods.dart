import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rosa/Model/post.dart';
import 'package:rosa/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Upload Post
  Future<String> uploadPost(
      String description,
      Map<String, dynamic>? file,
      String uid,
      String username,
      String profImage,
      int initialServicesPrice) async {
    String res = 'some error occurred';
    String imgPostUrl;
    try {
      if (file != null) {
        print('inside upload image');
        imgPostUrl = await StorageMethods()
            .uploadImageToStorage('posts', file['data'], true);
      } else {
        imgPostUrl = '';
      }

      //Using uuid to get unique id
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: // DateTime.now(),
              DateFormat('dd MMMM yyyy hh:mm a').format(DateTime.now()),
          imgPostUrl: file != null && file['key'] == 'img' ? imgPostUrl : '',
          pdfPostUrl: file != null && file['key'] == 'pdf' ? imgPostUrl : '',
          profImage: profImage,
          likes: [],
          views: [],
          initialServicesPrice: initialServicesPrice,
          status: 'pending');
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future addBid(
      postId, bidderId, bidderProfileImg, bidderUserName, bidPrice) async {
    String serviceId = DateFormat('ddMMyyyyHHmmss').format(DateTime.now());
    await _firestore.collection('services').doc(serviceId).set({
      "postId": postId,
      "bidderId": bidderId,
      "bidderProfileImg": bidderProfileImg,
      "bidderUserName": bidderUserName,
      "bidPrice": bidPrice,
      "status": "pending",
      "serviceId": serviceId
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllBidsOfSpecificPost(postId) {
    var doc =
        _firestore.collection('services').where('postId', isEqualTo: postId);
    var snapshot = doc.snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allBidsOFSpecificUser() {
    var doc = _firestore
        .collection('services')
        .where('bidderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    var snapshot = doc.snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> approvedBidsOfSpecificUser() {
    var doc = _firestore
        .collection('services')
        .where('bidderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: 'Working..');

    var snapshot = doc.snapshots();
    return snapshot;
  }

  Future sellPostToSpecificUSer(serviceId, postId) async {
    await _firestore
        .collection('services')
        .doc(serviceId)
        .update({'status': 'Working..'});
    await _firestore
        .collection('posts')
        .doc(serviceId)
        .update({'status': 'Working..'});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllBids(postId) {
    var doc =
        _firestore.collection('services').where('postId', isEqualTo: postId);
    var snapshot = doc.snapshots();
    return snapshot;
  }

  Future<void> viewPost(String postId, String uid, List views) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'views': FieldValue.arrayUnion([uid]),
      });
      print('updated');
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  //Deleting a post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> PostComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'name': name,
          'profilePic': profilePic,
          'datePublished': DateTime.now()
        });
      } else {
        print("Text is empty");
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('user').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
