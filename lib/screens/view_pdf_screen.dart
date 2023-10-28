import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ViewPDFScreen extends StatefulWidget {
  String pdfUrl;
  String username;
  ViewPDFScreen({super.key, required this.pdfUrl, required this.username});

  @override
  State<ViewPDFScreen> createState() => _ViewPDFScreenState();
}

class _ViewPDFScreenState extends State<ViewPDFScreen> {
  late File pdfFile;
  bool isLoading = true;
  @override
  void initState() {
    loadPDF();
    super.initState();
  }

  loadPDF() async {
    http.Response response = await http.get(Uri.parse(widget.pdfUrl));
    Directory dir = await getTemporaryDirectory();
    File pdf = File('${dir.path}/pdffile.pdf');
    pdfFile = await pdf.writeAsBytes(response.bodyBytes);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: isLoading
            ? Center(
                child: Text('loading...'),
              )
            : PDFView(
                filePath: pdfFile.path,
              ),
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
