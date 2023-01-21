import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zero_fin/screens/profile_screen.dart';

import '../utils/colors.dart';
import 'ChatRoom.dart';

class FollowersFollowingScreen extends StatefulWidget {
  final String uid;
  final String textfwl;
  final int indexinitial;
  const FollowersFollowingScreen(
      {Key? key,
      required this.uid,
      required this.textfwl,
      required this.indexinitial})
      : super(key: key);

  @override
  State<FollowersFollowingScreen> createState() =>
      _FollowersFollowingScreenState();
}

class _FollowersFollowingScreenState extends State<FollowersFollowingScreen>
    with TickerProviderStateMixin {
  String followerUsername = "";

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
        initialIndex: widget.indexinitial, length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 5,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
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
        title: Text(widget.textfwl,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000),
                fontSize: 19)),
        centerTitle: false,
      ),
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
                Tab(text: 'Followers'),
                Tab(
                  text: 'Following',
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.uid)
                    .collection("followers")
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
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        print(snapshot.data!.docs[index].data()["followers"]);
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic)
                                    .docs[index]['followid']
                                    .toString(),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Container(
                              height: 80,
                              width: double.infinity,
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          (snapshot.data! as dynamic)
                                              .docs[index]['profilepic']
                                              .toString(),
                                        ),
                                        radius: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
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
                                                (snapshot.data! as dynamic)
                                                    .docs[index]['username']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Roboto')),
                                            SizedBox(
                                              height: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    (snapshot.data! as dynamic)
                                                .docs[index]['followid']
                                                .toString() !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                                .toString()
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 13),
                                            child: Row(
                                              children: [
                                                // IconButton(
                                                //   style: ElevatedButton.styleFrom(
                                                //       backgroundColor:
                                                //           btnCOlorblue,
                                                //       minimumSize: Size(50, 12),
                                                //       shape:
                                                //           RoundedRectangleBorder(
                                                //               borderRadius:
                                                //                   BorderRadius
                                                //                       .circular(
                                                //                           7))),
                                                //   onPressed:
                                                //       () {}, //TODO 2. button action
                                                //   icon: Icon(
                                                //     FontAwesomeIcons.userPlus,
                                                //     size: 20,
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                IconButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          btnCOlorblue,
                                                      minimumSize: Size(50, 12),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7))),
                                                  onPressed: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => ChatRoom(
                                                            otUsername: (snapshot.data! as dynamic)
                                                                .docs[index]
                                                                    ['username']
                                                                .toString(),
                                                            otUid: (snapshot.data! as dynamic)
                                                                .docs[index]
                                                                    ['followid']
                                                                .toString(),
                                                            profilePic: (snapshot.data! as dynamic)
                                                                .docs[index][
                                                                    'profilepic']
                                                                .toString(),
                                                            status: (snapshot.data! as dynamic)
                                                                .docs[index]
                                                                    ['status']
                                                                .toString(),
                                                            token: (snapshot.data! as dynamic)
                                                                .docs[index]['token']
                                                                .toString())));
                                                  }, //TODO 2. button action
                                                  icon: Icon(
                                                    FontAwesomeIcons
                                                        .solidPaperPlane,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            width: 50,
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.uid)
                    .collection("following")
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
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        print(snapshot.data!.docs[index].data()["followers"]);
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic)
                                    .docs[index]['followid']
                                    .toString(),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Container(
                              height: 80,
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          (snapshot.data! as dynamic)
                                              .docs[index]['profilepic']
                                              .toString(),
                                        ),
                                        radius: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
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
                                                (snapshot.data! as dynamic)
                                                    .docs[index]['username']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Roboto')),
                                            SizedBox(
                                              height: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    (snapshot.data! as dynamic)
                                                .docs[index]['followid']
                                                .toString() !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                                .toString()
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 13),
                                            child: Row(
                                              children: [
                                                // IconButton(
                                                //   style: ElevatedButton.styleFrom(
                                                //       backgroundColor:
                                                //           btnCOlorblue,
                                                //       minimumSize: Size(50, 12),
                                                //       shape:
                                                //           RoundedRectangleBorder(
                                                //               borderRadius:
                                                //                   BorderRadius
                                                //                       .circular(
                                                //                           7))),
                                                //   onPressed:
                                                //       () {}, //TODO 2. button action
                                                //   icon: Icon(
                                                //     FontAwesomeIcons.userPlus,
                                                //     size: 20,
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                IconButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          btnCOlorblue,
                                                      minimumSize: Size(50, 12),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7))),
                                                  onPressed: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => ChatRoom(
                                                            otUsername: (snapshot.data! as dynamic)
                                                                .docs[index]
                                                                    ['username']
                                                                .toString(),
                                                            otUid: (snapshot.data! as dynamic)
                                                                .docs[index]
                                                                    ['followid']
                                                                .toString(),
                                                            profilePic: (snapshot.data! as dynamic)
                                                                .docs[index][
                                                                    'profilepic']
                                                                .toString(),
                                                            status: (snapshot.data! as dynamic)
                                                                .docs[index]
                                                                    ['status']
                                                                .toString(),
                                                            token: (snapshot.data! as dynamic)
                                                                .docs[index]['token']
                                                                .toString())));
                                                  }, //TODO 2. button action
                                                  icon: Icon(
                                                    FontAwesomeIcons
                                                        .solidPaperPlane,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            width: 50,
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
