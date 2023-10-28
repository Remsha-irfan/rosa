import 'package:flutter/material.dart';
import 'package:rosa/Model/post.dart';

import '../Model/user.dart';
import '../resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  List<Post> _post = [];
  List<Post> _currentUserPosts = [];
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;
  List<Post> get getPost => _post;
  List<Post> get getCurrentUSerPost => _currentUserPosts;
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    print(user.username + user.phonenumber + user.field);
    notifyListeners();
  }

  Future<void> refreshPost() async {
    List<Post> post = await _authMethods.grtPostDetails();
    _post = post;
    notifyListeners();
  }

  //Currentuser posts
  Future<void> refreshSpecificUserPost() async {
    List<Post> post = await _authMethods.grtCurrentUserPostDetails();
    _currentUserPosts = post;
    notifyListeners();
  }
}
