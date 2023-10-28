import 'package:flutter/material.dart';
import 'package:rosa/resources/firestore_methods.dart';

class PriceOffered_screen extends StatefulWidget {
  String postId;
  PriceOffered_screen({super.key, required this.postId});

  @override
  State<PriceOffered_screen> createState() => _PriceOffered_screenState();
}

class _PriceOffered_screenState extends State<PriceOffered_screen> {
  bool isSold = false;
  dynamic soldTo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream:
                    FirestoreMethods().getAllBidsOfSpecificPost(widget.postId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text('loading...'),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!.docs.toList();
                      for (int i = 0; i < data.length; i++) {
                        if (data[i]['status'] == 'Working..') {
                          isSold = true;
                          soldTo = data[i];
                          break;
                        }
                      }
                      return isSold
                          ? Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16)
                                  .copyWith(right: 0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(children: [
                                    soldTo['bidderProfileImg']!.isNotEmpty
                                        ? CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                soldTo['bidderProfileImg']!))
                                        : SizedBox(),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      soldTo['bidderUserName']!,
                                      // user.getPost[index].username!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 100,
                                    ),
                                    Text(
                                      soldTo['bidPrice'].toString(),
                                      // user.getPost[index].username!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('Accepted')],
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 16)
                                      .copyWith(right: 0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(children: [
                                        data[index]['bidderProfileImg']!
                                                .isNotEmpty
                                            ? CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    data[index]
                                                        ['bidderProfileImg']!))
                                            : SizedBox(),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          data[index]['bidderUserName']!,
                                          // user.getPost[index].username!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 180,
                                        ),
                                        Text(
                                          data[index]['bidPrice']!.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await FirestoreMethods()
                                                      .sellPostToSpecificUSer(
                                                          data[index]
                                                              ['serviceId'],
                                                          data[index]
                                                              ['postId']!);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.amber,
                                                    fixedSize:
                                                        const Size(100, 30),
                                                    side: const BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                    shape: const BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)))),
                                                child: Text('Accept'))
                                          ])
                                    ],
                                  ),
                                );
                              },
                            );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Something went wrong'),
                      );
                    } else {
                      return Center(
                        child: Text('data'),
                      );
                    }
                  } else {
                    return Center(
                      child: Text('loading...'),
                    );
                  }
                },
              )
            ],
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
          'Price Offered',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
    );
  }
}
