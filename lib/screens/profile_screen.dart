import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_fin/resources/storage_methods.dart';
import '../widgets/post_card.dart';
import '/resources/auth_methods.dart';
import '/resources/firestore_methods.dart';
import '/screens/login_screen.dart';
import '/utils/colors.dart';
import 'package:file_picker/file_picker.dart';

import '/utils/utils.dart';
import '/widgets/follow_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var name;

  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  Uint8List? _file;
  File? file;

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

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
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
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 170.h,
                          color: Colors.grey.shade200,
                          width: double.infinity,
                          child: Image.network(
                            'https://www.insidesport.in/wp-content/uploads/2021/04/016_WM37_04102021CG_01753-290270b6e5fecca96e9e57bf0cb1fe50.jpg',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                          ),
                        ),
                        Positioned(
                          left: 20.w,
                          top: 20.h,
                          bottom: 20.h,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 53.r,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  maxRadius: 50.r,
                                  backgroundImage: NetworkImage(
                                    userData['photoUrl'],
                                  ),
                                ),
                                if (FirebaseAuth.instance.currentUser!.uid ==
                                    widget.uid)
                                  Positioned(
                                      right: 0,
                                      bottom: 5,
                                      child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Center(
                                            child: Icon(
                                              Icons.add_rounded,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          ),
                                          radius: 12)),
                              ],
                            ),
                          ),
                        ),
                        if (FirebaseAuth.instance.currentUser!.uid ==
                            widget.uid)
                          Positioned(
                            right: 20.w,
                            top: 15.h,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20.r,
                              child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  child: Icon(
                                    Icons.create,
                                    color: Colors.white,
                                  ),
                                  radius: 18.r),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['username'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp),
                              ),
                              Text('Quantum University, Roorkee',
                                  style: TextStyle(fontSize: 12.sp)),
                            ],
                          ),
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: 1, color: Colors.black26),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.r))),
                                  onPressed: () {},
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.create,
                                        color: Colors.black45,
                                        size: 18,
                                      ),
                                      Text(
                                        'Edit',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                )

                              // FollowButton(
                              //   text: 'Sign Out',
                              //   backgroundColor: mobileBackgroundColor,
                              //   textColor: primaryColor,
                              //   borderColor: Colors.grey,
                              //   function: () async {
                              //     await AuthMethods().signOut();
                              //     Navigator.of(context).pushReplacement(
                              //       MaterialPageRoute(
                              //         builder: (context) => const LoginScreen(),
                              //       ),
                              //     );
                              //   },
                              // )
                              : isFollowing
                                  ? FollowButton(
                                      iconData: FontAwesomeIcons.userCheck,
                                      iconColor: Colors.lightGreenAccent,
                                      function: () async {
                                        await FireStoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );

                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                    )
                                  : FollowButton(
                                      iconColor: Colors.black54,
                                      iconData: FontAwesomeIcons.userPlus,
                                      function: () async {
                                        await FireStoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );

                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                    )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 16.w),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Text(
                              userData['bio'],
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black54),
                              maxLines: 5,
                            ),
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: 1.2, color: Colors.lightBlue),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.r))),
                                onPressed: () {},
                                child: Text(
                                  userData['designation'],
                                  style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 40.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 70.w,
                            child: Center(
                                child: buildStatColumn(postLen, "Posts"))),
                        Container(
                          height: 60.sp,
                          color: Colors.black,
                          width: 1,
                        ),
                        Container(
                            width: 70.w,
                            child: Center(
                                child:
                                    buildStatColumn(followers, "Followers"))),
                        Container(
                          height: 60.sp,
                          color: Colors.black,
                          width: 1,
                        ),
                        Container(
                            width: 70.w,
                            child: Center(
                                child:
                                    buildStatColumn(following, "Following"))),
                      ],
                    ),
                    SizedBox(
                      height: 25.sp,
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.black45),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ]),
                    Divider(height: 1, thickness: 1, color: Colors.black45),
                    SizedBox(
                      height: 5.sp,
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return GridView.builder(
                          controller: ScrollController(keepScrollOffset: true),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 0.5,
                            mainAxisSpacing: 0.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return Container(
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
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

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          child: Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
