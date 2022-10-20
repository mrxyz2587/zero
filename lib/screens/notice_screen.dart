import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zero_fin/screens/pdf_viewer_page.dart';
import '../utils/colors.dart';
import '../widgets/event_item.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  bool isLoasdings = true;

  void getData() async {
    await FirebaseFirestore.instance
        .collection("collection")
        .get()
        .then((value) => {
              setState(() {
                isLoasdings = false;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Builder(builder: (BuildContext context) {
            return Scaffold(
                backgroundColor: Color(0xFFEFEFEF),
                appBar: AppBar(
                    elevation: 1,
                    backgroundColor: Colors.white,
                    leading:
                        Icon(FontAwesomeIcons.solidBell, color: Colors.black),
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                body: ListView(physics: BouncingScrollPhysics(), children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'UNIVERSITY NOTICES (3)',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto'),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('notices')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
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
                                  builder: (context) =>
                                      PdfViewerPage(url: url)));
                            },
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
                              child: Expanded(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Image.asset(
                                              'images/Quantumlogo.png')),
                                    ),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                        BorderRadius.circular(
                                                            7))),
                                            onPressed:
                                                () {}, //TODO 2. button action
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
                  // Card(
                  //   margin: const EdgeInsets.only(
                  //       bottom: 10.0, right: 18.0, left: 18),
                  //   elevation: 0,
                  //   shape: RoundedRectangleBorder(
                  //     side: BorderSide(
                  //       color: Theme.of(context).colorScheme.outline,
                  //     ),
                  //     borderRadius: const BorderRadius.all(Radius.circular(12)),
                  //   ),
                  //   child: Expanded(
                  //     child: Row(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 12),
                  //           child: Container(
                  //               height: 48,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(5)),
                  //               child: Image.asset('images/Quantumlogo.png')),
                  //         ),
                  //         SizedBox(
                  //           width: 1,
                  //         ),
                  //         Expanded(
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(12.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text('Quantum University',
                  //                     style: TextStyle(
                  //                         color: Color(0xFF000000),
                  //                         fontSize: 15,
                  //                         fontWeight: FontWeight.w700,
                  //                         fontFamily: 'Roboto')),
                  //                 SizedBox(
                  //                   height: 4,
                  //                 ),
                  //                 Text('Feshers Party',
                  //                     style: TextStyle(
                  //                         color: Colors.black54,
                  //                         fontSize: 13,
                  //                         fontFamily: 'Roboto')),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.only(right: 13),
                  //           child: Row(
                  //             children: [
                  //               IconButton(
                  //                 style: ElevatedButton.styleFrom(
                  //                     backgroundColor: btnCOlorblue,
                  //                     minimumSize: Size(50, 12),
                  //                     shape: RoundedRectangleBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(7))),
                  //                 onPressed: () {}, //TODO 2. button action
                  //                 icon: Icon(
                  //                   FontAwesomeIcons.streetView,
                  //                   size: 20,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Card(
                  //   margin: const EdgeInsets.only(
                  //       bottom: 10.0, right: 18.0, left: 18),
                  //   elevation: 0,
                  //   shape: RoundedRectangleBorder(
                  //     side: BorderSide(
                  //       color: Theme.of(context).colorScheme.outline,
                  //     ),
                  //     borderRadius: const BorderRadius.all(Radius.circular(12)),
                  //   ),
                  //   child: Expanded(
                  //     child: Row(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 12),
                  //           child: Container(
                  //               height: 48,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(5)),
                  //               child: Image.asset('images/Quantumlogo.png')),
                  //         ),
                  //         SizedBox(
                  //           width: 1,
                  //         ),
                  //         Expanded(
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(12.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text('Quantum University',
                  //                     style: TextStyle(
                  //                         color: Color(0xFF000000),
                  //                         fontSize: 15,
                  //                         fontWeight: FontWeight.w700,
                  //                         fontFamily: 'Roboto')),
                  //                 SizedBox(
                  //                   height: 4,
                  //                 ),
                  //                 Text('Feshers Party',
                  //                     style: TextStyle(
                  //                         color: Colors.black54,
                  //                         fontSize: 13,
                  //                         fontFamily: 'Roboto')),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.only(right: 13),
                  //           child: Row(
                  //             children: [
                  //               IconButton(
                  //                 style: ElevatedButton.styleFrom(
                  //                     backgroundColor: btnCOlorblue,
                  //                     minimumSize: Size(50, 12),
                  //                     shape: RoundedRectangleBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(7))),
                  //                 onPressed: () {}, //TODO 2. button action
                  //                 icon: Icon(
                  //                   FontAwesomeIcons.streetView,
                  //                   size: 20,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8.0, bottom: 18),
                  //   child: Center(
                  //       child: Text(
                  //     "Show more",
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w700, color: Colors.black54),
                  //   )),
                  // ),
                  // Container(
                  //   color: Colors.white,
                  //   height: 600,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(18.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text("ACTIVITY",
                  //             style: TextStyle(
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.w700,
                  //                 fontFamily: 'Roboto')),
                  //         Container(
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(
                  //                 top: 18.0, left: 15, right: 15),
                  //             child: Row(
                  //               children: [
                  //                 CircleAvatar(
                  //                   backgroundImage: NetworkImage(
                  //                       "https://images.unsplash.com/photo-1597466765990-64ad1c35dafc"),
                  //                   radius: 20,
                  //                 ),
                  //                 SizedBox(width: 20),
                  //                 Container(
                  //                   child: Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       Row(
                  //                         children: [
                  //                           Text('Rohit Raj ',
                  //                               style: TextStyle(
                  //                                   fontWeight:
                  //                                       FontWeight.w700)),
                  //                           Text('liked your post'),
                  //                         ],
                  //                       ),
                  //                       SizedBox(
                  //                         height: 3,
                  //                       ),
                  //                       Text('1hr ago',
                  //                           style: TextStyle(
                  //                               fontSize: 12,
                  //                               color: Colors.grey,
                  //                               fontStyle: FontStyle.italic))
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 SizedBox(width: 80),
                  //                 Icon(
                  //                   Icons.circle,
                  //                   color: btnCOlorblue,
                  //                   size: 10,
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         Container(
                  //           child: Padding(
                  //             padding:
                  //                 const EdgeInsets.only(top: 18.0, left: 15),
                  //             child: Row(
                  //               children: [
                  //                 CircleAvatar(
                  //                   backgroundImage: NetworkImage(
                  //                       "https://images.unsplash.com/photo-1597466765990-64ad1c35dafc"),
                  //                   radius: 20,
                  //                 ),
                  //                 SizedBox(width: 20),
                  //                 Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     Row(
                  //                       children: [
                  //                         Text('Rohit Raj ',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.w700)),
                  //                         Text('liked your post.'),
                  //                       ],
                  //                     ),
                  //                     SizedBox(
                  //                       height: 3,
                  //                     ),
                  //                     Text('1hr ago',
                  //                         style: TextStyle(
                  //                             fontSize: 12,
                  //                             color: Colors.grey,
                  //                             fontStyle: FontStyle.italic))
                  //                   ],
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ]));
          });
        });
  }
}
