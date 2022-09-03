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

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
  var saved = {};
  bool isLoading = false;
  Uint8List? _file;
  File? file;

  bool isLsoading = true;

  bool isDispAllPost = true;
  bool isDispSavedPostt = false;

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
      saved = isFollowing = userSnap
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
                backgroundColor: Colors.white,
                body: ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 150.h,
                          color: Colors.grey.shade200,
                          width: double.infinity,
                          child: Image.network(
                            'https://www.insidesport.in/wp-content/uploads/2021/04/016_WM37_04102021CG_01753-290270b6e5fecca96e9e57bf0cb1fe50.jpg',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
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
                                              FontAwesomeIcons.plus,
                                              color: Colors.black,
                                              size: 18,
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
                            child: GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 18.r,
                                child: CircleAvatar(
                                    backgroundColor: Color(0xFFFFA100),
                                    child: Icon(
                                      Icons.create,
                                      color: Colors.white,
                                    ),
                                    radius: 16.r),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14, left: 20, right: 20, bottom: 4.5),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                userData['username'],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp),
                              ),
                              Text('Quantum University, Roorkee',
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.black)),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      fixedSize: Size.fromHeight(30),
                                      minimumSize: Size.zero,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      side: BorderSide(
                                          width: 1, color: Colors.black54),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.r))),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return Container(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          topLeft:
                                                              Radius.circular(
                                                                  5))),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 10,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Row(
                                                    children: [
                                                      Text('Name'),
                                                      Container(
                                                        width: 250,
                                                        child: TextFieldInput(
                                                            textEditingController:
                                                                _nameControlee,
                                                            hintText:
                                                                "change your name",
                                                            textInputType:
                                                                TextInputType
                                                                    .text),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text('Bio'),
                                                      Container(
                                                        width: 300,
                                                        child: TextFieldInput(
                                                            textEditingController:
                                                                bioCOntrolee,
                                                            hintText:
                                                                "change your name",
                                                            textInputType:
                                                                TextInputType
                                                                    .text),
                                                      ),
                                                    ],
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      final docRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(widget.uid);
                                                      final updates =
                                                          <String, dynamic>{
                                                        "username":
                                                            _nameControlee.text,
                                                        "bio": bioCOntrolee.text
                                                      };

                                                      docRef.update(updates).then(
                                                          (value) => print(
                                                              "DocumentSnapshot successfully updated!"),
                                                          onError: (e) => print(
                                                              "Error updating document $e"));
                                                    },
                                                    child: Text('Submit'),
                                                  )
                                                ]),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.create,
                                          color: Colors.black54,
                                          size: 15,
                                        ),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
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
                                      iconColor: Color(0xFF78CD00),
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
                                    ),
                          SizedBox(width: 9),
                          if (FirebaseAuth.instance.currentUser!.uid ==
                              widget.uid)
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return Container(
                                        color: Colors.black.withOpacity(0.1),
                                        child: Container(
                                          height: 250,
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
                                                  await AuthMethods().signOut();
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen(),
                                                    ),
                                                  );
                                                },
                                                title: Text('Logout'),
                                              )
                                            ]),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                FontAwesomeIcons.gear,
                                color: Colors.black54,
                              ),
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  userData['bio'],
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 11.sp, color: Colors.black54),
                                  maxLines: 5,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: btnCOlorblue,
                                      fixedSize: Size.fromWidth(90),
                                      side: BorderSide(
                                          width: 1.2, color: btnCOlorblue),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.r))),
                                  onPressed: () {},
                                  child: Text(
                                    userData['designation'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.sp,
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
                          height: 50.sp,
                          color: Colors.black54,
                          width: 1,
                        ),
                        Container(
                            width: 70.w,
                            child: Center(
                                child:
                                    buildStatColumn(followers, "Followers"))),
                        Container(
                          height: 50.sp,
                          color: Colors.black54,
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
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isDispAllPost = true;
                                  isDispSavedPostt = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.image,
                                  color: isDispAllPost
                                      ? Colors.black
                                      : Colors.black54,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                          if (FirebaseAuth.instance.currentUser!.uid ==
                              widget.uid)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isDispAllPost = false;
                                    isDispSavedPostt = true;
                                    print('saved pressed');
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    FontAwesomeIcons.solidBookmark,
                                    color: isDispSavedPostt
                                        ? Colors.black
                                        : Colors.black54,
                                    size: 21,
                                  ),
                                ),
                              ),
                            ),
                        ]),
                    Divider(height: 1, thickness: 1, color: Colors.black45),
                    if (isDispAllPost)
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
                            controller:
                                ScrollController(keepScrollOffset: true),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 1.5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 160),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      maxRadius: 12.r,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        userData['photoUrl'],
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      userData['username']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: 'Roboto'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Image.network(
                                                    snap['postUrl'],
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Material(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    LikeAnimation(
                                                      smallLike: true,
                                                      isAnimating: false,
                                                      child: IconButton(
                                                          icon: isLsoading
                                                              ? const Icon(
                                                                  FontAwesomeIcons
                                                                      .solidHeart,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : const Icon(
                                                                  FontAwesomeIcons
                                                                      .heart,
                                                                ),
                                                          onPressed: () {
                                                            setState(() {
                                                              !isLsoading;
                                                            });
                                                          }),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.comment_outlined,
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                    GestureDetector(
                                                        child: Image.asset(
                                                      'images/share_icons.png',
                                                      height: 20,
                                                    )),
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ),
                                        );
                                      });
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostProfileLinearDisplay(
                                                uid: snap['uid'],
                                              )));
                                },
                                child: Container(
                                  child: Image(
                                    image: NetworkImage(snap['postUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    if (isDispSavedPostt)
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .where('saves',
                                arrayContains:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return GridView.builder(
                            controller:
                                ScrollController(keepScrollOffset: true),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 1.5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 160),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      maxRadius: 12.r,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        userData['photoUrl'],
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      userData['username']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: 'Roboto'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Image.network(
                                                    snap['postUrl'],
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Material(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    LikeAnimation(
                                                      smallLike: true,
                                                      isAnimating: false,
                                                      child: IconButton(
                                                          icon: isLsoading
                                                              ? const Icon(
                                                                  FontAwesomeIcons
                                                                      .solidHeart,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : const Icon(
                                                                  FontAwesomeIcons
                                                                      .heart,
                                                                ),
                                                          onPressed: () {
                                                            setState(() {
                                                              !isLsoading;
                                                            });
                                                          }),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.comment_outlined,
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                    GestureDetector(
                                                        child: Image.asset(
                                                      'images/share_icons.png',
                                                      height: 20,
                                                    )),
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ),
                                        );
                                      });
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostProfileLinearDisplay(
                                                uid: snap['uid'],
                                              )));
                                },
                                child: Container(
                                  child: Image(
                                    image: NetworkImage(snap['postUrl']),
                                    fit: BoxFit.cover,
                                  ),
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

  void showAlertDialog() {
    Dialog();
    Alert(
      context: context,
      title: "Enter a valid email",
      style: AlertStyle(
          descStyle: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
          descTextAlign: TextAlign.justify),
      desc: "Please enter your college domain email id "
          "or the email reistered by you in your college",
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: Colors.black,
        )
      ],
    ).show();
  }

  OverlayEntry _createPopUp(String postUrl) {
    return OverlayEntry(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 160),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    maxRadius: 12.r,
                    backgroundImage: NetworkImage(
                      userData['photoUrl'],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    userData['username'].toString(),
                    style: TextStyle(color: Colors.black, fontSize: 18.sp),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Image.network(
                  postUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LikeAnimation(
                    smallLike: true,
                    isAnimating: false,
                    child: IconButton(
                        icon: isLsoading
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                        onPressed: () {
                          setState(() {
                            !isLsoading;
                          });
                        }),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.comment_outlined,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.share,
                      ),
                      onPressed: () {}),
                ],
              ),
            )
          ]),
        ),
      ),
    );
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
