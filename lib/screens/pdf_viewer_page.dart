import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;
  const PdfViewerPage({Key? key, required this.url}) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          'Notice',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 5,
          ),
          child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Icon(
          //     FontAwesomeIcons.magnifyingGlass,
          //     color: Colors.black87,
          //     size: 20,
          //   ),
          // )
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SfPdfViewer.network(widget.url.toString(),
              enableDocumentLinkAnnotation: false)),
    );
  }
}
