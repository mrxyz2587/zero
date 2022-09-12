import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:zero_fin/resources/storage_methods.dart';
import 'package:zero_fin/screens/profile_posts_display.dart';
import 'package:zero_fin/widgets/text_field_input.dart';
import '../providers/user_provider.dart';
import '../widgets/like_animation.dart';
import '../widgets/post_card.dart';
import '/resources/auth_methods.dart';
import '/resources/firestore_methods.dart';
import '/screens/login_screen.dart';
import '/utils/colors.dart';
import 'package:file_picker/file_picker.dart';

import '/utils/utils.dart';
import '/widgets/follow_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostProfileLinearDisplay extends StatefulWidget {
  final String uid;
  const PostProfileLinearDisplay({Key? key, required this.uid})
      : super(key: key);

  @override
  _PostProfileLinearDisplayState createState() =>
      _PostProfileLinearDisplayState();
}

class _PostProfileLinearDisplayState extends State<PostProfileLinearDisplay> {
  var userData = {};
  var name;
  OverlayEntry? _popupDialog;
  final TextEditingController _nameControlee = TextEditingController();
  final TextEditingController bioCOntrolee = TextEditingController();
  var postData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  Uint8List? _file;
  File? file;

  bool isLsoading = true;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postisSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      postData = postisSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.grey.shade300,
              strokeWidth: 1.5,
            )),
          )
        : ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return Scaffold(
                appBar: AppBar(
                    elevation: 2,
                    titleSpacing: 0,
                    title: Text('Posts',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                            fontSize: 19)),
                    backgroundColor: Colors.white,
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
                    )),
                backgroundColor: Colors.white,
                body: ListView(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                          controller: ScrollController(keepScrollOffset: true),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return PostCard(
                              snap: snap,
                              onshareingbtnPressed: () {},
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            });
  }
}
