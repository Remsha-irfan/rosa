import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class commentcard extends StatefulWidget {
  final snap;
  commentcard({super.key, required this.snap});
  @override
  State<commentcard> createState() => _commentcardState();
}

class _commentcardState extends State<commentcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundImage: NetworkImage(widget.snap['profilePic']),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    // for username
                    TextSpan(
                        text: widget.snap['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                            fontSize: 16)),
                    WidgetSpan(child: SizedBox(width: 05)),
                    //for comment
                    TextSpan(
                        text: widget.snap['text'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        )),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
