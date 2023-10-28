import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rosa/Model/user.dart' as model;
import 'package:rosa/Model/post.dart' as postModel;
import 'package:rosa/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();

  //Getting User details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('user').doc(currentUser.uid).get();

    // print(snap['username'].toString() + 'lllllllkkkkdd');
    return model.User.fromSnap(snap);
  }

  //gettting posts details
  Future<List<postModel.Post>> grtPostDetails() async {
    User currentUser = _auth.currentUser!;
    QuerySnapshot<Map<String, dynamic>> snap =
        await _firestore.collection('posts').get();
    final doc = snap.docs;
    print(doc.length);
    return doc.map((e) => postModel.Post.fromSnap(e)).toList();
  }

  //gettingCurrentUserPosts
  Future<List<postModel.Post>> grtCurrentUserPostDetails() async {
    User currentUser = _auth.currentUser!;
    var snap = await _firestore
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

    QuerySnapshot<Map<String, dynamic>> records = await snap.get();

    final doc = records.docs;

    print(doc.length);
    return doc.map((e) => postModel.Post.fromSnap(e)).toList();
  }

  //SignUp User
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String field,
    required String phonenumber,
    required Uint8List? file,
  }) async {
    String res = 'Some error occurred';

    try {
      String photoUrl;
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          phonenumber.isNotEmpty &&
          field.isNotEmpty) {
        if (file != null) {
          photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
        } else {
          photoUrl = '';
        }
        //Register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);

        //Add User to the database
        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          field: field,
          phonenumber: phonenumber,
          photoUrl: photoUrl,
          following: [],
          followers: [],
        );

        await _firestore
            .collection('user')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//sign in with google
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //SignOut
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
