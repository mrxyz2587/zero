import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zero_fin/screens/pdf_viewer_page.dart';

import '../utils/colors.dart';

class ShowAllNoticeByUniverSity extends StatefulWidget {
  const ShowAllNoticeByUniverSity({Key? key}) : super(key: key);

  @override
  State<ShowAllNoticeByUniverSity> createState() =>
      _ShowAllNoticeByUniverSityState();
}

class _ShowAllNoticeByUniverSityState extends State<ShowAllNoticeByUniverSity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: Icon(FontAwesomeIcons.solidBell, color: Colors.black),
          title: Text(
            'University Notices',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('notices').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.grey.shade300,
                  strokeWidth: 1.5,
                ));
              }
              return ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(keepScrollOffset: true),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) => Container(
                  child: GestureDetector(
                    onTap: () {
                      final url = snapshot.data!.docs[index]
                          .data()["noticeDoc"]
                          .toString();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PdfViewerPage(url: url)));
                    },
                    child: Container(
                      height: 90,
                      child: Card(
                        margin: const EdgeInsets.only(
                            bottom: 10.0, right: 18.0, left: 18),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Image.asset('images/Quantumlogo.png')),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        snapshot.data!.docs[index]
                                            .data()["universityname"],
                                        style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto')),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                        snapshot.data!.docs[index]
                                            .data()["noticename"],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                            fontFamily: 'Roboto')),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 13),
                              child: Row(
                                children: [
                                  IconButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: btnCOlorblue,
                                        minimumSize: Size(50, 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7))),
                                    onPressed: () {}, //TODO 2. button action
                                    icon: Icon(
                                      FontAwesomeIcons.streetView,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
