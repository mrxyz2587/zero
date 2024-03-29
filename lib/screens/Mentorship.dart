import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/widgets/course_item.dart';
import 'package:zero_fin/widgets/mentors_card.dart';

import '../models/events_model.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/event_item.dart';

class MentorshipCourses extends StatefulWidget {
  const MentorshipCourses({Key? key}) : super(key: key);

  @override
  State<MentorshipCourses> createState() => _MentorshipCoursesState();
}

class _MentorshipCoursesState extends State<MentorshipCourses> {
  var name;
  File? file;
  Uint8List? _file;
  bool isSubmitted = false;

  String selectedText = " ";
  String imageUrl = "";
  String quizUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  void getdata() async {
    try {
      await FirebaseFirestore.instance
          .collection('applyMentorCard')
          .doc('card')
          .get()
          .then((value) {
        imageUrl = value.data()!["imageUrl"].toString();
        print(imageUrl.toString());
        quizUrl = value.data()!["quizUrl"].toString();
      });
      setState(() {
        isSubmitted = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isReg = false;

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Builder(builder: (BuildContext context) {
            return isSubmitted
                ? Scaffold(
                    backgroundColor: Color(0xFFEFEFEF),
                    appBar: AppBar(
                      elevation: 1,
                      backgroundColor: Colors.white,
                      titleSpacing: 15,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Image.asset(
                          'images/mentorship_icon.png',
                        ),
                      ),
                      leadingWidth: 40,
                      title: Text(
                        'Mentors',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () async {
                              if (await canLaunch(
                                  'https://docs.google.com/forms/d/e/1FAIpQLSfyv_BMkvO99YazDGBX32VlSPoJEBTCSohAXYJKHH7W7oPmRg/viewform')) {
                                await launch(
                                  'https://docs.google.com/forms/d/e/1FAIpQLSfyv_BMkvO99YazDGBX32VlSPoJEBTCSohAXYJKHH7W7oPmRg/viewform',
                                );
                              }
                            },
                            icon: Icon(
                              FontAwesomeIcons.circlePlus,
                              color: webBackgroundColor,
                            ))
                      ],
                    ),
                    body: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: InkWell(
                            onTap: () async {
                              if (await canLaunch(
                                  'https://docs.google.com/forms/d/e/1FAIpQLSfyv_BMkvO99YazDGBX32VlSPoJEBTCSohAXYJKHH7W7oPmRg/viewform')) {
                                await launch(
                                  'https://docs.google.com/forms/d/e/1FAIpQLSfyv_BMkvO99YazDGBX32VlSPoJEBTCSohAXYJKHH7W7oPmRg/viewform',
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.20,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 3,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  child: Image(
                                    image: AssetImage('images/mentee.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 2),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 40, vertical: 20),
                        //   child: RaisedButton(
                        //     onPressed: () async {
                        //       FilePickerResult? result = await FilePicker.platform
                        //           .pickFiles(
                        //               allowMultiple: false,
                        //               allowCompression: true,
                        //               type: FileType.custom,
                        //               allowedExtensions: ["pdf"]);
                        //       if (result != null) {
                        //         File c = File(result.files.single.path.toString());
                        //
                        //         setState(() {
                        //           file = c;
                        //           name = result.names.toString();
                        //         });
                        //         String res =
                        //             await FireStoreMethods().UploadResume(file!);
                        //       }
                        //       // if (result != null) {
                        //       //   Uint8List? fileBytes = result.files.first.bytes;
                        //       //   String fileName = result.files.first.name;
                        //       //   setState(() {
                        //       //     _file = fileBytes;
                        //       //
                        //       //     isLoading = true;
                        //       //   });
                        //       //   // Upload file
                        //       //   try {
                        //       //     String res =
                        //       //         await FireStoreMethods().UploadResume(_file!);
                        //       //     if (res == "success") {
                        //       //       setState(() {
                        //       //         isLoading = false;
                        //       //       });
                        //       //       showSnackBar(
                        //       //         context,
                        //       //         'Posted!',
                        //       //       );
                        //       //     } else {
                        //       //       showSnackBar(context, res);
                        //       //     }
                        //       //   } catch (err) {
                        //       //     setState(() {
                        //       //       isLoading = false;
                        //       //     });
                        //       //     showSnackBar(
                        //       //       context,
                        //       //       err.toString(),
                        //       //     );
                        //       //   }
                        //       // }
                        //
                        //       // FilePickerResult? result =
                        //       //     await FilePicker.platform.pickFiles(
                        //       //   type: FileType.custom,
                        //       //   allowedExtensions: ["pdf"],
                        //       //   allowCompression: true,
                        //       // );
                        //       //
                        //       // if (result != null) {
                        //       //   PlatformFile? file = result.files.first;
                        //       // } else {
                        //       //   // User canceled the picker
                        //       // }
                        //     },
                        //     child: isSubmitted
                        //         ? Text('Uploaded',
                        //             style: TextStyle(color: Colors.white))
                        //         : Text('upload Resume',
                        //             style: TextStyle(color: Colors.white)),
                        //     color: Colors.black,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10)),
                        //   ),
                        // ),
                        StreamBuilder(
                          stream: (selectedText == " ")
                              ? FirebaseFirestore.instance
                                  .collection('coursesection')
                                  .doc('mentorship')
                                  .collection('allmentors')
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection('coursesection')
                                  .doc('certification')
                                  .collection('allCourses')
                                  .where("certificationlevel",
                                      isEqualTo: selectedText.toString())
                                  .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              controller:
                                  ScrollController(keepScrollOffset: true),
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (ctx, index) => Container(
                                child: MentorsCard(
                                  snap: snapshot.data!.docs[index].data(),
                                  onpressed: () {
                                    showModalBottomSheet(
                                      enableDrag: true,
                                      isDismissible: true,
                                      backgroundColor:
                                          Colors.black.withOpacity(0),
                                      context: context,
                                      builder: (BuildContext c) {
                                        return Container(
                                          color: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    topLeft:
                                                        Radius.circular(20))),
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(height: 8),
                                                Container(
                                                  height: 5,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 17),
                                                Container(
                                                  height: 140,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Image.network(
                                                    snapshot.data!.docs[index]
                                                        .data()[
                                                            "mentorcoverimg"]
                                                        .toString(),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 20,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          snapshot
                                                              .data!.docs[index]
                                                              .data()[
                                                                  "photomentorurl"]
                                                              .toString(),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        snapshot
                                                            .data!.docs[index]
                                                            .data()["name"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12.0,
                                                                horizontal: 8),
                                                        child: GestureDetector(
                                                            onTap: () {},
                                                            child: Icon(
                                                                FontAwesomeIcons
                                                                    .linkedin,
                                                                size: 20,
                                                                color: Colors
                                                                    .blue)),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      GestureDetector(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 16.0),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border
                                                                      .all(
                                                                    color:
                                                                        Color(
                                                                      0xFF6F6F6F,
                                                                    ),
                                                                  )),
                                                          child: Image.asset(
                                                              'images/share_icons.png'),
                                                        ),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15.0,
                                                  ),
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        .data()["description"]
                                                        .toString(),
                                                    textAlign: TextAlign.left,
                                                    maxLines: 4,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 50),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  7)),
                                                      border: Border.all(
                                                        color: Color(
                                                          0xFF585858,
                                                        ),
                                                      )),
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        .data()["category"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 15.0),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              btnCOlorblue,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          7))),
                                                        ),
                                                        onPressed: () async {
                                                          String url = snapshot
                                                              .data!.docs[index]
                                                              .data()[
                                                                  "applylink"]
                                                              .toString();
                                                          if (await canLaunch(
                                                              url)) {
                                                            await launch(url,
                                                                enableDomStorage:
                                                                    true,
                                                                enableJavaScript:
                                                                    true,
                                                                forceWebView:
                                                                    true);
                                                          }
                                                        },
                                                        // color: btnCOlorblue,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      50,
                                                                  vertical: 8),
                                                          child: Text(
                                                            'Apply',
                                                            style: TextStyle(
                                                                fontSize: 16.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ))
                : Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(
                        child: CircularProgressIndicator(
                      color: Colors.grey.shade300,
                      strokeWidth: 1.5,
                    )),
                  );
          });
        });
  }
}
