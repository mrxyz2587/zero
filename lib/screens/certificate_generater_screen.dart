import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class Certificateviewingscreen extends StatefulWidget {
  final String name;
  Certificateviewingscreen({Key? key, required this.name}) : super(key: key);

  @override
  State<Certificateviewingscreen> createState() =>
      _CertificateviewingscreenState();
}

class _CertificateviewingscreenState extends State<Certificateviewingscreen> {
  final pdf = pw.Document();
  @override
  void initState() {
    pdfCreation();
    super.initState();
  }

  pdfCreation() async {
    final image = await pw.MemoryImage(
      (await rootBundle.load('images/certificate_generator.png'))
          .buffer
          .asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(fit: pw.StackFit.expand, children: [
            pw.Center(
              child: pw.Image(image,
                  fit: pw.BoxFit.cover, height: 842, width: 1191),
            ),
            pw.Center(
              child: pw.Column(children: [
                pw.Text(
                    "This Certificate Is Proudly Presented For\nHonorable Achievement To",
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 33,
                    ),
                    textAlign: pw.TextAlign.center),
                pw.Text(widget.name,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 33,
                    )),
                pw.Text(
                  "For Participating in THE GENESIS CEO CHALLENGE EVENT",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 33,
                  ),
                )
              ]),
            )
          ]);
        },
        pageFormat: PdfPageFormat.a3,
      ),
    );

    final file = File("resdume.pdf");
    file.writeAsBytesSync(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(build: (format) => pdf.save()),
    );
  }
}
