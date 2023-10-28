import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosa/providers/user_provider.dart';
import 'package:rosa/resources/auth_methods.dart';
import 'package:rosa/screens/forget_password.dart';
import 'package:rosa/screens/reusable_widget.dart';
import 'package:rosa/screens/signup.dart';
import '../responsive/mobile_Screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _c1 = TextEditingController();
  final TextEditingController _c2 = TextEditingController();
  bool _isLoading = false;
  bool _GoogleisLoading = false;
  bool _signupisLoading = false;
  @override
  void dispose() {
    super.dispose();
    _c1.dispose();
    _c2.dispose();
  }

  String? res;
  Future loginUser() async {
    setState(() {
      _isLoading = true;
    });
    res = await AuthMethods().loginUser(email: _c1.text, password: _c2.text);
    if (res == 'success') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const mobileScreenLayout()),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(res.toString()),
            );
          });
    }
    setState(() {
      _isLoading = false;
      _GoogleisLoading = false;
      _signupisLoading = false;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 150,
              ),
              // show text
              Container(
                  child: const Text(
                'ROSA',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 60,
                    fontWeight: FontWeight.w700),
              )),
              const SizedBox(
                height: 30,
              ),
              //show text
              Container(
                  child: const Text(
                'Research-Oriented Social App',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )),
              const SizedBox(
                height: 50,
              ),
              //Text field input for email
              resusableContainer(reusableTextField(
                "Enter Email",
                "Email",
                Icons.email,
                false,
                _c1,
                (value) {
                  bool isValid = EmailValidator.validate(value!);
                  if (!isValid) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              )),
              const SizedBox(
                height: 20,
              ),

              //text field input for password
              resusableContainer(reusableTextField(
                "Enter Password",
                "Password",
                Icons.lock,
                true,
                _c2,
                (value) => value!.length < 6
                    ? 'Enter Valid password 6+ characters'
                    : null,
              )),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ForgetPassword()),
                    );
                  },
                  child: const Text("Forget Password?   ",
                      style: TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    await loginUser();
                    if (res == 'success') {
                      UserProvider userProvider =
                          Provider.of(context, listen: false);
                      await userProvider.refreshUser();
                      await userProvider.refreshSpecificUserPost();
                    }
                  },
                  /*{
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _c1.text, password: _c2.text)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => menu(),
                          ));
                      print("Login successfully");
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  },*/
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      fixedSize: const Size(150, 50),
                      side: const BorderSide(color: Colors.black, width: 1),
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
                            fontSize: 20,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Divider(//color: Colors.amber
                  ),
              Container(
                  child: Row(
                children: [
                  Text(
                    "Signup with Google!",
                    style: TextStyle(
                      color: Color.fromARGB(238, 8, 8, 8),
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        setState(() {
                          _GoogleisLoading = true;
                        });
                        await AuthMethods().signInWithGoogle();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const mobileScreenLayout()),
                        );
                      },
                      child: _GoogleisLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.google,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 05,
                                ),
                                Text(
                                  "google",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            )),
                ],
              )),
              Divider(),
              Container(
                  child: Row(
                children: [
                  Text(
                    "New to ROSA?",
                    style: TextStyle(
                      color: Color.fromARGB(238, 8, 8, 8),
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        setState(() {
                          _signupisLoading = true;
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: _signupisLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.login,
                                  size: 30,
                                  color: Colors.amber,
                                ),
                                SizedBox(
                                  width: 05,
                                ),
                                Text(
                                  "Join now",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            )),
                ],
              )),
            ],
          ),
        ),
      )),
    );
  }
}
