import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/local_notification_services.dart';
import '/models/user.dart';
import '/providers/user_provider.dart';
import '/resources/firestore_methods.dart';
import '/utils/colors.dart';
import '/utils/utils.dart';
import '/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class FashionCommentsScreen extends StatefulWidget {
  final snap;
  final String name;
  final String token;
  const FashionCommentsScreen(
      {Key? key, required this.snap, required this.token, required this.name})
      : super(key: key);

  @override
  _FashionCommentsScreenState createState() => _FashionCommentsScreenState();
}

class _FashionCommentsScreenState extends State<FashionCommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(
      String uid, String name, String profilePic, String universityname) async {
    try {
      String res = await FireStoreMethods().postCommentMensFashion(
          widget.snap['postId'],
          commentEditingController.text,
          uid,
          name,
          profilePic,
          universityname);
      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: Color(0xF4FCFCFC),
      appBar: AppBar(
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
        title: const Text('Comments',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000),
                fontSize: 19)),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ecommale')
            .doc(widget.snap['postId'].toString())
            .collection('comments')
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
            itemBuilder: (ctx, index) => GestureDetector(
              onLongPress: () async {
                showModalBottomSheet(
                    context: context,
                    enableDrag: true,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (BuildContext ctx) {
                      return Container(
                        color: Colors.black.withOpacity(0.1),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5))),
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              ListTile(
                                onTap: () async {
                                  final postpersonId = await FirebaseFirestore
                                      .instance
                                      .collection('ecommale')
                                      .doc(widget.snap['postId'])
                                      .get();

                                  if (snapshot.data!.docs[index]
                                              .data()['uid'] ==
                                          user.uid.toString() ||
                                      postpersonId.data()!['uid'].toString() ==
                                          user.uid.toString()) {
                                    await FirebaseFirestore.instance
                                        .collection('ecommale')
                                        .doc(widget.snap['postId'])
                                        .collection('comments')
                                        .doc(snapshot.data!.docs[index]
                                            .data()['commentId'])
                                        .delete();
                                  }
                                },
                                title: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    });
              },
              child: CommentCard(
                snap: snapshot.data!.docs[index],
                postId: widget.snap['postId'],
              ),
            ),
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
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: 'Comment as ${user.username}...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(user.uid, user.username, user.photoUrl,
                    user.university.toString()),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'POST',
                    style: TextStyle(
                        color: btnCOlorblue, fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
