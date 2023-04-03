import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/resources/firebase_dynamic_links.dart';
import 'package:zero_fin/screens/fashion_comments_screen.dart';
import '../screens/edit_post_screen.dart';
import '../screens/profile_screen.dart';
import '/models/user.dart' as model;
import '/providers/user_provider.dart';
import '/resources/firestore_methods.dart';
import '/screens/comments_screen.dart';
import '/utils/colors.dart';
import '/utils/global_variable.dart';
import '/utils/utils.dart';
import '/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class FashionCard extends StatefulWidget {
  final snap;

  const FashionCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<FashionCard> createState() => _FashionCardState();
}

class _FashionCardState extends State<FashionCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  bool issaved = false;
  bool isSended = false;
  CollectionReference chats = FirebaseFirestore.instance.collection("chatroom");

  String tokenpst = '';

  final currentUid = FirebaseAuth.instance.currentUser!.uid;

  var chatDocId;
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
    getData();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: widget.snap['uid'])
        .get()
        .then((value) {
      for (var docs in value.docs) {
        if (docs.data()['uid'].toString() == widget.snap['uid']) {
          tokenpst = docs.data()['token'].toString();
        }
      }
    });
  }

  var searchController = TextEditingController();
  bottomSheetforshare(context, String txt) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext c) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 1,
          minChildSize: 0.3,
          builder: (context, controller) => Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8), topLeft: Radius.circular(8))),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 8,
            ),
            child: ListView(
              controller: controller,
              children: <Widget>[
                SizedBox(
                  height: 6,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 160),
                  height: 4,
                  width: 10,
                  constraints: BoxConstraints(maxWidth: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      // suffixIcon: Icon(
                      //   FontAwesomeIcons.magnifyingGlass,
                      //   color: Colors.black54,
                      // ),
                      isDense: true,
                      isCollapsed: true,
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(
                        10,
                        10,
                        0,
                        10,
                      ),
                      hintStyle: TextStyle(fontWeight: FontWeight.w700),
                      hintText: 'Search...',
                      fillColor: Color(0xFFEFEFEF),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: const Color(0xFFD9D8D8), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFFFFFFFF),
                          width: 1,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {});
                    },
                    onChanged: (String _) {
                      setState(() {});
                      print(_);
                    },
                  ),
                ),
                // StreamBuilder(
                //   stream: searchController.text.toString() == ""
                //       ? FirebaseFirestore.instance
                //           .collection('users')
                //           .where('uid', isNotEqualTo: currentUid)
                //           .snapshots()
                //       : FirebaseFirestore.instance
                //           .collection('users')
                //           .where('username',
                //               isGreaterThanOrEqualTo:
                //                   searchController.text.toString())
                //           .snapshots(),
                //   builder: (context, snapshot) {
                //     if (!snapshot.hasData) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }
                //
                //     return ListView.builder(
                //       shrinkWrap: true,
                //       physics: BouncingScrollPhysics(),
                //       controller: controller,
                //       itemCount: (snapshot.data! as dynamic).docs.length,
                //       itemBuilder: (context, index) => Align(
                //           alignment: Alignment.topLeft,
                //           child: Container(
                //             color: Colors.white,
                //             child: SizedBox(
                //               height: 60,
                //               child: ListTile(
                //                 trailing:
                //                     // isSended == false
                //                     //     ?
                //                     (snapshot.data! as dynamic)
                //                                 .docs[index]['uid']
                //                                 .toString() !=
                //                             currentUid
                //                         ? TextButton(
                //                             style: ElevatedButton.styleFrom(
                //                                 backgroundColor: btnCOlorblue,
                //                                 minimumSize: Size(75, 12),
                //                                 shape: RoundedRectangleBorder(
                //                                     borderRadius:
                //                                         BorderRadius.circular(
                //                                             8))),
                //                             onPressed: () {
                //                               getDataOfChats(
                //                                   (snapshot.data! as dynamic)
                //                                       .docs[index]['uid']
                //                                       .toString());
                //                               Fluttertoast.showToast(
                //                                   msg: "Post sent ",
                //                                   toastLength:
                //                                       Toast.LENGTH_SHORT,
                //                                   gravity: ToastGravity.BOTTOM,
                //                                   timeInSecForIosWeb: 1,
                //                                   backgroundColor:
                //                                       Colors.black87,
                //                                   textColor: Colors.white,
                //                                   fontSize: 16);
                //                             },
                //                             child: Text(
                //                               isSended == false
                //                                   ? "Send"
                //                                   : "sent",
                //                               style: TextStyle(
                //                                   color: Colors.white,
                //                                   fontWeight: FontWeight.w700),
                //                             ))
                //                         : SizedBox()
                //                 // : TextButton(
                //                 //     style: ElevatedButton.styleFrom(
                //                 //         backgroundColor:
                //                 //             Colors.grey.shade300,
                //                 //         minimumSize: Size(75, 12),
                //                 //         shape: RoundedRectangleBorder(
                //                 //             borderRadius:
                //                 //                 BorderRadius.circular(8))),
                //                 //     onPressed: () {
                //                 //       setState(() {
                //                 //         isSended = !isSended;
                //                 //       });
                //                 //     },
                //                 //     child: Text(
                //                 //       "sent",
                //                 //       style: TextStyle(
                //                 //           color: Colors.black54,
                //                 //           fontWeight: FontWeight.w700),
                //                 //     ))
                //                 ,
                //                 title: Text(
                //                     (snapshot.data! as dynamic)
                //                         .docs[index]['username']
                //                         .toString(),
                //                     style: TextStyle(
                //                         color: Color(0xFF000000),
                //                         fontSize: 15,
                //                         fontWeight: FontWeight.w700,
                //                         fontFamily: 'Roboto')),
                //                 leading: CircleAvatar(
                //                   backgroundImage: NetworkImage(
                //                     (snapshot.data! as dynamic)
                //                         .docs[index]['photoUrl']
                //                         .toString(),
                //                   ),
                //                   radius: 20,
                //                 ),
                //                 subtitle: Text(
                //                     (snapshot.data! as dynamic)
                //                         .docs[index]['university']
                //                         .toString(),
                //                     style: TextStyle(
                //                         fontSize: 13, fontFamily: 'Roboto')),
                //               ),
                //             ),
                //           )),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  bottomSheetforlike(context, String txt, List likedUid) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext c) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.30,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8))),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 8,
              ),
              child: ListView(
                controller: scrollController,
                children: <Widget>[
                  SizedBox(height: 6),
                  Container(
                    height: 4,
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 170),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        // suffixIcon: Icon(
                        //   FontAwesomeIcons.magnifyingGlass,
                        //   color: Colors.black54,
                        // ),
                        isDense: true,
                        isCollapsed: true,
                        filled: true,
                        contentPadding: EdgeInsets.fromLTRB(
                          10,
                          10,
                          0,
                          10,
                        ),
                        hintStyle: TextStyle(fontWeight: FontWeight.w700),
                        hintText: 'Search...',
                        fillColor: Color(0xFFEFEFEF),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: const Color(0xFFD9D8D8), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                            width: 1,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {});
                      },
                      onFieldSubmitted: (String _) {
                        print(_);
                      },
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Text(
                          'LIKED BY',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                      Padding(
                        //TODO Wanted to use positioned widgit to make this at corner.
                        padding: const EdgeInsets.only(left: 240.0),
                        child: Text(likedUid.length.toString() + " likes",
                            style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                    color: Color(0xFFD9D8D8),
                  ),
                  StreamBuilder(
                    stream: searchController.text.toString() == " "
                        ? FirebaseFirestore.instance
                            .collection('users')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('users')
                            .where('username',
                                isGreaterThanOrEqualTo: searchController.text)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        physics: ClampingScrollPhysics(),
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) => likedUid.contains(
                                (snapshot.data! as dynamic)
                                    .docs[index]['uid']
                                    .toString())
                            ? Align(
                                child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          uid: (snapshot.data! as dynamic)
                                              .docs[index]['uid']
                                              .toString()),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 60,
                                  child: ListTile(
                                    trailing:
                                        // isSended == false
                                        //     ?
                                        TextButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: btnCOlorblue,
                                                minimumSize: Size(75, 12),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            onPressed: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileScreen(
                                                    uid: (snapshot.data!
                                                            as dynamic)
                                                        .docs[index]['uid']
                                                        .toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "View",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ))
                                    // : TextButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //         backgroundColor:
                                    //             Colors.grey.shade300,
                                    //         minimumSize: Size(75, 12),
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(8))),
                                    //     onPressed: () {
                                    //       setState(() {
                                    //         isSended = !isSended;
                                    //       });
                                    //     },
                                    //     child: Text(
                                    //       "sent",
                                    //       style: TextStyle(
                                    //           color: Colors.black54,
                                    //           fontWeight: FontWeight.w700),
                                    //     ))
                                    ,
                                    title: Text(
                                        (snapshot.data! as dynamic)
                                            .docs[index]['username']
                                            .toString(),
                                        style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto')),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        (snapshot.data! as dynamic)
                                            .docs[index]['photoUrl']
                                            .toString(),
                                      ),
                                      radius: 20,
                                    ),
                                    subtitle: Text(
                                        (snapshot.data! as dynamic)
                                            .docs[index]['university']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Roboto')),
                                  ),
                                ),
                                // Container(
                                //   color: Colors.white,
                                //   height: 60,
                                //   child: Row(
                                //     children: [
                                //       Padding(
                                //         padding:
                                //             const EdgeInsets.only(left: 20),
                                //         child: CircleAvatar(
                                //           backgroundImage: NetworkImage(
                                //             (snapshot.data! as dynamic)
                                //                 .docs[index]['photoUrl']
                                //                 .toString(),
                                //           ),
                                //           radius: 22,
                                //         ),
                                //       ),
                                //       SizedBox(
                                //         width: 3,
                                //       ),
                                //       Expanded(
                                //         child: Padding(
                                //           padding: const EdgeInsets.all(12.0),
                                //           child: Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.center,
                                //             children: [
                                //               Text(
                                //                   (snapshot.data! as dynamic)
                                //                       .docs[index]['username']
                                //                       .toString(),
                                //                   style: TextStyle(
                                //                       color: Color(0xFF000000),
                                //                       fontSize: 15,
                                //                       fontWeight:
                                //                           FontWeight.w700,
                                //                       fontFamily: 'Roboto')),
                                //               SizedBox(
                                //                 height: 3,
                                //               ),
                                //               Text(
                                //                   (snapshot.data! as dynamic)
                                //                       .docs[index]['university']
                                //                       .toString(),
                                //                   style: TextStyle(
                                //                       color: Colors.black54,
                                //                       fontSize: 13,
                                //                       fontFamily: 'Roboto')),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //       Padding(
                                //         padding:
                                //             const EdgeInsets.only(right: 10),
                                //         child: Row(
                                //           children: [
                                //             SizedBox(
                                //               width: 10,
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //       TextButton(
                                //           style: TextButton.styleFrom(
                                //             padding: EdgeInsets.zero,
                                //             minimumSize: Size(80, 30),
                                //             backgroundColor: btnCOlorblue,
                                //             shape: RoundedRectangleBorder(
                                //                 borderRadius: BorderRadius.all(
                                //                     Radius.circular(7))),
                                //           ),
                                //           onPressed: () async {
                                //             Navigator.push(
                                //               context,
                                //               MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     ProfileScreen(
                                //                   uid: (snapshot.data!
                                //                           as dynamic)
                                //                       .docs[index]['uid']
                                //                       .toString(),
                                //                 ),
                                //               ),
                                //             );
                                //           },
                                //           // color: btnCOlorblue,
                                //           child: Text(
                                //             'View',
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.w700,
                                //                 fontSize: 14,
                                //                 color: Colors.white),
                                //           )),
                                //       Row(
                                //         children: [
                                //           SizedBox(
                                //             width: 15,
                                //           ),
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),
                              ))
                            : Container(),
                      );
                    },
                  )
                ],
              ),
            );
          },
        );
        ;
      },
    );
  }

  // bottomSheetforownthreedot(context, String txt) {
  //   showModalBottomSheet(
  //     backgroundColor: Colors.black.withOpacity(0),
  //     context: context,
  //     builder: (BuildContext c) {
  //       return Container(
  //         color: Colors.transparent,
  //         child: Container(
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                   topRight: Radius.circular(8), topLeft: Radius.circular(8))),
  //           width: MediaQuery.of(context).size.width,
  //           padding: EdgeInsets.symmetric(
  //             horizontal: 5,
  //             vertical: 10,
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               SizedBox(height: 6),
  //               Container(
  //                 height: 4,
  //                 width: 50,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(5),
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         InkWell(
  //                           onTap: () {
  //                             bottomSheetforshare(context, 'txt');
  //                           },
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 border: Border.all(
  //                                   color: Colors.black87,
  //                                 ),
  //                                 borderRadius: BorderRadius.circular(25)),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(15.0),
  //                               child: Icon(
  //                                 FontAwesomeIcons.solidPaperPlane,
  //                                 size: 18,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Text('Chat',
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.w700,
  //                                 color: Color(0xFF000000),
  //                                 fontSize: 13,
  //                               )),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(width: 18),
  //                   GestureDetector(
  //                     onTap: () async {
  //                       String generatedDeepLink =
  //                           await FirebaseDynamicLinksService.createDynamicLink(
  //                               widget.snap['postId'].toString());
  //                       Share.share(
  //                         generatedDeepLink,
  //                       );
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Container(
  //                             decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 border: Border.all(
  //                                   color: Colors.black87,
  //                                 ),
  //                                 borderRadius: BorderRadius.circular(25)),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(15.0),
  //                               child: Icon(
  //                                 FontAwesomeIcons.shareNodes,
  //                                 size: 18,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Text('Share',
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   color: Color(0xFF000000),
  //                                   fontSize: 13,
  //                                 )),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 18),
  //                   GestureDetector(
  //                     onTap: () async {
  //                       Fluttertoast.showToast(
  //                           msg: "Link Copied",
  //                           toastLength: Toast.LENGTH_SHORT,
  //                           gravity: ToastGravity.BOTTOM,
  //                           timeInSecForIosWeb: 1,
  //                           backgroundColor: Colors.black87,
  //                           textColor: Colors.white,
  //                           fontSize: 16.0);
  //
  //                       String generatedDeepLink =
  //                           await FirebaseDynamicLinksService.createDynamicLink(
  //                               widget.snap['postId'].toString());
  //                       FlutterClipboard.copy(generatedDeepLink)
  //                           .then((value) => print('copied'));
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Container(
  //                             decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 border: Border.all(
  //                                   color: Colors.black87,
  //                                 ),
  //                                 borderRadius: BorderRadius.circular(25)),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(15.0),
  //                               child: Icon(
  //                                 FontAwesomeIcons.link,
  //                                 size: 18,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Text('Link',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w700,
  //                                     color: Color(0xFF000000),
  //                                     fontSize: 13)),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Divider(thickness: 0.5, color: Colors.black12),
  //               ListTile(
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => EditPostScreen(
  //                                 postId: widget.snap["postId"],
  //                                 postUrl: widget.snap["postUrl"],
  //                                 postDescription: widget.snap["description"],
  //                               )));
  //                 },
  //                 title: Text('Edit',
  //                     style: TextStyle(color: Color(0xFF000000), fontSize: 17)),
  //               ),
  //               ListTile(
  //                 onTap: () => deletePost(widget.snap["postId"]),
  //                 title: Text('Delete',
  //                     style: TextStyle(color: Color(0xFF000000), fontSize: 17)),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  bottomSheetforotherthreedot(context, String txt) {
    showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0),
      context: context,
      builder: (BuildContext c) {
        return Container(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 6),
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           InkWell(
                //             onTap: () {
                //               print('pressed');
                //               bottomSheetforshare(context, 'txt');
                //             },
                //             child: Container(
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   border: Border.all(
                //                     color: Colors.black87,
                //                   ),
                //                   borderRadius: BorderRadius.circular(25)),
                //               child: Padding(
                //                 padding: const EdgeInsets.all(15.0),
                //                 child: Icon(
                //                   FontAwesomeIcons.solidPaperPlane,
                //                   size: 18,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //             ),
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Text('Chat',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.w700,
                //                   color: Color(0xFF000000),
                //                   fontSize: 13,
                //                 )),
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(width: 18),
                //     GestureDetector(
                //       onTap: () async {
                //         print('tapped to generate link\n\n\n\n');
                //         String generatedDeepLink =
                //             await FirebaseDynamicLinksService.createDynamicLink(
                //                 widget.snap['postId'].toString());
                //         Share.share(
                //           generatedDeepLink,
                //         );
                //         print(generatedDeepLink.toString());
                //       },
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Container(
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   border: Border.all(
                //                     color: Colors.black87,
                //                   ),
                //                   borderRadius: BorderRadius.circular(25)),
                //               child: Padding(
                //                 padding: const EdgeInsets.all(15.0),
                //                 child: Icon(
                //                   FontAwesomeIcons.shareNodes,
                //                   size: 18,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text('Share',
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.w700,
                //                     color: Color(0xFF000000),
                //                     fontSize: 13,
                //                   )),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 18),
                //     GestureDetector(
                //       onTap: () async {
                //         Fluttertoast.showToast(
                //             msg: "Link Copied",
                //             toastLength: Toast.LENGTH_SHORT,
                //             gravity: ToastGravity.BOTTOM,
                //             timeInSecForIosWeb: 1,
                //             backgroundColor: Colors.black87,
                //             textColor: Colors.white,
                //             fontSize: 16.0);
                //
                //         String generatedDeepLink =
                //             await FirebaseDynamicLinksService.createDynamicLink(
                //                 widget.snap['postId'].toString());
                //         FlutterClipboard.copy(generatedDeepLink)
                //             .then((value) => print('copied'));
                //       },
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Container(
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   border: Border.all(
                //                     color: Colors.black87,
                //                   ),
                //                   borderRadius: BorderRadius.circular(25)),
                //               child: Padding(
                //                 padding: const EdgeInsets.all(15.0),
                //                 child: Icon(
                //                   FontAwesomeIcons.link,
                //                   size: 18,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text('Link',
                //                   style: TextStyle(
                //                       fontWeight: FontWeight.w700,
                //                       color: Color(0xFF000000),
                //                       fontSize: 13)),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Divider(thickness: 0.5, color: Colors.black12),
                ListTile(
                  onTap: () {
                    FireStoreMethods().uploadReportsOnPost(
                        widget.snap['postId'],
                        FirebaseAuth.instance.currentUser!.uid.toString(),
                        widget.snap['uid']);
                    Fluttertoast.showToast(
                        msg: "Post Reported ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black12,
                        textColor: Colors.white,
                        fontSize: 16);
                  },
                  title: Text('Report',
                      style: TextStyle(color: Colors.red, fontSize: 17)),
                ),
                // ListTile(
                //   title: Text('Delete',
                //       style: TextStyle(color: Color(0xFF000000), fontSize: 17)),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('ecommale')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Container(
        // boundary needed for web
        decoration: BoxDecoration(
          border: Border.all(
            color:
                width > webScreenSize ? secondaryColor : mobileBackgroundColor,
          ),
          color: mobileBackgroundColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 17,
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'].toString(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                      ),
                      child: Text(
                        widget.snap['username'].toString(),
                        style: TextStyle(
                            color: Color(0xFF1D1C1D),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: LikeAnimation(
                      isAnimating: widget.snap['saves'].contains(user.uid),
                      smallLike: true,
                      child: IconButton(
                          icon: widget.snap['saves'].contains(user.uid)
                              ? const Icon(
                                  FontAwesomeIcons.solidBookmark,
                                  color: Color(0xFF494949),
                                )
                              : const Icon(
                                  FontAwesomeIcons.bookmark,
                                  color: Color(0xFF494949),
                                ),
                          onPressed: () {
                            FireStoreMethods().SavedMenFashion(
                              widget.snap['postId'].toString(),
                              user.uid,
                              widget.snap['saves'],
                            );
                          }),
                    ),
                  ),
                  // widget.snap['uid'].toString() == user.uid
                  //     ? IconButton(
                  //         onPressed: () {
                  //           bottomSheetforownthreedot(context, "txt");
                  //           // showDialog(
                  //           //   useRootNavigator: false,
                  //           //   context: context,
                  //           //   builder: (context) {
                  //           //     return Dialog(
                  //           //       child: ListView(
                  //           //           padding: const EdgeInsets.symmetric(
                  //           //               vertical: 16),
                  //           //           shrinkWrap: true,
                  //           //           children: [
                  //           //             'Delete',
                  //           //             'Edit',
                  //           //             'Share..',
                  //           //             'Copy Link',
                  //           //             'Share',
                  //           //           ]
                  //           //               .map(
                  //           //                 (e) => InkWell(
                  //           //                     child: Container(
                  //           //                       padding: const EdgeInsets
                  //           //                               .symmetric(
                  //           //                           vertical: 12,
                  //           //                           horizontal: 16),
                  //           //                       child: Text(e),
                  //           //                     ),
                  //           //                     onTap: () {
                  //           //                       if (e == "Delete") {
                  //           //                         deletePost(
                  //           //                           widget.snap['postId']
                  //           //                               .toString(),
                  //           //                         );
                  //           //                       }
                  //           //                       // remove the dialog box
                  //           //                       Navigator.of(context).pop();
                  //           //                     }),
                  //           //               )
                  //           //               .toList()),
                  //           //     );
                  //           //   },
                  //           // );
                  //         },
                  //         icon: const Icon(FontAwesomeIcons.ellipsisVertical),
                  //       )
                  //     :
                  IconButton(
                    onPressed: () {
                      bottomSheetforotherthreedot(context, "txt");

                      // showDialog(
                      //   useRootNavigator: false,
                      //   context: context,
                      //   builder: (context) {
                      //     return Dialog(
                      //       child: ListView(
                      //           padding: const EdgeInsets.symmetric(
                      //               vertical: 16),
                      //           shrinkWrap: true,
                      //           children: [
                      //             'Share..',
                      //             'Copy Link',
                      //             'Share',
                      //           ]
                      //               .map(
                      //                 (e) => InkWell(
                      //                     child: Container(
                      //                       padding: const EdgeInsets
                      //                               .symmetric(
                      //                           vertical: 12,
                      //                           horizontal: 16),
                      //                       child: Text(e),
                      //                     ),
                      //                     onTap: () {
                      //                       if (e == "Delete") {
                      //                         deletePost(
                      //                           widget.snap['postId']
                      //                               .toString(),
                      //                         );
                      //                       }
                      //                       // remove the dialog box
                      //                       Navigator.of(context).pop();
                      //                     }),
                      //               )
                      //               .toList()),
                      //     );
                      //   },
                    },
                    icon: const Icon(FontAwesomeIcons.ellipsisVertical),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            // IMAGE SECTION OF THE POST
            GestureDetector(
              onDoubleTap: () {
                FireStoreMethods().likeMenfashion(
                  widget.snap['postId'].toString(),
                  user.uid,
                  widget.snap['likes'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowImage(
                              imageUrl: widget.snap['postUrl'].toString(),
                            )));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        widget.snap['postUrl'].toString(),
                        width: MediaQuery.of(context).size.width,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // LIKE, COMMENT SECTION OF THE POST
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  LikeAnimation(
                    isAnimating: widget.snap['likes'].contains(user.uid),
                    smallLike: true,
                    child: IconButton(
                      icon: widget.snap['likes'].contains(user.uid)
                          ? const Icon(
                              FontAwesomeIcons.solidHeart,
                              color: Colors.red,
                            )
                          : const Icon(
                              FontAwesomeIcons.heart,
                            ),
                      onPressed: () {
                        FireStoreMethods().likeMenfashion(
                          widget.snap['postId'].toString(),
                          user.uid,
                          widget.snap['likes'],
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                      onTap: () {
                        bottomSheetforshare(context, "txt");
                      },
                      child: Image.asset(
                        'images/share_icons.png',
                        height: 20,
                      )),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FashionCommentsScreen(
                          snap: widget.snap,
                          name: widget.snap['username'],
                          token: tokenpst,
                        ),
                      ),
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Comments',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            commentLen.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF797979)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Align(
                      child: const Icon(
                        FontAwesomeIcons.angleRight,
                        size: 30,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          snap: widget.snap,
                          token: tokenpst,
                          name: widget.snap['username'].toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //DESCRIPTION AND NUMBER OF COMMENTS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      bottomSheetforlike(
                          context, 'txt', (widget.snap['likes'] as List));
                    },
                    child: Text(
                      '${widget.snap['likes'].length} Likes',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 13,
                      color: Colors.black87,
                      width: 1,
                    ),
                  ),
                  Text(
                    'Shares',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),

                  // InkWell(
                  //   child: Container(
                  //     child: Text(
                  //       'View all $commentLen comments',
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //         color: secondaryColor,
                  //       ),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(vertical: 4),
                  //   ),
                  //   onTap: () => Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (context) => CommentsScreen(
                  //         postId: widget.snap['postId'].toString(),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   child: Text(
                  //     ),
                  //     style: const TextStyle(
                  //       color: secondaryColor,
                  //     ),
                  //   ),
                  //   padding: const EdgeInsets.symmetric(vertical: 4),
                  // ),
                ],
              ),
            ),
            Container(
              height: 230,
              color: Color(0xFFFFF2F2),
              padding: EdgeInsets.all(4),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('ecommale')
                    .doc(widget.snap['postId'])
                    .collection('items')
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
                    controller: ScrollController(),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          if (await canLaunch(
                              snapshot.data!.docs[index].data()['buyUrl'])) {
                            await launch(
                                snapshot.data!.docs[index].data()['buyUrl'],
                                enableDomStorage: true,
                                enableJavaScript: true,
                                forceWebView: true);
                          }
                        },
                        child: Container(
                          height: 197,
                          width: 129,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                        snapshot.data!.docs[index]
                                            .data()['itemimage'],
                                        height: 119,
                                        width: 120,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 4),
                                  child: Text(
                                    snapshot.data!.docs[index]
                                        .data()['itemname'],
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF1D1C1D),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Roboto'),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.fade,
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        snapshot.data!.docs[index]
                                            .data()['itemid'],
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF1D1C1D),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto'),
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        snapshot.data!.docs[index]
                                            .data()['itemPrice'],
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF9C969C),
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w700),
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        snapshot.data!.docs[index]
                                            .data()['itemdiscount'],
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFFFF1616),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto'),
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                      ),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 2),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (await canLaunch(snapshot
                                          .data!.docs[index]
                                          .data()['buyUrl'])) {
                                        await launch(
                                            snapshot.data!.docs[index]
                                                .data()['buyUrl'],
                                            enableDomStorage: true,
                                            enableJavaScript: true,
                                            forceWebView: true);
                                      }
                                    },
                                    child: Container(
                                      height: 27,
                                      width: 111,
                                      child: Center(
                                        child: Text(
                                          'Buy now',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: Color(0xFFFF1616),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void getDataOfChats(String userId) {
    chats
        .where("users", isEqualTo: {currentUid: null, userId: null})
        .limit(1)
        .get()
        .then((value) {
          if (value.docs.isNotEmpty) {
            chatDocId = value.docs.single.id.toString();
            onSendMessage(chatDocId);
          } else {
            chats.add({
              "users": {currentUid: null, userId: null}
            }).then((value) {
              chatDocId = value.toString();
              onSendMessage(chatDocId);
            });
          }
        });
  }

  void onSendMessage(String chatId) async {
    Map<String, dynamic> messages = {
      "sendby": currentUid,
      "message": widget.snap['postUrl'],
      "profImage": widget.snap['profImage'],
      "usenamepost": widget.snap['username'],
      "postId": widget.snap['postId'],
      "type": "sharedPost",
      "time": FieldValue.serverTimestamp(),
      "postDescription": widget.snap['description'],
    };

    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatId)
        .collection('chats')
        .add(messages)
        .whenComplete(() {});
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child:
            InteractiveViewer(panEnabled: true, child: Image.network(imageUrl)),
      ),
    );
  }
}
