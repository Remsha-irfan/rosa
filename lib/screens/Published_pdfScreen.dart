import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rosa/resources/firestore_methods.dart';
import 'package:rosa/screens/price_offered.dart';
import 'package:rosa/screens/view_pdf_screen.dart';

class PublishedPdfView extends StatefulWidget {
  String pdfUrl;
  String caption;
  String username;
  String postId;
  bool personal;
  PublishedPdfView(
      {super.key,
      required this.pdfUrl,
      required this.caption,
      required this.username,
      required this.postId,
      required this.personal});

  @override
  State<PublishedPdfView> createState() => _PublishedPdfViewState();
}

class _PublishedPdfViewState extends State<PublishedPdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewPDFScreen(
                              pdfUrl: widget.pdfUrl,
                              username: widget.username,
                            )));
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.filePdf,
                    size: 50,
                    color: Colors.amber,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                width: 370,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: widget.username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        WidgetSpan(
                            // alignment: PlaceholderAlignment.baseline,
                            // baseline: TextBaseline.alphabetic,
                            child: SizedBox(width: 10)),
                        TextSpan(
                            text: widget.caption,
                            style: TextStyle(fontSize: 18)),
                      ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              widget.personal
                  ? ElevatedButton(
                      onPressed: () {
                        FirestoreMethods()
                            .getAllBidsOfSpecificPost(widget.postId);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  PriceOffered_screen(postId: widget.postId)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          fixedSize: const Size(220, 50),
                          side: const BorderSide(color: Colors.black, width: 1),
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      child: Row(
                        children: [
                          SizedBox(width: 05),
                          FaIcon(
                            FontAwesomeIcons.servicestack,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Price Offered",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ))
                  : SizedBox()
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
        title: Text(
          widget.username,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
    );
  }
}
