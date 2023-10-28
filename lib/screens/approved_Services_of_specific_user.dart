import 'package:flutter/material.dart';
import 'package:rosa/resources/firestore_methods.dart';

class ApprovedServicesOfSpecificUserScreen extends StatefulWidget {
  const ApprovedServicesOfSpecificUserScreen({super.key});

  @override
  State<ApprovedServicesOfSpecificUserScreen> createState() =>
      _ApprovedServicesOfSpecificUserScreenState();
}

class _ApprovedServicesOfSpecificUserScreenState
    extends State<ApprovedServicesOfSpecificUserScreen> {
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
              SizedBox(
                height: 30,
              ),
              Container(
                  child: const Text(
                'Confirmed Services',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              )),
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: FirestoreMethods().approvedBidsOfSpecificUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                              data[index]['bidderProfileImg']!.isNotEmpty
                                  ? CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          data[index]['bidderProfileImg']!))
                                  : SizedBox(),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                data[index]['bidderUserName']!,
                                // user.getPost[index].username!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 180,
                              ),
                              Text(
                                data[index]['bidPrice']!.toString(),
                                // user.getPost[index].username!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ]),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('something went wrong refresh again'),
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
              ),
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
          'ROSA',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
    );
  }
}
