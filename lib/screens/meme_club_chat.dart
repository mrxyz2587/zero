import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:zero_fin/screens/group_post_comments_screen.dart';
import 'package:zero_fin/screens/group_post_screen.dart';
import 'package:zero_fin/screens/profile_screen.dart';
import 'dart:math' as math;

import '../providers/user_provider.dart';
import '../utils/colors.dart';

class MemeClubChatScreen extends StatefulWidget {
  String usernamecurrent;
  MemeClubChatScreen({Key? key, required this.usernamecurrent})
      : super(key: key);

  @override
  State<MemeClubChatScreen> createState() => _MemeClubChatScreenState();
}

class _MemeClubChatScreenState extends State<MemeClubChatScreen>
    with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool emojiShowing = false;

  // void onSendMessage() async {
  //   if (_message.text.isNotEmpty) {
  //     Map<String, dynamic> messages = {
  //       "sendby": _auth.currentUser!.uid,
  //       "message": _message.text,
  //       "type": "text",
  //       "time": FieldValue.serverTimestamp(),
  //       "sendername": widget.usernamecurrent
  //     };
  //
  //     _message.clear();
  //     await FirebaseFirestore.instance
  //         .collection('startupclubchat')
  //         .add(messages)
  //         .whenComplete(() {
  //       print('message added');
  //       // sendNotification("Sended you a message", widget.token);
  //     });
  //   } else {
  //     print("Enter Some Text");
  //   }
  // }

  int commentLen = 0;

  Widget messages(
    Size size,
    Map<String, dynamic> map,
    BuildContext context,
    String chatId,
  ) {
    // FirebaseFirestore.instance
    //     .collection('startupclubchat')
    //     .doc(map['msgId'])
    //     .collection('comments')
    //     .get()
    //     .then((value) {
    //   commentLen = value.docs.length;
    //   print('comment lenght' + commentLen.toString());
    // });
    return map['type'] == "text"
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GroupPostCommentsScreen(
                      collectionId: 'memeclubchat',
                      msgId: map['msgId'],
                      map: map)));

              if (map['sendby'] == _auth.currentUser!.uid)
              //TODO abh1: Add dialog ui and a warning message that says
              // if you delete the message it will be permanently deleted
              {
                // await _firestore
                //     .collection('chatroom')
                //     .doc(chatDocId)
                //     .collection('chats')
                //     .doc(chatId)
                //     .delete();
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundImage: NetworkImage(map['userimg']),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        uid: map['sendby'],
                                      )));
                            },
                            child: Text(
                              map['sendername'],
                              style: TextStyle(
                                color: Color(0xFF434343),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 23,
                            width: 49,
                            decoration: BoxDecoration(
                                color: Color(0xFFF9EDBB),
                                borderRadius: BorderRadius.circular(22)),
                            child: Center(
                              child: Text(
                                'New',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 11),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        map['title'],
                        style: TextStyle(
                            color: Color(0xff151515),
                            fontSize: 17,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            height: 1.3),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ExpandableText(
                        ' ${map['subtitle']}',
                        expandText: '',
                        collapseText: '',
                        maxLines: 3,
                        urlStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B57A4),
                            fontSize: 14),
                        onUrlTap: (url) async {
                          if (url.contains("https://www.")) {
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          } else if (!url.contains("https://www.")) {
                            if (await canLaunch("https://www." + url)) {
                              await launch("https://www." + url);
                            }
                          } else if (url.contains("https://") &&
                              !url.contains("https://www.")) {
                            if (await canLaunch("www." + url)) {
                              await launch("www." + url);
                            }
                          } else if (!url.contains("https://") &&
                              url.contains("www.")) {
                            if (await canLaunch("https://" + url)) {
                              await launch("https://" + url);
                            }
                          }
                        },

                        textAlign: TextAlign.justify,
                        // text: TextSpan(
                        //   text: ' ${widget.snap['description']}',
                        style: TextStyle(
                          color: Color(0xff151515),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                        ),
                        // ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                          height: 1.5, color: Colors.black12, thickness: 1.2),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              '${math.Random().nextInt(20)}' + ' participants',
                              style: TextStyle(
                                color: Colors.black87,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        GroupPostCommentsScreen(
                                            collectionId: 'memeclubchat',
                                            msgId: map['msgId'],
                                            map: map)));
                              },
                              child: Text(
                                'Start Discussion',
                                style: TextStyle(
                                  color: Color(0xFF350ACD),
                                ),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            FontAwesomeIcons.angleRight,
                            size: 20,
                            color: Color(0xFF350ACD),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  )

                  // ChatBubble(
                  //   elevation: 0,
                  //   clipper: map['sendby'] == _auth.currentUser!.uid
                  //       ? ChatBubbleClipper1(
                  //           type: BubbleType.sendBubble,
                  //           radius: 10,
                  //           nipHeight: 8,
                  //           nipWidth: 8)
                  //       : ChatBubbleClipper1(
                  //           type: BubbleType.receiverBubble,
                  //           radius: 10,
                  //           nipHeight: 8,
                  //           nipWidth: 8),
                  //   alignment: map['sendby'] == _auth.currentUser!.uid
                  //       ? Alignment.centerRight
                  //       : Alignment.centerLeft,
                  //   margin: EdgeInsets.only(top: 6),
                  //   backGroundColor: map['sendby'] == _auth.currentUser!.uid
                  //       ? btnCOlorblue
                  //       : Colors.white,
                  //   child: Container(
                  //     constraints: BoxConstraints(
                  //       maxWidth: MediaQuery.of(context).size.width * 0.7,
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             Navigator.of(context).push(MaterialPageRoute(
                  //                 builder: (context) => ProfileScreen(
                  //                       uid: map['sendby'],
                  //                     )));
                  //           },
                  //           child: Text(
                  //             map['sendername'],
                  //             style: TextStyle(
                  //                 color: map['sendby'] == _auth.currentUser!.uid
                  //                     ? Colors.white
                  //                     : Color(0xFF0B57A4),
                  //                 fontSize: 12),
                  //             softWrap: true,
                  //             overflow: TextOverflow.fade,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           height: 3,
                  //         ),
                  //         ExpandableText(map['message'],
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //               color: map['sendby'] == _auth.currentUser!.uid
                  //                   ? Colors.white
                  //                   : Colors.black87,
                  //             ),
                  //             expandText: 'more',
                  //             collapseText: 'hide',
                  //             linkColor: Colors.grey,
                  //             maxLines: 15,
                  //             urlStyle: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Color(0xFF0B57A4),
                  //                 fontSize: 14), onUrlTap: (url) async {
                  //           if (url.contains("https://www.")) {
                  //             if (await canLaunch(url)) {
                  //               await launch(url);
                  //             }
                  //           } else if (!url.contains("https://www.")) {
                  //             if (await canLaunch("https://www." + url)) {
                  //               await launch("https://www." + url);
                  //             }
                  //           } else if (url.contains("https://") &&
                  //               !url.contains("https://www.")) {
                  //             if (await canLaunch("www." + url)) {
                  //               await launch("www." + url);
                  //             }
                  //           } else if (!url.contains("https://") &&
                  //               url.contains("www.")) {
                  //             if (await canLaunch("https://" + url)) {
                  //               await launch("https://" + url);
                  //             }
                  //           }
                  //         }),
                  //         SizedBox(
                  //           height: 3,
                  //         ),
                  //         Text(
                  //           map['time'] == null
                  //               ? "sending...."
                  //               : DateFormat.jm()
                  //                   .format(map['time'].toDate())
                  //                   .toString(),
                  //           style: TextStyle(
                  //               fontSize: 9,
                  //               fontStyle: FontStyle.italic,
                  //               color: Colors.grey.shade700),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  /*
                *
                *
                * */
                  // child: Container(
                  //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  //   margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(15),
                  //     color: btnCOlorblue,
                  //   ),
                  //   child: Text(
                  //     map['message'],
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  ),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GroupPostCommentsScreen(
                      collectionId: 'memeclubchat',
                      msgId: map['msgId'],
                      map: map)));

              if (map['sendby'] == _auth.currentUser!.uid)
              //TODO abh1: Add dialog ui and a warning message that says
              // if you delete the message it will be permanently deleted
              {
                // await _firestore
                //     .collection('chatroom')
                //     .doc(chatDocId)
                //     .collection('chats')
                //     .doc(chatId)
                //     .delete();
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundImage: NetworkImage(map['userimg']),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        uid: map['sendby'],
                                      )));
                            },
                            child: Text(
                              map['sendername'],
                              style: TextStyle(
                                color: Color(0xFF434343),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 23,
                            width: 49,
                            decoration: BoxDecoration(
                                color: Color(0xFFF9EDBB),
                                borderRadius: BorderRadius.circular(22)),
                            child: Center(
                              child: Text(
                                'New',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 11),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        map['title'],
                        style: TextStyle(
                            color: Color(0xff151515),
                            fontSize: 17,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            height: 1.3),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 250,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              map['subtitle'],
                              height: 250,
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                          height: 1.5, color: Colors.black12, thickness: 1.2),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              '${math.Random().nextInt(20)}' + ' participants',
                              style: TextStyle(
                                color: Colors.black87,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        GroupPostCommentsScreen(
                                            collectionId: 'memeclubchat',
                                            msgId: map['msgId'],
                                            map: map)));
                              },
                              child: Text(
                                'Start Discussion',
                                style: TextStyle(
                                  color: Color(0xFF350ACD),
                                ),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            FontAwesomeIcons.angleRight,
                            size: 20,
                            color: Color(0xFF350ACD),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  )

                  // ChatBubble(
                  //   elevation: 0,
                  //   clipper: map['sendby'] == _auth.currentUser!.uid
                  //       ? ChatBubbleClipper1(
                  //           type: BubbleType.sendBubble,
                  //           radius: 10,
                  //           nipHeight: 8,
                  //           nipWidth: 8)
                  //       : ChatBubbleClipper1(
                  //           type: BubbleType.receiverBubble,
                  //           radius: 10,
                  //           nipHeight: 8,
                  //           nipWidth: 8),
                  //   alignment: map['sendby'] == _auth.currentUser!.uid
                  //       ? Alignment.centerRight
                  //       : Alignment.centerLeft,
                  //   margin: EdgeInsets.only(top: 6),
                  //   backGroundColor: map['sendby'] == _auth.currentUser!.uid
                  //       ? btnCOlorblue
                  //       : Colors.white,
                  //   child: Container(
                  //     constraints: BoxConstraints(
                  //       maxWidth: MediaQuery.of(context).size.width * 0.7,
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             Navigator.of(context).push(MaterialPageRoute(
                  //                 builder: (context) => ProfileScreen(
                  //                       uid: map['sendby'],
                  //                     )));
                  //           },
                  //           child: Text(
                  //             map['sendername'],
                  //             style: TextStyle(
                  //                 color: map['sendby'] == _auth.currentUser!.uid
                  //                     ? Colors.white
                  //                     : Color(0xFF0B57A4),
                  //                 fontSize: 12),
                  //             softWrap: true,
                  //             overflow: TextOverflow.fade,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           height: 3,
                  //         ),
                  //         ExpandableText(map['message'],
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //               color: map['sendby'] == _auth.currentUser!.uid
                  //                   ? Colors.white
                  //                   : Colors.black87,
                  //             ),
                  //             expandText: 'more',
                  //             collapseText: 'hide',
                  //             linkColor: Colors.grey,
                  //             maxLines: 15,
                  //             urlStyle: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Color(0xFF0B57A4),
                  //                 fontSize: 14), onUrlTap: (url) async {
                  //           if (url.contains("https://www.")) {
                  //             if (await canLaunch(url)) {
                  //               await launch(url);
                  //             }
                  //           } else if (!url.contains("https://www.")) {
                  //             if (await canLaunch("https://www." + url)) {
                  //               await launch("https://www." + url);
                  //             }
                  //           } else if (url.contains("https://") &&
                  //               !url.contains("https://www.")) {
                  //             if (await canLaunch("www." + url)) {
                  //               await launch("www." + url);
                  //             }
                  //           } else if (!url.contains("https://") &&
                  //               url.contains("www.")) {
                  //             if (await canLaunch("https://" + url)) {
                  //               await launch("https://" + url);
                  //             }
                  //           }
                  //         }),
                  //         SizedBox(
                  //           height: 3,
                  //         ),
                  //         Text(
                  //           map['time'] == null
                  //               ? "sending...."
                  //               : DateFormat.jm()
                  //                   .format(map['time'].toDate())
                  //                   .toString(),
                  //           style: TextStyle(
                  //               fontSize: 9,
                  //               fontStyle: FontStyle.italic,
                  //               color: Colors.grey.shade700),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  /*
                *
                *
                * */
                  // child: Container(
                  //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  //   margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(15),
                  //     color: btnCOlorblue,
                  //   ),
                  //   child: Text(
                  //     map['message'],
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  ),
            ),
          );
  }

  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    focusNode?.addListener(() {});
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  File? imageFile;

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore.collection('memeclubchat').doc(fileName).set({
      "sendby": _auth.currentUser!.uid,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
      "sendername": widget.usernamecurrent
    });

    var ref = FirebaseStorage.instance
        .ref()
        .child('imagesstartup')
        .child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore.collection('startupclubchat').doc(fileName).delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('startupclubchat')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker
        .pickImage(source: ImageSource.gallery, imageQuality: 5)
        .then((xFile) {
      if (xFile != null) {
        imageFile = File(
          xFile.path,
        );
        uploadImage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        centerTitle: true,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(20),
        //   ),
        // ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'Meme Club',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                height: 0.6),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            size: 22,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => const AlertDialog(
                      title: Text(
                        'Rules of the Group',
                        style: TextStyle(
                            color: blueColor, fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                          'Please do not share pornographic content or abusive content'),
                      // actions: <Widget>[
                      //   TextButton(
                      //     onPressed: () => Navigator.pop(context, 'Cancel'),
                      //     child: const Text('Cancel'),
                      //   ),
                      //   TextButton(
                      //     onPressed: () => Navigator.pop(context, 'OK'),
                      //     child: const Text('OK'),
                      //   ),
                      // ],
                    ),
                  ),
              icon: Icon(
                FontAwesomeIcons.circleInfo,
                color: Colors.black45,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
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
                    text: 'My Discussion',
                  )
                ],
              ),
            ),

            SizedBox(
              height: 8,
            ),

            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('memeclubchat')
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.blue,
                          strokeWidth: 5.5,
                        ));
                      }
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            print(snapshot.data!.docs[index].data().toString());

                            return messages(
                              size,
                              map,
                              context,
                              snapshot.data!.docs[index].id.toString(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('memeclubchat')
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.blue,
                          strokeWidth: 5.5,
                        ));
                      }
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            print(snapshot.data!.docs[index].data().toString());

                            return map['sendby'] == userProvider.getUser.uid
                                ? messages(
                                    size,
                                    map,
                                    context,
                                    snapshot.data!.docs[index].id.toString(),
                                  )
                                : Container();
                          },
                        ),
                      );
                    },
                  ),
                ],
                controller: tabController,
              ),
            )
            // Container(
            //   width: size.width,
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     constraints: BoxConstraints(
            //       maxHeight: 150,
            //       minHeight: size.height / 15.5,
            //     ),
            //     width: size.width,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(20),
            //             topRight: Radius.circular(20))),
            //     child: Container(
            //       padding: EdgeInsets.zero,
            //       width: size.width,
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: <Widget>[
            //           Padding(
            //             padding: const EdgeInsets.only(left: 18.0),
            //             child: GestureDetector(
            //                 onTap: () {
            //                   print("ema");
            //                   setState(() {
            //                     emojiShowing = !emojiShowing;
            //                     if (emojiShowing == true) {
            //                       focusNode?.unfocus();
            //                     } else {
            //                       focusNode?.requestFocus();
            //                     }
            //                   });
            //                 },
            //                 child: emojiShowing == true
            //                     ? Icon(CupertinoIcons.keyboard)
            //                     : Icon(CupertinoIcons.smiley_fill)),
            //           ),
            //           Expanded(
            //             child: TextField(
            //               focusNode: focusNode,
            //               controller: _message,
            //               onTap: () {
            //                 print("tapped");
            //                 focusNode?.requestFocus();
            //                 emojiShowing = false;
            //               },
            //               minLines: 1,
            //               maxLines: 50,
            //               keyboardType: TextInputType.multiline,
            //               decoration: InputDecoration(
            //                 contentPadding: EdgeInsets.symmetric(
            //                     vertical: 10.0, horizontal: 20.0),
            //                 hintMaxLines: 1,
            //                 hintText: 'Message...',
            //                 border: InputBorder.none,
            //               ),
            //             ),
            //           ),
            //           Row(children: [
            //             // IconButton(
            //             //   onPressed: () {},
            //             //   icon: Icon(
            //             //     CupertinoIcons.mic_fill,
            //             //     size: 22,
            //             //   ),
            //             // ),
            //             IconButton(
            //               icon: Icon(
            //                 FontAwesomeIcons.solidImage,
            //                 size: 20,
            //               ),
            //               onPressed: () => getImage(),
            //             ),
            //             SizedBox(
            //               width: 5,
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.fromLTRB(0, 8, 14, 8),
            //               child: SizedBox(
            //                 height: 40,
            //                 width: 40,
            //                 child: DecoratedBox(
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(25),
            //                     color: btnCOlorblue,
            //                   ),
            //                   child: Container(
            //                     child: Transform.rotate(
            //                       angle: 45 * math.pi / 180,
            //                       child: IconButton(
            //                           icon: Icon(
            //                             FontAwesomeIcons.solidPaperPlane,
            //                             color: Colors.white,
            //                             size: 15,
            //                           ),
            //                           onPressed: () {
            //                             onSendMessage();
            //                           }),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ])
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Offstage(
            //   offstage: !emojiShowing,
            //   child: SizedBox(
            //       height: 250,
            //       child: EmojiPicker(
            //         textEditingController: _message,
            //         onBackspacePressed: () {
            //           Navigator.pop(context);
            //         },
            //         config: Config(
            //           columns: 7,
            //           // Issue: https://github.com/flutter/flutter/issues/28894
            //           verticalSpacing: 0,
            //           horizontalSpacing: 0,
            //           emojiSizeMax: 32,
            //           gridPadding: EdgeInsets.zero,
            //           initCategory: Category.RECENT,
            //           bgColor: const Color(0xFFF2F2F2),
            //           indicatorColor: Colors.blue,
            //           iconColor: Colors.grey,
            //           iconColorSelected: Colors.blue,
            //           backspaceColor: Colors.blue,
            //           skinToneDialogBgColor: Colors.white,
            //           skinToneIndicatorColor: Colors.grey,
            //           enableSkinTones: true,
            //           showRecentsTab: true,
            //           recentsLimit: 28,
            //           replaceEmojiOnLimitExceed: false,
            //           noRecents: const Text(
            //             'No Recents',
            //             style: TextStyle(fontSize: 20, color: Colors.black26),
            //             textAlign: TextAlign.center,
            //           ),
            //           loadingIndicator: const SizedBox.shrink(),
            //           tabIndicatorAnimDuration: kTabScrollDuration,
            //           categoryIcons: const CategoryIcons(),
            //           buttonMode: ButtonMode.MATERIAL,
            //           checkPlatformCompatibility: true,
            //         ),
            //       )),
            // ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GroupPostingScreen(
                      collectionname: 'memeclubchat',
                      clubName: 'Meme Club',
                      currentUserImg: userProvider.getUser.photoUrl,
                      currentUsername: userProvider.getUser.username,
                    )));
          },
          backgroundColor: Color(0xFA0484C4),
          child: Icon(
            Icons.add_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.black,
          ),
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}

class DialogExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
          title: Text(
            'Rules of the Group',
            style: TextStyle(color: blueColor, fontWeight: FontWeight.bold),
          ),
          content: Text('AlertDialog description'),
          // actions: <Widget>[
          //   TextButton(
          //     onPressed: () => Navigator.pop(context, 'Cancel'),
          //     child: const Text('Cancel'),
          //   ),
          //   TextButton(
          //     onPressed: () => Navigator.pop(context, 'OK'),
          //     child: const Text('OK'),
          //   ),
          // ],
        ),
      ),
      child: const Text(
        'Startup Club',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700, fontSize: 23),
      ),
    );
  }
}
