import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/firestore_methods.dart';
import '../utils/colors.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final String postId;
  CommentCard({Key? key, required this.snap, required this.postId})
      : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool likedis = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    if ((widget.snap.data()['likes'] as List)
        .contains(FirebaseAuth.instance.currentUser!.uid.toString())) {
      likedis = true;
    } else {
      likedis = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.snap.data()['profilePic'],
                ),
                radius: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints.tightForFinite(
                      width: widget.snap.data()['text'].toString().length <= 30
                          ? 190
                          : 250),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: widget.snap.data()['name'],
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto'),
                        ),
                      ),
                      Text(
                          //TODO 1. import university data
                          widget.snap.data()['universityname'],
                          style: TextStyle(fontSize: 10, fontFamily: 'Roboto')),
                      SizedBox(
                        height: 10,
                      ),
                      ExpandableText(
                        '${widget.snap.data()['text']}',
                        expandText: 'show more',
                        collapseText: 'show less',
                        maxLines: 4,
                        linkColor: btnCOlorblue,
                        urlStyle: TextStyle(
                            color: Color(0xFF0035FF),
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            fontSize: 14),
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
                            fontSize: 15,
                            fontFamily: 'Roboto'),
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              FireStoreMethods().likeComment(
                widget.snap.data()['commentId'],
                FirebaseAuth.instance.currentUser!.uid.toString(),
                widget.snap.data()['likes'] as List,
                widget.postId,
              );
              setState(() {
                likedis = !likedis;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 56, top: 5),
              child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    likedis == true
                        ? Text(
                            'Liked',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue),
                          )
                        : Text(
                            'Like',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
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
                    likedis
                        ? Icon(
                            FontAwesomeIcons.solidHeart,
                            size: 15,
                            color: Colors.red,
                          )
                        : Icon(
                            FontAwesomeIcons.heart,
                            size: 15,
                            color: Colors.black54,
                          ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
