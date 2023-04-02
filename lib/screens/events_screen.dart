import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/events_model.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/event_item.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'HomeScreen.dart';
import 'notice_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with TickerProviderStateMixin {
  var name;
  File? file;
  Uint8List? _file;
  bool isSubmitted = false;
  final _razorpay = Razorpay();
  bool isReg = false;
  String imageUrl = "";
  String quizUrl = "";

  final _currentUserUid = FirebaseAuth.instance.currentUser!.uid.toString();

  String currentusermaol = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  void getdata() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        currentusermaol = value.data()!["email"].toString();
      });
      await FirebaseFirestore.instance
          .collection('quiz')
          .doc('dailyquiz')
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
    TabController tabController = TabController(length: 2, vsync: this);

    return isSubmitted
        ? ScreenUtilInit(
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
                      leading: Icon(FontAwesomeIcons.fireFlameCurved,
                          color: Colors.black),
                      title: Text(
                        'Events',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.solidBell,
                            color: Colors.black,
                            size: 18,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoticeScreen()));
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.solidPaperPlane,
                            size: 18,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen()));
                          },
                        ),
                      ],
                    ),
                    body: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: InkWell(
                            onTap: () async {
                              if (await canLaunch(quizUrl)) {
                                await launch(quizUrl,
                                    enableDomStorage: true,
                                    enableJavaScript: true,
                                    forceWebView: true);
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
                                    image: NetworkImage(
                                      imageUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: TabBar(
                            physics: ClampingScrollPhysics(),
                            labelPadding: EdgeInsets.symmetric(vertical: 0),
                            padding: EdgeInsets.symmetric(vertical: 0),
                            indicatorColor: Colors.black,
                            controller: tabController,
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.black,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            tabs: [
                              Tab(text: 'Explore'),
                              Tab(
                                text: 'Pinned',
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Color(0xFFEFEFEF),
                            child: TabBarView(
                                physics: ClampingScrollPhysics(),
                                controller: tabController,
                                children: [
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('events')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        controller: ScrollController(
                                            keepScrollOffset: true),
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (ctx, index) => Container(
                                          child: EventItem(
                                            snap: snapshot.data!.docs[index]
                                                .data(),
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
                                                                      .circular(
                                                                          20),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20))),
                                                      child: Column(
                                                        children: <Widget>[
                                                          SizedBox(height: 8),
                                                          Container(
                                                            height: 5,
                                                            width: 45,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          SizedBox(height: 17),
                                                          Container(
                                                            height: 140,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child:
                                                                Image.network(
                                                              snapshot.data!
                                                                  .docs[index]
                                                                  .data()[
                                                                      "imageUrl"]
                                                                  .toString(),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
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
                                                                    snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()[
                                                                            "imageUrl"]
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .data()[
                                                                          "evetitle"]
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox()),
                                                                GestureDetector(
                                                                    child:
                                                                        Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          16.0),
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(5)),
                                                                            border: Border.all(
                                                                              color: Color(
                                                                                0xFF6F6F6F,
                                                                              ),
                                                                            )),
                                                                    child: Image
                                                                        .asset(
                                                                      'images/share_icons.png',
                                                                      height:
                                                                          19,
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
                                                              horizontal: 15.0,
                                                            ),
                                                            child: Text(
                                                              snapshot.data!
                                                                  .docs[index]
                                                                  .data()[
                                                                      "evedescc"]
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              maxLines: 4,
                                                              style: TextStyle(
                                                                fontSize: 15.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  SizedBox()),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        50),
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            7)),
                                                                    border:
                                                                        Border
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
                                                                      "eventDate"]
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
                                                          Expanded(
                                                              child:
                                                                  SizedBox()),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          15.0),
                                                              child: snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()[
                                                                              "type"]
                                                                          .toString() ==
                                                                      "paid"
                                                                  ? Padding(
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
                                                                              'Register',
                                                                              style: TextStyle(fontSize: 16.sp, color: Colors.white),
                                                                            ),
                                                                          )),
                                                                    )
                                                                  : Padding(
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
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('events')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        controller: ScrollController(
                                            keepScrollOffset: true),
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder:
                                            (ctx, index) =>
                                                (snapshot.data!.docs[index]
                                                                .data()["saves"]
                                                            as List)
                                                        .contains(
                                                            _currentUserUid)
                                                    ? EventItem(
                                                        snap: snapshot
                                                            .data!.docs[index]
                                                            .data(),
                                                        onpressed: () {
                                                          showModalBottomSheet(
                                                            enableDrag: true,
                                                            isDismissible: true,
                                                            backgroundColor:
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0),
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    c) {
                                                              return Container(
                                                                color: Colors
                                                                    .transparent,
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius: BorderRadius.only(
                                                                          topRight: Radius.circular(
                                                                              20),
                                                                          topLeft:
                                                                              Radius.circular(20))),
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      SizedBox(
                                                                          height:
                                                                              8),
                                                                      Container(
                                                                        height:
                                                                            5,
                                                                        width:
                                                                            45,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          color:
                                                                              Colors.black87,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              17),
                                                                      Container(
                                                                        height:
                                                                            140,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        child: Image
                                                                            .network(
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()["imageUrl"]
                                                                              .toString(),
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              15),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 15.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            CircleAvatar(
                                                                              radius: 20,
                                                                              backgroundImage: NetworkImage(
                                                                                snapshot.data!.docs[index].data()["imageUrl"].toString(),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              snapshot.data!.docs[index].data()["evetitle"].toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 18.sp,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Expanded(child: SizedBox()),
                                                                            GestureDetector(
                                                                                child: Padding(
                                                                              padding: const EdgeInsets.only(right: 16.0),
                                                                              child: Container(
                                                                                padding: EdgeInsets.all(10),
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                    border: Border.all(
                                                                                      color: Color(
                                                                                        0xFF6F6F6F,
                                                                                      ),
                                                                                    )),
                                                                                child: Image.asset(
                                                                                  'images/share_icons.png',
                                                                                  height: 19,
                                                                                ),
                                                                              ),
                                                                            )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              15.0,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()["evedescc"]
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.left,
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
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(7)),
                                                                            border: Border.all(
                                                                              color: Color(
                                                                                0xFF585858,
                                                                              ),
                                                                            )),
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()["eventDate"]
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              SizedBox()),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.bottomCenter,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(bottom: 15.0),
                                                                          child: snapshot.data!.docs[index].data()["type"].toString() == "paid"
                                                                              ? Padding(
                                                                                  padding: const EdgeInsets.only(bottom: 15.0),
                                                                                  child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: btnCOlorblue,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        final url = snapshot.data!.docs[index].data()["url"].toString();
                                                                                        if (await canLaunch(url)) {
                                                                                          await launch(url, enableJavaScript: true, forceWebView: true);
                                                                                        }
                                                                                      },
                                                                                      // color: btnCOlorblue,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                                                                                        child: Text(
                                                                                          'Register',
                                                                                          style: TextStyle(fontSize: 16.sp, color: Colors.white),
                                                                                        ),
                                                                                      )),
                                                                                )
                                                                              : Padding(
                                                                                  padding: const EdgeInsets.only(bottom: 15.0),
                                                                                  child: ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: btnCOlorblue,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        final url = snapshot.data!.docs[index].data()["url"].toString();
                                                                                        if (await canLaunch(url)) {
                                                                                          await launch(url, enableJavaScript: true, forceWebView: true);
                                                                                        }
                                                                                      },
                                                                                      // color: btnCOlorblue,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                                                                                        child: Text(
                                                                                          'Join',
                                                                                          style: TextStyle(fontSize: 16.sp, color: Colors.white),
                                                                                        ),
                                                                                      )),
                                                                                ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      )
                                                    : Container(),
                                      );
                                    },
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ));
              });
            })
        : Container();
  }
}
