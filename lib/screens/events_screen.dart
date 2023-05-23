import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/screens/all_events_diplay_screen.dart';

import '../models/events_model.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/event_item.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'HomeScreen.dart';
import 'event_description_screen.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: Icon(FontAwesomeIcons.fireFlameCurved, color: Colors.black),
        title: Text(
          'Events',
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
        controller: ScrollController(keepScrollOffset: true),
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: InkWell(
                onTap: () async {
                  if (await canLaunch(
                      "https://docs.google.com/forms/d/e/1FAIpQLSf7G51-XzN9ShVg5xW0Ysgwg0aDcKrSlJ2l8avysrpSbhETEw/viewform")) {
                    await launch(
                      "https://docs.google.com/forms/d/e/1FAIpQLSf7G51-XzN9ShVg5xW0Ysgwg0aDcKrSlJ2l8avysrpSbhETEw/viewform",
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image(
                        image: AssetImage(
                          'images/host_event.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(thickness: 6, color: Color(0xFFEFEFEF)),
          Container(
            color: Colors.white,
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Trending Events',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          Divider(thickness: 6, color: Color(0xFFEFEFEF)),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 360,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('topevents')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.grey.shade300,
                    strokeWidth: 1.5,
                  ));
                }

                return ListView.builder(
                  controller: ScrollController(keepScrollOffset: true),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap =
                        (snapshot.data! as dynamic).docs[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EventDescriptionScreen(id: snap['id'])));
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: Container(
                            width: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          snap['eventposterimg'],
                                          height: 185,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      if (snap['mode'] == 'online')
                                        Positioned(
                                          left: 10,
                                          top: 10,
                                          child: Container(
                                            height: 15,
                                            width: 40,
                                            child: Center(
                                              child: Text('ONLINE',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 7)),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(
                                                0xFF040606,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFdaf6fd),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 36,
                                    width: 179,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(snap['eventDate'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 1,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.5),
                                Text(
                                  snap['evetitle'],
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      fontFamily: 'Roboto'),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  snap['evedescc'],
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.5),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Rs ${snap['price']}',
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      letterSpacing: 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(thickness: 6, color: Color(0xFFEFEFEF)),
          // Container(
          //   height: 230,
          //   width: MediaQuery.of(context).size.width,
          //   color: Color(0xFFFFF2F2),
          //   padding: EdgeInsets.all(4),
          //   child: StreamBuilder(
          //     stream: FirebaseFirestore.instance
          //         .collection('topeventsdaily')
          //         .snapshots(),
          //     builder: (context,
          //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
          //         snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return Center(
          //             child: CircularProgressIndicator(
          //               color: Colors.grey.shade300,
          //               strokeWidth: 1.5,
          //             ));
          //       }
          //
          //       return ListView.builder(
          //         shrinkWrap: true,
          //         controller: ScrollController(),
          //         scrollDirection: Axis.horizontal,
          //         itemCount: snapshot.data!.docs.length,
          //         itemBuilder: (ctx, index) => Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: GestureDetector(
          //             onTap: () {
          //               Navigator.of(context).push(MaterialPageRoute(
          //                   builder: (context) =>
          //                       EventDescriptionScreen(snap: snapshot.data!.docs[index].data())));
          //             },
          //             child: Padding(
          //               padding: const EdgeInsets.all(4.0),
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 crossAxisAlignment: CrossAxisAlignment.stretch,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.only(top: 8.0),
          //                     child: Stack(
          //                       children: [
          //                         ClipRRect(
          //                           borderRadius: BorderRadius.circular(10),
          //                           child: Image.network(
          //                             snap['eventposterimg'],
          //                             height: 250,
          //                             width: MediaQuery.of(context).size.width,
          //                             fit: BoxFit.cover,
          //                           ),
          //                         ),
          //                         if (snap['mode'] == 'online')
          //                           Positioned(
          //                             left: 10,
          //                             top: 10,
          //                             child: Container(
          //                               height: 24,
          //                               width: 60,
          //                               child: Center(
          //                                 child: Text('ONLINE',
          //                                     style: TextStyle(
          //                                         color: Colors.white,
          //                                         fontWeight: FontWeight.bold,
          //                                         fontSize: 10)),
          //                               ),
          //                               decoration: BoxDecoration(
          //                                 color: Color(
          //                                   0xFF040606,
          //                                 ),
          //                                 borderRadius: BorderRadius.circular(25),
          //                               ),
          //                             ),
          //                           )
          //                       ],
          //                     ),
          //                   ),
          //                   SizedBox(height: 5),
          //                   Padding(
          //                     padding: const EdgeInsets.symmetric(vertical: 4.0),
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                         color: Color(0xFFdaf6fd),
          //                         borderRadius: BorderRadius.circular(10),
          //                       ),
          //                       height: 36,
          //                       width: 179,
          //                       child: Padding(
          //                         padding:
          //                         const EdgeInsets.symmetric(horizontal: 8.0),
          //                         child: Align(
          //                           alignment: Alignment.centerLeft,
          //                           child: Text(snap['eventDate'],
          //                               style: TextStyle(
          //                                 fontWeight: FontWeight.bold,
          //                                 fontSize: 14,
          //                                 fontFamily: 'Roboto',
          //                                 letterSpacing: 1,
          //                               )),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(height: 4.5),
          //                   Text(
          //                     snap['evetitle'],
          //                     softWrap: true,
          //                     style: TextStyle(
          //                         color: Colors.black,
          //                         fontSize: 17,
          //                         fontWeight: FontWeight.bold,
          //                         letterSpacing: 1,
          //                         fontFamily: 'Roboto'),
          //                   ),
          //                   SizedBox(height: 7),
          //                   Text(
          //                     snap['evedescc'],
          //                     softWrap: true,
          //                     maxLines: 2,
          //                     overflow: TextOverflow.fade,
          //                     style: TextStyle(
          //                         color: Colors.black,
          //                         fontSize: 13,
          //                         fontFamily: 'Roboto',
          //                         letterSpacing: 0.5),
          //                   ),
          //                   SizedBox(height: 6),
          //                   Text(
          //                     'Rs ${snap['price']}',
          //                     softWrap: true,
          //                     overflow: TextOverflow.fade,
          //                     style: TextStyle(
          //                         color: Colors.black,
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 15,
          //                         fontFamily: 'Roboto',
          //                         letterSpacing: 1),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          Container(
            color: Colors.white,
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Events',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          Divider(thickness: 6, color: Color(0xFFEFEFEF)),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllEventsDisplayScreen(
                              category: 'college',
                              title: 'College Events',
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'images/1.png',
                      fit: BoxFit.cover,
                      width: 167,
                      height: 177,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllEventsDisplayScreen(
                              category: 'live',
                              title: 'Live Events',
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'images/2.png',
                      fit: BoxFit.cover,
                      width: 167,
                      height: 177,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllEventsDisplayScreen(
                              category: 'startup',
                              title: 'Startup Events',
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'images/3.png',
                      fit: BoxFit.cover,
                      width: 167,
                      height: 177,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllEventsDisplayScreen(
                              category: 'exhibition',
                              title: 'Exhibition Events',
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'images/4.png',
                      fit: BoxFit.cover,
                      width: 167,
                      height: 177,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllEventsDisplayScreen(
                              category: 'entertainment',
                              title: 'Entertainment Events',
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'images/6.png',
                      fit: BoxFit.cover,
                      width: 167,
                      height: 177,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllEventsDisplayScreen(
                              category: 'learning',
                              title: 'Learning Events',
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'images/5.png',
                      fit: BoxFit.cover,
                      width: 167,
                      height: 177,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllEventsDisplayScreen(
                              category: 'sports',
                              title: 'Sports Events',
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'images/7.png',
                      fit: BoxFit.cover,
                      width: 167,
                      height: 177,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllEventsDisplayScreen(
                              category: 'competetion',
                              title: 'Competetion Events',
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'images/8.png',
                      fit: BoxFit.cover,
                      width: 167,
                      height: 177,
                    ),
                  ),
                )
              ],
            ),
          ),

          // Container(
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(5)),
          //   child: TabBar(
          //     physics: ClampingScrollPhysics(),
          //     labelPadding: EdgeInsets.symmetric(vertical: 0),
          //     padding: EdgeInsets.symmetric(vertical: 0),
          //     indicatorColor: Colors.black,
          //     controller: tabController,
          //     unselectedLabelColor: Colors.grey,
          //     labelColor: Colors.black,
          //     labelStyle: TextStyle(fontWeight: FontWeight.bold),
          //     tabs: [
          //       Tab(text: 'Explore'),
          //       Tab(
          //         text: 'Pinned',
          //       )
          //     ],
          //   ),
          // ),
          // Expanded(
          //   child: Container(
          //     color: Color(0xFFEFEFEF),
          //     child: TabBarView(
          //         physics: ClampingScrollPhysics(),
          //         controller: tabController,
          //         children: [
          //           StreamBuilder(
          //             stream: FirebaseFirestore.instance
          //                 .collection('events')
          //                 .snapshots(),
          //             builder: (context,
          //                 AsyncSnapshot<
          //                         QuerySnapshot<Map<String, dynamic>>>
          //                     snapshot) {
          //               if (snapshot.connectionState ==
          //                   ConnectionState.waiting) {
          //                 return const Center(
          //                   child: CircularProgressIndicator(),
          //                 );
          //               }
          //               return ListView.builder(
          //                 shrinkWrap: true,
          //                 physics: ClampingScrollPhysics(),
          //                 controller:
          //                     ScrollController(keepScrollOffset: true),
          //                 scrollDirection: Axis.vertical,
          //                 itemCount: snapshot.data!.docs.length,
          //                 itemBuilder: (ctx, index) => Container(
          //                   child: EventItem(
          //                     snap: snapshot.data!.docs[index].data(),
          //                     onpressed: () {
          //                       showModalBottomSheet(
          //                         enableDrag: true,
          //                         isDismissible: true,
          //                         backgroundColor:
          //                             Colors.black.withOpacity(0),
          //                         context: context,
          //                         builder: (BuildContext c) {
          //                           return Container(
          //                             color: Colors.transparent,
          //                             child: Container(
          //                               decoration: BoxDecoration(
          //                                   color: Colors.white,
          //                                   borderRadius:
          //                                       BorderRadius.only(
          //                                           topRight:
          //                                               Radius.circular(
          //                                                   20),
          //                                           topLeft:
          //                                               Radius.circular(
          //                                                   20))),
          //                               child: Column(
          //                                 children: <Widget>[
          //                                   SizedBox(height: 8),
          //                                   Container(
          //                                     height: 5,
          //                                     width: 45,
          //                                     decoration: BoxDecoration(
          //                                       borderRadius:
          //                                           BorderRadius.circular(
          //                                               5),
          //                                       color: Colors.black87,
          //                                     ),
          //                                   ),
          //                                   SizedBox(height: 17),
          //                                   Container(
          //                                     height: 140,
          //                                     width:
          //                                         MediaQuery.of(context)
          //                                             .size
          //                                             .width,
          //                                     child: Image.network(
          //                                       snapshot.data!.docs[index]
          //                                           .data()["imageUrl"]
          //                                           .toString(),
          //                                       fit: BoxFit.fill,
          //                                     ),
          //                                   ),
          //                                   SizedBox(height: 15),
          //                                   Padding(
          //                                     padding:
          //                                         const EdgeInsets.only(
          //                                             left: 15.0),
          //                                     child: Row(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment
          //                                               .start,
          //                                       children: [
          //                                         CircleAvatar(
          //                                           radius: 20,
          //                                           backgroundImage:
          //                                               NetworkImage(
          //                                             snapshot.data!
          //                                                 .docs[index]
          //                                                 .data()[
          //                                                     "imageUrl"]
          //                                                 .toString(),
          //                                           ),
          //                                         ),
          //                                         SizedBox(
          //                                           width: 10,
          //                                         ),
          //                                         Text(
          //                                           snapshot
          //                                               .data!.docs[index]
          //                                               .data()[
          //                                                   "evetitle"]
          //                                               .toString(),
          //                                           style: TextStyle(
          //                                             fontSize: 18.sp,
          //                                             fontWeight:
          //                                                 FontWeight.bold,
          //                                           ),
          //                                         ),
          //                                         Expanded(
          //                                             child: SizedBox()),
          //                                         GestureDetector(
          //                                             child: Padding(
          //                                           padding:
          //                                               const EdgeInsets
          //                                                       .only(
          //                                                   right: 16.0),
          //                                           child: Container(
          //                                             padding:
          //                                                 EdgeInsets.all(
          //                                                     10),
          //                                             decoration:
          //                                                 BoxDecoration(
          //                                                     borderRadius:
          //                                                         BorderRadius.all(Radius.circular(
          //                                                             5)),
          //                                                     border:
          //                                                         Border
          //                                                             .all(
          //                                                       color:
          //                                                           Color(
          //                                                         0xFF6F6F6F,
          //                                                       ),
          //                                                     )),
          //                                             child: Image.asset(
          //                                               'images/share_icons.png',
          //                                               height: 19,
          //                                             ),
          //                                           ),
          //                                         )),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                   SizedBox(
          //                                     height: 15,
          //                                   ),
          //                                   Padding(
          //                                     padding: const EdgeInsets
          //                                         .symmetric(
          //                                       horizontal: 15.0,
          //                                     ),
          //                                     child: Text(
          //                                       snapshot.data!.docs[index]
          //                                           .data()["evedescc"]
          //                                           .toString(),
          //                                       textAlign: TextAlign.left,
          //                                       maxLines: 4,
          //                                       style: TextStyle(
          //                                         fontSize: 15.sp,
          //                                       ),
          //                                     ),
          //                                   ),
          //                                   Expanded(child: SizedBox()),
          //                                   Container(
          //                                     padding:
          //                                         EdgeInsets.symmetric(
          //                                             vertical: 10,
          //                                             horizontal: 50),
          //                                     decoration: BoxDecoration(
          //                                         borderRadius:
          //                                             BorderRadius.all(
          //                                                 Radius.circular(
          //                                                     7)),
          //                                         border: Border.all(
          //                                           color: Color(
          //                                             0xFF585858,
          //                                           ),
          //                                         )),
          //                                     child: Text(
          //                                       snapshot.data!.docs[index]
          //                                           .data()["eventDate"]
          //                                           .toString(),
          //                                       style: TextStyle(
          //                                           fontFamily: 'Roboto',
          //                                           fontWeight:
          //                                               FontWeight.bold,
          //                                           fontSize: 15),
          //                                     ),
          //                                   ),
          //                                   Expanded(child: SizedBox()),
          //                                   Align(
          //                                     alignment:
          //                                         Alignment.bottomCenter,
          //                                     child: Padding(
          //                                       padding:
          //                                           const EdgeInsets.only(
          //                                               bottom: 15.0),
          //                                       child: snapshot.data!
          //                                                   .docs[index]
          //                                                   .data()[
          //                                                       "type"]
          //                                                   .toString() ==
          //                                               "paid"
          //                                           ? Padding(
          //                                               padding:
          //                                                   const EdgeInsets
          //                                                           .only(
          //                                                       bottom:
          //                                                           15.0),
          //                                               child:
          //                                                   ElevatedButton(
          //                                                       style: ElevatedButton
          //                                                           .styleFrom(
          //                                                         backgroundColor:
          //                                                             btnCOlorblue,
          //                                                         shape: RoundedRectangleBorder(
          //                                                             borderRadius:
          //                                                                 BorderRadius.all(Radius.circular(7))),
          //                                                       ),
          //                                                       onPressed:
          //                                                           () async {
          //                                                         final url = snapshot
          //                                                             .data!
          //                                                             .docs[index]
          //                                                             .data()["url"]
          //                                                             .toString();
          //                                                         if (await canLaunch(
          //                                                             url)) {
          //                                                           await launch(
          //                                                               url,
          //                                                               enableJavaScript: true,
          //                                                               forceWebView: true);
          //                                                         }
          //                                                       },
          //                                                       // color: btnCOlorblue,
          //                                                       child:
          //                                                           Padding(
          //                                                         padding: const EdgeInsets.symmetric(
          //                                                             horizontal:
          //                                                                 50,
          //                                                             vertical:
          //                                                                 8),
          //                                                         child:
          //                                                             Text(
          //                                                           'Register',
          //                                                           style: TextStyle(
          //                                                               fontSize: 16.sp,
          //                                                               color: Colors.white),
          //                                                         ),
          //                                                       )),
          //                                             )
          //                                           : Padding(
          //                                               padding:
          //                                                   const EdgeInsets
          //                                                           .only(
          //                                                       bottom:
          //                                                           15.0),
          //                                               child:
          //                                                   ElevatedButton(
          //                                                       style: ElevatedButton
          //                                                           .styleFrom(
          //                                                         backgroundColor:
          //                                                             btnCOlorblue,
          //                                                         shape: RoundedRectangleBorder(
          //                                                             borderRadius:
          //                                                                 BorderRadius.all(Radius.circular(7))),
          //                                                       ),
          //                                                       onPressed:
          //                                                           () async {
          //                                                         final url = snapshot
          //                                                             .data!
          //                                                             .docs[index]
          //                                                             .data()["url"]
          //                                                             .toString();
          //                                                         if (await canLaunch(
          //                                                             url)) {
          //                                                           await launch(
          //                                                               url,
          //                                                               enableJavaScript: true,
          //                                                               forceWebView: true);
          //                                                         }
          //                                                       },
          //                                                       // color: btnCOlorblue,
          //                                                       child:
          //                                                           Padding(
          //                                                         padding: const EdgeInsets.symmetric(
          //                                                             horizontal:
          //                                                                 50,
          //                                                             vertical:
          //                                                                 8),
          //                                                         child:
          //                                                             Text(
          //                                                           'Join',
          //                                                           style: TextStyle(
          //                                                               fontSize: 16.sp,
          //                                                               color: Colors.white),
          //                                                         ),
          //                                                       )),
          //                                             ),
          //                                     ),
          //                                   )
          //                                 ],
          //                               ),
          //                             ),
          //                           );
          //                         },
          //                       );
          //                     },
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //           StreamBuilder(
          //             stream: FirebaseFirestore.instance
          //                 .collection('events')
          //                 .snapshots(),
          //             builder: (context,
          //                 AsyncSnapshot<
          //                         QuerySnapshot<Map<String, dynamic>>>
          //                     snapshot) {
          //               if (snapshot.connectionState ==
          //                   ConnectionState.waiting) {
          //                 return const Center(
          //                   child: CircularProgressIndicator(),
          //                 );
          //               }
          //               return ListView.builder(
          //                 shrinkWrap: true,
          //                 physics: ClampingScrollPhysics(),
          //                 controller:
          //                     ScrollController(keepScrollOffset: true),
          //                 scrollDirection: Axis.vertical,
          //                 itemCount: snapshot.data!.docs.length,
          //                 itemBuilder:
          //                     (ctx, index) =>
          //                         (snapshot.data!.docs[index]
          //                                     .data()["saves"] as List)
          //                                 .contains(_currentUserUid)
          //                             ? EventItem(
          //                                 snap: snapshot.data!.docs[index]
          //                                     .data(),
          //                                 onpressed: () {
          //                                   showModalBottomSheet(
          //                                     enableDrag: true,
          //                                     isDismissible: true,
          //                                     backgroundColor: Colors
          //                                         .black
          //                                         .withOpacity(0),
          //                                     context: context,
          //                                     builder: (BuildContext c) {
          //                                       return Container(
          //                                         color:
          //                                             Colors.transparent,
          //                                         child: Container(
          //                                           decoration: BoxDecoration(
          //                                               color:
          //                                                   Colors.white,
          //                                               borderRadius: BorderRadius.only(
          //                                                   topRight: Radius
          //                                                       .circular(
          //                                                           20),
          //                                                   topLeft: Radius
          //                                                       .circular(
          //                                                           20))),
          //                                           child: Column(
          //                                             children: <Widget>[
          //                                               SizedBox(
          //                                                   height: 8),
          //                                               Container(
          //                                                 height: 5,
          //                                                 width: 45,
          //                                                 decoration:
          //                                                     BoxDecoration(
          //                                                   borderRadius:
          //                                                       BorderRadius
          //                                                           .circular(
          //                                                               5),
          //                                                   color: Colors
          //                                                       .black87,
          //                                                 ),
          //                                               ),
          //                                               SizedBox(
          //                                                   height: 17),
          //                                               Container(
          //                                                 height: 140,
          //                                                 width: MediaQuery.of(
          //                                                         context)
          //                                                     .size
          //                                                     .width,
          //                                                 child: Image
          //                                                     .network(
          //                                                   snapshot
          //                                                       .data!
          //                                                       .docs[
          //                                                           index]
          //                                                       .data()[
          //                                                           "imageUrl"]
          //                                                       .toString(),
          //                                                   fit: BoxFit
          //                                                       .fill,
          //                                                 ),
          //                                               ),
          //                                               SizedBox(
          //                                                   height: 15),
          //                                               Padding(
          //                                                 padding:
          //                                                     const EdgeInsets
          //                                                             .only(
          //                                                         left:
          //                                                             15.0),
          //                                                 child: Row(
          //                                                   mainAxisAlignment:
          //                                                       MainAxisAlignment
          //                                                           .start,
          //                                                   children: [
          //                                                     CircleAvatar(
          //                                                       radius:
          //                                                           20,
          //                                                       backgroundImage:
          //                                                           NetworkImage(
          //                                                         snapshot
          //                                                             .data!
          //                                                             .docs[index]
          //                                                             .data()["imageUrl"]
          //                                                             .toString(),
          //                                                       ),
          //                                                     ),
          //                                                     SizedBox(
          //                                                       width: 10,
          //                                                     ),
          //                                                     Text(
          //                                                       snapshot
          //                                                           .data!
          //                                                           .docs[
          //                                                               index]
          //                                                           .data()[
          //                                                               "evetitle"]
          //                                                           .toString(),
          //                                                       style:
          //                                                           TextStyle(
          //                                                         fontSize:
          //                                                             18.sp,
          //                                                         fontWeight:
          //                                                             FontWeight.bold,
          //                                                       ),
          //                                                     ),
          //                                                     Expanded(
          //                                                         child:
          //                                                             SizedBox()),
          //                                                     GestureDetector(
          //                                                         child:
          //                                                             Padding(
          //                                                       padding: const EdgeInsets
          //                                                               .only(
          //                                                           right:
          //                                                               16.0),
          //                                                       child:
          //                                                           Container(
          //                                                         padding:
          //                                                             EdgeInsets.all(10),
          //                                                         decoration: BoxDecoration(
          //                                                             borderRadius: BorderRadius.all(Radius.circular(5)),
          //                                                             border: Border.all(
          //                                                               color: Color(
          //                                                                 0xFF6F6F6F,
          //                                                               ),
          //                                                             )),
          //                                                         child: Image
          //                                                             .asset(
          //                                                           'images/share_icons.png',
          //                                                           height:
          //                                                               19,
          //                                                         ),
          //                                                       ),
          //                                                     )),
          //                                                   ],
          //                                                 ),
          //                                               ),
          //                                               SizedBox(
          //                                                 height: 15,
          //                                               ),
          //                                               Padding(
          //                                                 padding:
          //                                                     const EdgeInsets
          //                                                         .symmetric(
          //                                                   horizontal:
          //                                                       15.0,
          //                                                 ),
          //                                                 child: Text(
          //                                                   snapshot
          //                                                       .data!
          //                                                       .docs[
          //                                                           index]
          //                                                       .data()[
          //                                                           "evedescc"]
          //                                                       .toString(),
          //                                                   textAlign:
          //                                                       TextAlign
          //                                                           .left,
          //                                                   maxLines: 4,
          //                                                   style:
          //                                                       TextStyle(
          //                                                     fontSize:
          //                                                         15.sp,
          //                                                   ),
          //                                                 ),
          //                                               ),
          //                                               Expanded(
          //                                                   child:
          //                                                       SizedBox()),
          //                                               Container(
          //                                                 padding: EdgeInsets
          //                                                     .symmetric(
          //                                                         vertical:
          //                                                             10,
          //                                                         horizontal:
          //                                                             50),
          //                                                 decoration:
          //                                                     BoxDecoration(
          //                                                         borderRadius:
          //                                                             BorderRadius.all(Radius.circular(
          //                                                                 7)),
          //                                                         border:
          //                                                             Border.all(
          //                                                           color:
          //                                                               Color(
          //                                                             0xFF585858,
          //                                                           ),
          //                                                         )),
          //                                                 child: Text(
          //                                                   snapshot
          //                                                       .data!
          //                                                       .docs[
          //                                                           index]
          //                                                       .data()[
          //                                                           "eventDate"]
          //                                                       .toString(),
          //                                                   style: TextStyle(
          //                                                       fontFamily:
          //                                                           'Roboto',
          //                                                       fontWeight:
          //                                                           FontWeight
          //                                                               .bold,
          //                                                       fontSize:
          //                                                           15),
          //                                                 ),
          //                                               ),
          //                                               Expanded(
          //                                                   child:
          //                                                       SizedBox()),
          //                                               Align(
          //                                                 alignment: Alignment
          //                                                     .bottomCenter,
          //                                                 child: Padding(
          //                                                   padding: const EdgeInsets
          //                                                           .only(
          //                                                       bottom:
          //                                                           15.0),
          //                                                   child: snapshot
          //                                                               .data!
          //                                                               .docs[index]
          //                                                               .data()["type"]
          //                                                               .toString() ==
          //                                                           "paid"
          //                                                       ? Padding(
          //                                                           padding:
          //                                                               const EdgeInsets.only(bottom: 15.0),
          //                                                           child: ElevatedButton(
          //                                                               style: ElevatedButton.styleFrom(
          //                                                                 backgroundColor: btnCOlorblue,
          //                                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
          //                                                               ),
          //                                                               onPressed: () async {
          //                                                                 final url = snapshot.data!.docs[index].data()["url"].toString();
          //                                                                 if (await canLaunch(url)) {
          //                                                                   await launch(url, enableJavaScript: true, forceWebView: true);
          //                                                                 }
          //                                                               },
          //                                                               // color: btnCOlorblue,
          //                                                               child: Padding(
          //                                                                 padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          //                                                                 child: Text(
          //                                                                   'Register',
          //                                                                   style: TextStyle(fontSize: 16.sp, color: Colors.white),
          //                                                                 ),
          //                                                               )),
          //                                                         )
          //                                                       : Padding(
          //                                                           padding:
          //                                                               const EdgeInsets.only(bottom: 15.0),
          //                                                           child: ElevatedButton(
          //                                                               style: ElevatedButton.styleFrom(
          //                                                                 backgroundColor: btnCOlorblue,
          //                                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
          //                                                               ),
          //                                                               onPressed: () async {
          //                                                                 final url = snapshot.data!.docs[index].data()["url"].toString();
          //                                                                 if (await canLaunch(url)) {
          //                                                                   await launch(url, enableJavaScript: true, forceWebView: true);
          //                                                                 }
          //                                                               },
          //                                                               // color: btnCOlorblue,
          //                                                               child: Padding(
          //                                                                 padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          //                                                                 child: Text(
          //                                                                   'Join',
          //                                                                   style: TextStyle(fontSize: 16.sp, color: Colors.white),
          //                                                                 ),
          //                                                               )),
          //                                                         ),
          //                                                 ),
          //                                               )
          //                                             ],
          //                                           ),
          //                                         ),
          //                                       );
          //                                     },
          //                                   );
          //                                 },
          //                               )
          //                             : Container(),
          //               );
          //             },
          //           ),
          //         ]),
          //   ),
          // ),
        ],
      ),
    );
  }
}
