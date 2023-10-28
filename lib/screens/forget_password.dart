import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rosa/screens/reusable_widget.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _c1 = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _c1.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _c1.text);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset link sent! Check your email'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print('e');
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: const Text(
                  'ROSA',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 60,
                      fontWeight: FontWeight.w700),
                )),
            const SizedBox(
              height: 80,
            ),
            // show text
            Container(
                child: const Text(
              'Enter your Email and we send you a password reset link',
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
            SizedBox(
              height: 30,
            ),

            //button for reset password
            Container(
              child: ElevatedButton(
                onPressed: passwordReset,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    fixedSize: const Size(250, 50),
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
                        "Reset Password",
                        style: TextStyle(
                          color: Color.fromARGB(238, 8, 8, 8),
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ],
        ),
      )),
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
