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

class CommentsScreen extends StatefulWidget {
  final snap;
  final String name;
  final String token;
  const CommentsScreen(
      {Key? key, required this.snap, required this.token, required this.name})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(
      String uid, String name, String profilePic, String universityname) async {
    try {
      String res = await FireStoreMethods().postComment(
          widget.snap['postId'],
          commentEditingController.text,
          uid,
          name,
          profilePic,
          sendNotification('${name} commented on your post', widget.token),
          universityname);
      FireStoreMethods().updateNotifications(
          widget.snap['uid'],
          name,
          'commented',
          widget.snap['postId'].toString(),
          widget.snap['likes'],
          uid,
          profilePic);
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

  sendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAdVXFb4U:APA91bHPFxenxhJYUOgnxYUqRsIWGhpjxkxG_1p8VLBsaHjDlOwN9deEwDjs4O1I-ytIOaOajx6k0dzQ3mTaT4VBUB6LDRA_kKscvqomy_ps59Q0y-nBcKqaaanNeBY17Dy2VlCs-qvR'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': widget.name.toString(),
                  'body': 'This betichod commented on your post'
                },
                'priority': 'high',
                'data': data,
                'to': token
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
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
            .collection('posts')
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
                final postpersonId = await FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.snap['postId'])
                    .get();

                if (snapshot.data!.docs[index].data()['uid'] ==
                        user.uid.toString() ||
                    postpersonId.data()!['uid'].toString() ==
                        user.uid.toString()) {
                  await FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.snap['postId'])
                      .collection('comments')
                      .doc(snapshot.data!.docs[index].data()['commentId'])
                      .delete();
                }
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
