import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Post {
  String? pdfPostUrl;
  String? description;
  String? uid;
  String? username;
  String? postId;
  final datePublished;
  String? imgPostUrl;
  String? profImage;
  final likes;
  final views;
  int initialServicesPrice;
  String status;

  Post(
      {this.uid,
      this.username,
      this.pdfPostUrl,
      this.description,
      this.postId,
      this.datePublished,
      this.imgPostUrl,
      this.profImage,
      this.likes,
      this.views,
      required this.status,
      required this.initialServicesPrice});

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'pdfPostUrl': pdfPostUrl,
        'username': username,
        'postId': postId,
        'datePublished':
            DateFormat('dd MMMM yyyy hh:mm a').format(DateTime.now()),
        'profImage': profImage,
        'likes': likes,
        'views': views,
        'initialServicesPrice': initialServicesPrice,
        'status': status,
        'imgPostUrl': imgPostUrl,
      };

  static Post fromSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      pdfPostUrl: snapshot['pdfPostUrl'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      views: snapshot['views'],
      initialServicesPrice: snapshot['initialServicesPrice'],
      status: snapshot['status'],
      imgPostUrl: snapshot['imgPostUrl'],
    );
  }
}
