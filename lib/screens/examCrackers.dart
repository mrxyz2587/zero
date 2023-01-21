import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/widgets/course_item.dart';

import '../models/events_model.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/event_item.dart';

class ExamCrackers extends StatefulWidget {
  const ExamCrackers({Key? key}) : super(key: key);

  @override
  State<ExamCrackers> createState() => _ExamCrackersState();
}

class _ExamCrackersState extends State<ExamCrackers>
    with TickerProviderStateMixin {
  var name;
  File? file;
  Uint8List? _file;
  bool isSubmitted = false;

  final _razorpay = Razorpay();
  String selectedText = " ";
  @override
  void initState() {
    // TODO: implement initState
    getdata();

    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  String courseId = "";
  String currentusermaol = "";

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) {
    String? paymentId = response.paymentId;

    print("payment Success");
    FirebaseFirestore.instance
        .collection('coursesection')
        .doc('examcrackers')
        .collection('allexams')
        .doc(courseId)
        .update({
      'paymentId': FieldValue.arrayUnion([paymentId]),
      'registeredemails': FieldValue.arrayUnion([currentusermaol.toString()])
    });
    print(courseId + "edetailing" + currentusermaol);
    setState(() {});
  }

  void getdata() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      currentusermaol = value.data()!["email"].toString();
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("paymentfailed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    bool isReg = false;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    TabController tabController = TabController(length: 2, vsync: this);

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Builder(builder: (BuildContext context) {
            return Scaffold(
                backgroundColor: Color(0xFFEFEFEF),
                appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: Icon(FontAwesomeIcons.graduationCap,
                        color: Colors.black),
                    title: Text(
                      'Exam Crackers',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                body: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        indicatorColor: Colors.black,
                        controller: tabController,
                        unselectedLabelColor: Colors.grey,
                        labelColor: Colors.black,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(text: 'Explore'),
                          Tab(
                            text: 'Registered',
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(controller: tabController, children: [
                        ListView(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  useRootNavigator: false,
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SimpleDialogOption(
                                                child: Text("all Courses"),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedText = " ";
                                                  });
                                                  Navigator.pop(context);
                                                }),
                                            SimpleDialogOption(
                                                child: Text("Gate"),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedText = "gate";
                                                  });
                                                  Navigator.pop(context);
                                                }),
                                            SimpleDialogOption(
                                                child: Text("UPSC"),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedText = "upsc";
                                                  });
                                                  Navigator.pop(context);
                                                }),
                                            SimpleDialogOption(
                                                child: Text("Banking"),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedText = "banking";
                                                  });
                                                  Navigator.pop(context);
                                                }),
                                            SimpleDialogOption(
                                                child: Text("CAT"),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedText = "cat";
                                                  });
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: Text(
                                  "Filter",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: btnCOlorblue),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),

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
                                      .doc('examcrackers')
                                      .collection('allexams')
                                      .snapshots()
                                  : FirebaseFirestore.instance
                                      .collection('coursesection')
                                      .doc('examcrackers')
                                      .collection('allexams')
                                      .where("type",
                                          isEqualTo: selectedText.toString())
                                      .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
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
                                    child: CourseItem(
                                      isReg: isReg,
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(20),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20))),
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(height: 8),
                                                    Container(
                                                      height: 5,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    SizedBox(height: 17),
                                                    Container(
                                                      height: 140,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Image.network(
                                                        snapshot
                                                            .data!.docs[index]
                                                            .data()[
                                                                "companyimage"]
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
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 20,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              snapshot.data!
                                                                  .docs[index]
                                                                  .data()[
                                                                      "companyimage"]
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            snapshot.data!
                                                                .docs[index]
                                                                .data()[
                                                                    "certificationname"]
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  SizedBox()),
                                                          GestureDetector(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        16.0),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              5)),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color:
                                                                            Color(
                                                                          0xFF6F6F6F,
                                                                        ),
                                                                      )),
                                                              child:
                                                                  Image.asset(
                                                                'images/share_icons.png',
                                                                height: 19,
                                                              ),
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
                                                        snapshot
                                                            .data!.docs[index]
                                                            .data()[
                                                                "certificationdescription"]
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        String url = snapshot
                                                            .data!.docs[index]
                                                            .data()["url"]
                                                            .toString();
                                                        if (await canLaunch(
                                                            url)) {
                                                          await launch(url,
                                                              forceWebView:
                                                                  true,
                                                              enableDomStorage:
                                                                  true,
                                                              enableJavaScript:
                                                                  true);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0),
                                                        child: Text(
                                                          snapshot
                                                              .data!.docs[index]
                                                              .data()["url"]
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0xFF14487C)),
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      50),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              7)),
                                                                  border: Border
                                                                      .all(
                                                                    color:
                                                                        Color(
                                                                      0xFF585858,
                                                                    ),
                                                                  )),
                                                          child: Text(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                    .data()[
                                                                        "certificationlevel"]
                                                                    .toString() +
                                                                " | " +
                                                                snapshot.data!
                                                                    .docs[index]
                                                                    .data()[
                                                                        "coursetiming"]
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            final url = snapshot
                                                                .data!
                                                                .docs[index]
                                                                .data()[
                                                                    "seemoreurl"]
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
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        20),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFFFD86D),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              7)),
                                                            ),
                                                            child: Text(
                                                              "View More >>",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: !(snapshot.data!
                                                                          .docs[index]
                                                                          .data()[
                                                                      "registeredemails"]
                                                                  as List)
                                                              .contains(
                                                                  currentusermaol)
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          15.0),
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            btnCOlorblue,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(7))),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        var options =
                                                                            {
                                                                          'key':
                                                                              'rzp_test_cLikbNvwBHO1tH',
                                                                          'amount': (snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()["price"]
                                                                              .toString()),
                                                                          'name': snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()["price"]
                                                                              .toString()
                                                                              .substring(0, 5),
                                                                          'description':
                                                                              " lund lund lund lund lund ldunv",
                                                                        };
                                                                        _razorpay
                                                                            .open(options);

                                                                        courseId = snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()["id"]
                                                                            .toString();
                                                                      },
                                                                      // color: btnCOlorblue,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                50,
                                                                            vertical:
                                                                                8),
                                                                        child:
                                                                            Text(
                                                                          'Register',
                                                                          style: TextStyle(
                                                                              fontSize: 16.sp,
                                                                              color: Colors.white),
                                                                        ),
                                                                      )),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          15.0),
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            btnCOlorblue,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(7))),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        final url = snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()["url"]
                                                                            .toString();
                                                                        if (await canLaunch(
                                                                            url)) {
                                                                          await launch(
                                                                              url,
                                                                              enableJavaScript: true,
                                                                              forceWebView: true);
                                                                        }
                                                                      },
                                                                      // color: btnCOlorblue,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                50,
                                                                            vertical:
                                                                                8),
                                                                        child:
                                                                            Text(
                                                                          'Join',
                                                                          style: TextStyle(
                                                                              fontSize: 16.sp,
                                                                              color: Colors.white),
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
                        ),
                        ListView(
                          children: [
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
                              stream: FirebaseFirestore.instance
                                  .collection('coursesection')
                                  .doc('examcrackers')
                                  .collection('allexams')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
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
                                  itemBuilder:
                                      (ctx, index) =>
                                          (snapshot.data!.docs[index].data()[
                                                          "registeredemails"]
                                                      as List)
                                                  .contains(currentusermaol)
                                              ? Container(
                                                  child: CourseItem(
                                                    isReg: isReg,
                                                    snap: snapshot
                                                        .data!.docs[index]
                                                        .data(),
                                                    onpressed: () {
                                                      showModalBottomSheet(
                                                        enableDrag: true,
                                                        isDismissible: true,
                                                        backgroundColor: Colors
                                                            .black
                                                            .withOpacity(0),
                                                        context: context,
                                                        builder:
                                                            (BuildContext c) {
                                                          return Container(
                                                            color: Colors
                                                                .transparent,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20))),
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                      height:
                                                                          8),
                                                                  Container(
                                                                    height: 5,
                                                                    width: 45,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          17),
                                                                  Container(
                                                                    height: 140,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child: Image
                                                                        .network(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()[
                                                                              "companyimage"]
                                                                          .toString(),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          15),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        CircleAvatar(
                                                                          radius:
                                                                              20,
                                                                          backgroundImage:
                                                                              NetworkImage(
                                                                            snapshot.data!.docs[index].data()["companyimage"].toString(),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()["certificationname"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18.sp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                SizedBox()),
                                                                        GestureDetector(
                                                                            child:
                                                                                Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: 16.0),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.all(10),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                border: Border.all(
                                                                                  color: Color(
                                                                                    0xFF6F6F6F,
                                                                                  ),
                                                                                )),
                                                                            child:
                                                                                Image.asset(
                                                                              'images/share_icons.png',
                                                                              height: 19,
                                                                            ),
                                                                          ),
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          15.0,
                                                                    ),
                                                                    child: Text(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()[
                                                                              "certificationdescription"]
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      maxLines:
                                                                          4,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          SizedBox()),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10,
                                                                        horizontal:
                                                                            50),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(7)),
                                                                            border: Border.all(
                                                                              color: Color(
                                                                                0xFF585858,
                                                                              ),
                                                                            )),
                                                                    child: Text(
                                                                      snapshot.data!.docs[index]
                                                                              .data()[
                                                                                  "certificationlevel"]
                                                                              .toString() +
                                                                          " ⌚ " +
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()["coursetiming"]
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          SizedBox()),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              15.0),
                                                                      child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                btnCOlorblue,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                                                                          ),
                                                                          onPressed: () async {
                                                                            final url =
                                                                                snapshot.data!.docs[index].data()["url"].toString();
                                                                            if (await canLaunch(url)) {
                                                                              await launch(url, enableJavaScript: true, forceWebView: true);
                                                                            }
                                                                          },
                                                                          // color: btnCOlorblue,
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                                                                            child:
                                                                                Text(
                                                                              'Join',
                                                                              style: TextStyle(fontSize: 16.sp, color: Colors.white),
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
                                                )
                                              : Container(),
                                );
                              },
                            ),
                          ],
                        ),
                      ]),
                    )
                  ],
                ));
          });
        });
  }
}
