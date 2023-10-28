import 'dart:typed_data';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rosa/providers/user_provider.dart';
import 'package:rosa/resources/auth_methods.dart';
import 'package:rosa/screens/reusable_widget.dart';

import '../responsive/mobile_Screen.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  //const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _c1 = TextEditingController();
  final TextEditingController _c2 = TextEditingController();
  final TextEditingController _c3 = TextEditingController();
  final TextEditingController _c4 = TextEditingController();
  final TextEditingController _c5 = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();
    _c5.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  Future signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      username: _c1.text,
      email: _c2.text,
      password: _c3.text,
      field: _c4.text,
      phonenumber: _c5.text,
      file: _image,
    );
    if (res != 'success') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => mobileScreenLayout()),
      );
      await addData();

      {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(res),
              );
            });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      child: const Text(
                    'ROSA',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 60,
                        fontWeight: FontWeight.w700),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: const Text(
                    'Research-Oriented Social App',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),

                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!))
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    'https://www.vectorstock.com/royalty-free-vector/default-avatar-profile-icon-vector-18942370'),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Text field input for username
                  resusableContainer(reusableTextField(
                    "Enter username",
                    "Username",
                    Icons.person_outline,
                    false,
                    _c1,
                    (value) => value!.isEmpty ? 'Enter Valid name' : null,
                  )),

                  const SizedBox(
                    height: 18,
                  ),

                  resusableContainer(reusableTextField(
                    "Enter email",
                    "Email",
                    Icons.email,
                    false,
                    _c2,
                    (value) {
                      bool isValid = EmailValidator.validate(value!);
                      if (!isValid) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(
                    height: 18,
                  ),
                  //text field input for password
                  resusableContainer(reusableTextField(
                    "Enter Password",
                    "Password",
                    Icons.lock,
                    true,
                    _c3,
                    (value) => value!.length < 6
                        ? 'Enter Valid password 6+ characters'
                        : null,
                  )),

                  const SizedBox(
                    height: 18,
                  ),
                  //text field input for field
                  resusableContainer(reusableTextField(
                    "Enter Field",
                    "Field",
                    Icons.work,
                    false,
                    _c4,
                    (value) => value!.isEmpty ? 'Enter Valid Field' : null,
                  )),

                  const SizedBox(
                    height: 18,
                  ),
                  //text field input for phone number
                  resusableContainer(reusableTextField(
                    "Enter Phone Number",
                    "phone Number",
                    Icons.phone,
                    false,
                    _c5,
                    (value) =>
                        value!.length != 11 ? 'Enter Valid Phone number' : null,
                  )),
                  // TextFormField(
                  //   controller: _c5,
                  //   validator: (value) =>
                  //       value!.length != 11 ? 'Enter Valid Phone number' : null,
                  //   obscureText: false,
                  //   enableSuggestions: true,
                  //   autocorrect: true,
                  //   style: const TextStyle(color: Colors.black),
                  //   decoration: InputDecoration(
                  //     // prefixIcon: Icon(prefixicon, color: Colors.black),
                  //     prefixIcon: Icon(
                  //       Icons.person_outline,
                  //       color: Colors.black,
                  //     ),
                  //     labelText: 'Enter Phone',
                  //     hintText: 'Phone Number',
                  //     labelStyle: const TextStyle(color: Colors.black),
                  //     filled: true,
                  //     floatingLabelBehavior: FloatingLabelBehavior.never,
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(30.0),
                  //         borderSide: BorderSide.none),
                  //   ),
                  //   keyboardType: TextInputType.emailAddress,
                  // ),

                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await signUpUser();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enter Velid details')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          fixedSize: const Size(150, 50),
                          side: const BorderSide(color: Colors.black, width: 1),
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              "Signup",
                              style: TextStyle(
                                color: Color.fromARGB(238, 8, 8, 8),
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
          'ROSA',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
    );
  }
}
