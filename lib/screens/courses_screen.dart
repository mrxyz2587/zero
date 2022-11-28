import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/screens/Mentorship.dart';
import 'package:zero_fin/screens/allcourses.dart';
import 'package:zero_fin/screens/examCrackers.dart';
import 'package:zero_fin/screens/inernship_screen.dart';

import '../models/events_model.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/event_item.dart';
import 'HomeScreen.dart';
import 'notice_screen.dart';

class Course_screen extends StatefulWidget {
  const Course_screen({Key? key}) : super(key: key);

  @override
  State<Course_screen> createState() => _Course_screenState();
}

class _Course_screenState extends State<Course_screen> {
  var name;
  File? file;
  Uint8List? _file;
  bool isSubmitted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEFEFEF),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: Icon(FontAwesomeIcons.graduationCap, color: Colors.black),
          title: Text(
            'Courses',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.solidBell,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoticeScreen()));
              },
            ),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.solidPaperPlane,
                size: 18,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()));
              },
            ),
          ],
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 40, top: 30, bottom: 20, left: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  backgroundColor: Color(0xFF262626),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                onPressed: () async {
                  String url = "https://app.resumebuilder.com/create-resume/";
                  if (await canLaunch(url)) {
                    await launch(url,
                        enableDomStorage: true,
                        enableJavaScript: true,
                        forceWebView: true);
                  }

                  // FilePickerResult? result = await FilePicker.platform
                  //     .pickFiles(
                  //         allowMultiple: false,
                  //         allowCompression: true,
                  //         type: FileType.custom,
                  //         allowedExtensions: ["pdf"]);
                  //
                  // if (result != null) {
                  //   File c = File(result.files.single.path.toString());
                  //
                  //   setState(() {
                  //     file = c;
                  //     name = result.names.toString();
                  //   });
                  //   String res = await FireStoreMethods().UploadResume(file!);
                  // }
                },
                child: Text('Build Resume',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                // color: Color(0xFF262626),
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(50)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: GridView(
                physics: ClampingScrollPhysics(),
                controller: ScrollController(keepScrollOffset: true),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExamCrackers()));
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Image.asset(
                                'images/exam.jpeg',
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              'Exam Crackers',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Comfortaa'),
                            ),
                          )
                        ],
                      ),
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CertificationCOurses()));
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Image.asset(
                                'images/certification.jpeg',
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              'Certification',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Comfortaa'),
                            ),
                          )
                        ],
                      ),
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InternshipScreen()));
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Image.asset(
                                'images/internship.jpeg',
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              'Internship',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Comfortaa'),
                            ),
                          )
                        ],
                      ),
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MentorshipCourses()));
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Image.asset(
                                'images/mentores.jpeg',
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              'Mentorship',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Comfortaa',
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 0.8,
                ),
                shrinkWrap: true,
              ),
            ),
          ],
        )

        // ListView(
        //   children: [
        //     // Padding(
        //     //   padding: const EdgeInsets.symmetric(
        //     //       horizontal: 40, vertical: 20),
        //     //   child: RaisedButton(
        //     //     onPressed: () async {
        //     //       FilePickerResult? result = await FilePicker.platform
        //     //           .pickFiles(
        //     //               allowMultiple: false,
        //     //               allowCompression: true,
        //     //               type: FileType.custom,
        //     //               allowedExtensions: ["pdf"]);
        //     //       if (result != null) {
        //     //         File c = File(result.files.single.path.toString());
        //     //
        //     //         setState(() {
        //     //           file = c;
        //     //           name = result.names.toString();
        //     //         });
        //     //         String res =
        //     //             await FireStoreMethods().UploadResume(file!);
        //     //       }
        //     //       // if (result != null) {
        //     //       //   Uint8List? fileBytes = result.files.first.bytes;
        //     //       //   String fileName = result.files.first.name;
        //     //       //   setState(() {
        //     //       //     _file = fileBytes;
        //     //       //
        //     //       //     isLoading = true;
        //     //       //   });
        //     //       //   // Upload file
        //     //       //   try {
        //     //       //     String res =
        //     //       //         await FireStoreMethods().UploadResume(_file!);
        //     //       //     if (res == "success") {
        //     //       //       setState(() {
        //     //       //         isLoading = false;
        //     //       //       });
        //     //       //       showSnackBar(
        //     //       //         context,
        //     //       //         'Posted!',
        //     //       //       );
        //     //       //     } else {
        //     //       //       showSnackBar(context, res);
        //     //       //     }
        //     //       //   } catch (err) {
        //     //       //     setState(() {
        //     //       //       isLoading = false;
        //     //       //     });
        //     //       //     showSnackBar(
        //     //       //       context,
        //     //       //       err.toString(),
        //     //       //     );
        //     //       //   }
        //     //       // }
        //     //
        //     //       // FilePickerResult? result =
        //     //       //     await FilePicker.platform.pickFiles(
        //     //       //   type: FileType.custom,
        //     //       //   allowedExtensions: ["pdf"],
        //     //       //   allowCompression: true,
        //     //       // );
        //     //       //
        //     //       // if (result != null) {
        //     //       //   PlatformFile? file = result.files.first;
        //     //       // } else {
        //     //       //   // User canceled the picker
        //     //       // }
        //     //     },
        //     //     child: isSubmitted
        //     //         ? Text('Uploaded',
        //     //             style: TextStyle(color: Colors.white))
        //     //         : Text('upload Resume',
        //     //             style: TextStyle(color: Colors.white)),
        //     //     color: Colors.black,
        //     //     shape: RoundedRectangleBorder(
        //     //         borderRadius: BorderRadius.circular(10)),
        //     //   ),
        //     // ),
        //     StreamBuilder(
        //       stream: FirebaseFirestore.instance
        //           .collection('events')
        //           .snapshots(),
        //       builder: (context,
        //           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
        //               snapshot) {
        //         if (snapshot.connectionState ==
        //             ConnectionState.waiting) {
        //           return const Center(
        //             child: CircularProgressIndicator(),
        //           );
        //         }
        //         return ListView.builder(
        //           shrinkWrap: true,
        //           controller: ScrollController(keepScrollOffset: true),
        //           scrollDirection: Axis.vertical,
        //           itemCount: snapshot.data!.docs.length,
        //           itemBuilder: (ctx, index) => Container(
        //             child: EventItem(
        //               snap: snapshot.data!.docs[index].data(),
        //               onpressed: () {
        //                 showModalBottomSheet(
        //                   enableDrag: true,
        //                   isDismissible: true,
        //                   isScrollControlled: true,
        //                   backgroundColor:
        //                       Colors.black.withOpacity(0.2),
        //                   context: context,
        //                   builder: (BuildContext c) {
        //                     return Padding(
        //                       padding: const EdgeInsets.only(top: 80),
        //                       child: Container(
        //                         color: Colors.black.withOpacity(0.1),
        //                         child: Container(
        //                           decoration: BoxDecoration(
        //                               color: Colors.white,
        //                               borderRadius: BorderRadius.only(
        //                                   topRight: Radius.circular(20),
        //                                   topLeft:
        //                                       Radius.circular(20))),
        //                           height: MediaQuery.of(context)
        //                               .size
        //                               .height,
        //                           width:
        //                               MediaQuery.of(context).size.width,
        //                           padding: EdgeInsets.symmetric(
        //                             horizontal: 15.w,
        //                             vertical: 10.h,
        //                           ),
        //                           child: Column(
        //                             children: <Widget>[
        //                               SizedBox(height: 15),
        //                               Container(
        //                                 height: 5,
        //                                 width: 50,
        //                                 decoration: BoxDecoration(
        //                                   borderRadius:
        //                                       BorderRadius.circular(5),
        //                                   color: btnCOlorblue,
        //                                 ),
        //                               ),
        //                               SizedBox(height: 20),
        //                               Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 children: [
        //                                   CircleAvatar(
        //                                     radius: 20,
        //                                     backgroundImage:
        //                                         NetworkImage(
        //                                       snapshot.data!.docs[index]
        //                                           .data()["imageUrl"]
        //                                           .toString(),
        //                                     ),
        //                                   ),
        //                                   SizedBox(
        //                                     width: 10,
        //                                   ),
        //                                   Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment
        //                                             .start,
        //                                     children: [
        //                                       Text(
        //                                         snapshot
        //                                             .data!.docs[index]
        //                                             .data()["evetitle"]
        //                                             .toString(),
        //                                         style: TextStyle(
        //                                           fontSize: 22.sp,
        //                                           fontWeight:
        //                                               FontWeight.bold,
        //                                         ),
        //                                       ),
        //                                       Text(
        //                                         snapshot.data!
        //                                                 .docs[index]
        //                                                 .data()[
        //                                                     "courseType"]
        //                                                 .toString() +
        //                                             ' ⏒ ' +
        //                                             snapshot.data!
        //                                                 .docs[index]
        //                                                 .data()[
        //                                                     "courseTiming"]
        //                                                 .toString(),
        //                                         textAlign:
        //                                             TextAlign.start,
        //                                         style: TextStyle(
        //                                             fontSize: 11.sp,
        //                                             color:
        //                                                 Colors.black45),
        //                                       )
        //                                     ],
        //                                   ),
        //                                 ],
        //                               ),
        //                               SizedBox(
        //                                 height: 20,
        //                               ),
        //                               Text(
        //                                 snapshot.data!.docs[index]
        //                                     .data()["evedescc"]
        //                                     .toString(),
        //                                 textAlign: TextAlign.justify,
        //                                 style: TextStyle(
        //                                   fontSize: 15.sp,
        //                                 ),
        //                               ),
        //                               Expanded(child: SizedBox()),
        //                               Align(
        //                                 alignment:
        //                                     Alignment.bottomCenter,
        //                                 child: RaisedButton(
        //                                     onPressed: () async {
        //                                       final url = snapshot
        //                                           .data!.docs[index]
        //                                           .data()["url"]
        //                                           .toString();
        //                                       if (await canLaunch(
        //                                           url)) {
        //                                         await launch(url);
        //                                       }
        //                                     },
        //                                     color: btnCOlorblue,
        //                                     child: Text(
        //                                       'Know more',
        //                                       style: TextStyle(
        //                                           fontSize: 16.sp,
        //                                           color: Colors.white),
        //                                     )),
        //                               )
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                 );
        //               },
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //   ],
        // )

        );
  }
}
