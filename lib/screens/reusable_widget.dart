import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rosa/screens/add_post.dart';
import 'package:rosa/screens/menu.dart';
import 'package:rosa/screens/profile.dart';
import 'package:rosa/screens/search_screen.dart';
import 'package:rosa/screens/published_post.dart';

TextFormField reusableTextField(
  String text,
  String text2,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller,
  validator,
  //validator FormFieldValidator,
) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: isPasswordType,
    enableSuggestions: isPasswordType,
    autocorrect: isPasswordType,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      labelText: text,
      hintText: text2,
      labelStyle: const TextStyle(color: Colors.black),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container resusableContainer(Widget childname) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
        boxShadow: const [BoxShadow(blurRadius: 11, color: Colors.grey)],
        borderRadius: BorderRadius.circular(30),
        color: Colors.amber,
        border: Border.all(color: const Color(0xFFFFFFFF), width: 1)),
    child: childname,
  );
}

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print('No Image is selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

List<Widget> homeScreenItems = [
  menu(),
  SearchScreen(),
  AddPostScreen(),
  CurrentUserPosts(),
  ProfilePage(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}

class MessagePost extends StatelessWidget {
  final String message;
  final String user;
  const MessagePost({super.key, required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
