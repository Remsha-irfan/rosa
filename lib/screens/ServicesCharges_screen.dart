import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rosa/providers/user_provider.dart';
import 'package:rosa/resources/contact_controller.dart';
import 'package:rosa/resources/firestore_methods.dart';
import 'package:rosa/screens/searched_User.dart';
import 'package:rosa/Model/user.dart' as model;
import 'package:rosa/screens/view_pdf_screen.dart';

class ServicesChargesScreen extends StatefulWidget {
  final snap;
  ServicesChargesScreen({super.key, required this.snap});

  @override
  State<ServicesChargesScreen> createState() => _ServicesChargesScreenState();
}

class _ServicesChargesScreenState extends State<ServicesChargesScreen> {
  final _priceController = TextEditingController();
  int price = 0;

  Future ShowPricePopUp() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
                height: 130,
                child: Column(
                  children: [
                    Text('Your Budget'),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(hintText: 'Budget'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          UserProvider userProvider =
                              Provider.of(context, listen: false);
                          price = int.parse(_priceController.text);

                          if (price <= widget.snap['initialServicesPrice']) {
                            print('object');
                            await FirestoreMethods().addBid(
                                widget.snap['postId'],
                                FirebaseAuth.instance.currentUser!.uid,
                                userProvider.getUser.photoUrl,
                                userProvider.getUser.username,
                                price);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Your Price is Higher then Initial Price')));
                          }
                          Navigator.pop(context);
                        },
                        child: Text('Add'))
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //UserProvider userProvider = Provider.of(context, listen: false);
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                  color: Colors.white,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                                  .copyWith(right: 0),
                          child: Row(children: [
                            widget.snap['profImage']!.isNotEmpty
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(widget.snap['profImage']!))
                                : SizedBox(),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              widget.snap['username']!,
                              // user.getPost[index].username!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        //image and PDF section
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                            child: widget.snap['imgPostUrl'].isNotEmpty
                                ? Image.network(widget.snap['imgPostUrl'],
                                    fit: BoxFit.cover)
                                : widget.snap['pdfPostUrl'].isNotEmpty
                                    ? Center(
                                        child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewPDFScreen(
                                                            pdfUrl: widget.snap[
                                                                'pdfPostUrl'],
                                                            username: widget
                                                                    .snap[
                                                                'username']!,
                                                          )));
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.filePdf,
                                              size: 50,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ))
                                    : SizedBox(
                                        /* child: Text(
                          user.getPost[index].description,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),*/
                                        )),
                        //Like, Comment Section
                        SizedBox(
                          height: 25,
                        ),
                        //Description
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 370,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text: widget.snap['username'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            WidgetSpan(
                                                // alignment: PlaceholderAlignment.baseline,
                                                // baseline: TextBaseline.alphabetic,
                                                child: SizedBox(width: 06)),
                                            TextSpan(
                                                text:
                                                    widget.snap['description'],
                                                style: TextStyle(fontSize: 16)),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text('Services Price :',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: 05,
                                        ),
                                        Text(
                                            widget.snap['initialServicesPrice']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    // Text('Contact On :',
                                    //     style: TextStyle(
                                    //         fontSize: 20,
                                    //         fontWeight: FontWeight.bold)),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceEvenly,
                                    //   children: [
                                    //     IconButton(
                                    //         onPressed: () async {
                                    //           await ContactController()
                                    //               .makeCall(
                                    //             userProvider
                                    //                 .getUser.phonenumber,
                                    //           );
                                    //         },
                                    //         icon: Icon(
                                    //           Icons.call,
                                    //           color: Colors.amber,
                                    //         )),
                                    //     IconButton(
                                    //         onPressed: () async {
                                    //           // await ContactController()
                                    //           //     .doSMS(widget.searchedUser['phonenumber']);
                                    //         },
                                    //         icon: Icon(
                                    //           Icons.message,
                                    //           color: Colors.amber,
                                    //         )),
                                    //     IconButton(
                                    //         onPressed: () async {
                                    //           await ContactController()
                                    //               .sendMail(userProvider
                                    //                   .getUser.email);
                                    //         },
                                    //         icon: Icon(
                                    //           Icons.email,
                                    //           color: Colors.amber,
                                    //         )),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.amber,
                              ),
                              Container(
                                color: Colors.amber,
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'See All',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      GestureDetector(
                                          onTap: () async {
                                            await ShowPricePopUp();
                                          },
                                          child: Text(
                                            'Enter Your Price',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              StreamBuilder(
                                stream: FirestoreMethods()
                                    .getAllBids(widget.snap['postId']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Text('Loading...'),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    if (snapshot.hasData) {
                                      final data = snapshot.data!.docs.toList();
                                      return ListView.builder(
                                        itemCount: data.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                    vertical: 4, horizontal: 16)
                                                .copyWith(right: 0),
                                            child: Row(children: [
                                              data[index]['bidderProfileImg']!
                                                      .isNotEmpty
                                                  ? CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage:
                                                          NetworkImage(data[
                                                                  index][
                                                              'bidderProfileImg']!))
                                                  : SizedBox(),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    data[index]
                                                        ['bidderUserName']!,
                                                    // user.getPost[index].username!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                  ),
                                                  Text(
                                                    data[index]['bidPrice']!
                                                        .toString(),
                                                    // user.getPost[index].username!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            ]),
                                          );
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                            'something went wrong refresh again'),
                                      );
                                    } else {
                                      return Text('data');
                                    }
                                  } else {
                                    return Center(
                                      child: Text('Loading...'),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ]),
          ),
        )),
      ),
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
