import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:zero_fin/screens/profile_screen.dart';

import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../widgets/comment_card.dart';

class GroupPostCommentsScreen extends StatefulWidget {
  final String msgId;
  final String collectionId;
  final map;
  GroupPostCommentsScreen(
      {Key? key,
      required this.collectionId,
      required this.msgId,
      required this.map})
      : super(key: key);

  @override
  State<GroupPostCommentsScreen> createState() =>
      _GroupPostCommentsScreenState();
}

class _GroupPostCommentsScreenState extends State<GroupPostCommentsScreen> {
  final commentEditingController = TextEditingController();
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
                ListTile(
                  onTap: () {
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

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xF4FCFCFC),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => bottomSheetforotherthreedot(context, 'txt'),
              icon: Icon(
                FontAwesomeIcons.ellipsisVertical,
                color: Colors.black45,
              ))
        ],
        elevation: 2,
        leading: IconButton(
          padding: EdgeInsets.only(right: 0),
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            size: 25,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: mobileBackgroundColor,
        title: const Text('Discussions',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000),
                fontSize: 19)),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(widget.collectionId)
            .doc(widget.msgId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.5,
            ));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) {
              Map<String, dynamic> map =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              backgroundImage: NetworkImage(map['profilePic']),
                              radius: 15),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileScreen(uid: map['uid'])));
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: map['name'],
                                    style: TextStyle(
                                      color: Color(0xFF434343),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileScreen(uid: map['uid'])));
                                },
                                child: Text(
                                    //TODO 1. import university data
                                    map['universityname'],
                                    style: TextStyle(
                                        fontSize: 10, fontFamily: 'Roboto')),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: ExpandableText(
                          '${map['text']}',
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 4,
                          linkColor: btnCOlorblue,
                          urlStyle: TextStyle(
                              color: Color(0xFF0035FF),
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              fontSize: 16),
                          onUrlTap: (url) async {
                            if (url.contains("https://")) {
                              if (await canLaunch(url)) {
                                await launch(url);
                              }
                            } else {
                              if (await canLaunch("https://" + url)) {
                                await launch("https://" + url);
                              }
                            }
                          },
                          textAlign: TextAlign.left,
                          // text: TextSpan(
                          //   text: ' ${widget.snap['description']}',
                          style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 17,
                              fontFamily: 'Roboto'),
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          color: Colors.white,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userProvider.getUser.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 17),
                      hintText: 'Type your message here....',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                    userProvider.getUser.university.toString()),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'POST',
                    style: TextStyle(
                        color: btnCOlorblue, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void postComment(
      String uid, String name, String profilePic, String universityname) async {
    String commentId = const Uuid().v1();

    Map<String, dynamic> messages = {
      'profilePic': profilePic,
      'name': name,
      'uid': uid,
      'text': commentEditingController.text,
      'commentId': commentId,
      'datePublished': DateTime.now(),
      'universityname': universityname,
    };

    await FirebaseFirestore.instance
        .collection(widget.collectionId)
        .doc(widget.msgId)
        .collection('comments')
        .add(messages);

    commentEditingController.clear();
  }
}
