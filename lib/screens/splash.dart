import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosa/screens/login.dart';
import 'package:rosa/screens/signup.dart';

import '../providers/user_provider.dart';

//import 'package:researcher/screens/login.dart';
//import 'package:researcher/screens/signup.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    //   Timer(Duration(microseconds: 1), () {
    //     if (FirebaseAuth.instance.currentUser != null) {
    //       // addData();
    //       Navigator.of(context).push(
    //           MaterialPageRoute(builder: (context) => mobileScreenLayout()));
    //     }
    //   }
    //   );

    //super.initState();
    //addData();
  }

  // addData() async {
  //   UserProvider userProvider = Provider.of(context, listen: false);
  //   await userProvider.refreshUser();
  // }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 180,
            ),
            Container(
                child: const Text(
              'ROSA',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 80,
              ),
            )),
            const SizedBox(
              height: 30,
            ),
            Container(
                child: const Text(
              'Research-Oriented Social App',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            )),
            Container(
                height: 200,
                width: 500,
                margin: const EdgeInsets.fromLTRB(50, 100, 50, 0.0),
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    border: Border.all(color: Colors.amber, width: 3)),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 25, 10, 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            fixedSize: const Size(150, 50),
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(00, 35, 00, 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Signup()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            fixedSize: const Size(150, 50),
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        child: const Text(
                          "Signup",
                          style: TextStyle(
                            color: Color.fromARGB(238, 8, 8, 8),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ]),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
