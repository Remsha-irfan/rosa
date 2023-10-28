import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final String field;
  final String phonenumber;
  //final String? password;
  final List? following;
  final List? followers;

  const User({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.field,
    required this.phonenumber,
    //this.password,
    this.following,
    this.followers,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "photoUrl": photoUrl,
        "field": field,
        "phonenumber": phonenumber,
        // "password": password,
        "followers": followers,
        "following": following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot['uid'],
      username: snapshot['username'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'] != null ? snapshot['photoUrl'] : '',
      field: snapshot['field'],
      phonenumber: snapshot['phonenumber'],
      //password: snapshot['password'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
