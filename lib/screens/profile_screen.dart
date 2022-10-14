import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:zero_fin/resources/storage_methods.dart';
import 'package:zero_fin/screens/profile_posts_display.dart';
import 'package:zero_fin/widgets/text_field_input.dart';
import '../providers/user_provider.dart';
import '../widgets/like_animation.dart';
import '../widgets/videoplayersearch.dart';
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

enum options { POSTS, QUOTE, SAVED }

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var name;
  OverlayEntry? _popupDialog;
  // final TextEditingController _nameControl ee = TextEditingController();
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

  final _controllername = TextEditingController();
  String quoteImageUrl = "";
  @override
  void initState() {
    super.initState();

    getData();
  }

  Uint8List? _image;

  selectImage(ImageSource imageSource) async {
    Uint8List im = await pickImage(imageSource);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection("loudduquotes")
          .doc("quote")
          .get()
          .then((value) {
        setState(() {
          quoteImageUrl = value.data()!["quoteUrl"].toString();
          print(quoteImageUrl);
        });
      });
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

  bottomSheet2(context, String txt) {
    showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0),
      context: context,
      builder: (BuildContext c) {
        return Container(
          color: Colors.transparent,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8), topLeft: Radius.circular(8))),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10,
            ),
            child: Column(
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
                Text(
                  txt,
                  style: TextStyle(fontSize: 18.0, color: Colors.black54),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.camera),
                            iconSize: 40,
                            onPressed: () {
                              selectImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                          Text('Camera'),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.image, semanticLabel: 'Gallery'),
                            iconSize: 40,
                            onPressed: () {
                              selectImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          ),
                          Text('Gallery'),
                        ]),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  var opt = options.POSTS;
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
        : Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150,
                      color: Colors.grey.shade200,
                      width: double.infinity,
                      child: Image.network(
                        'https://www.insidesport.in/wp-content/uploads/2021/04/016_WM37_04102021CG_01753-290270b6e5fecca96e9e57bf0cb1fe50.jpg',
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 20,
                      bottom: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 53,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              maxRadius: 50,
                              backgroundImage: NetworkImage(
                                userData['photoUrl'],
                              ),
                            ),
                            if (FirebaseAuth.instance.currentUser!.uid ==
                                widget.uid)
                              Positioned(
                                  right: 0,
                                  bottom: 5,
                                  child: InkWell(
                                    onTap: () {
                                      bottomSheet2(
                                          context, "Choose Profile Picture");
                                    },
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Center(
                                          child: Icon(
                                            FontAwesomeIcons.plus,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                        ),
                                        radius: 12),
                                  )),
                          ],
                        ),
                      ),
                    ),
                    if (FirebaseAuth.instance.currentUser!.uid == widget.uid)
                      Positioned(
                        right: 20,
                        top: 15,
                        child: GestureDetector(
                          onTap: () {
                            bottomSheet2(context, "Choose Cover Photo");
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: CircleAvatar(
                                backgroundColor: Color(0xFFFFA100),
                                child: Icon(
                                  Icons.create,
                                  color: Colors.white,
                                ),
                                radius: 16),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 14, left: 27, right: 27, bottom: 4.5),
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
                                fontSize: 18),
                          ),
                          Text('Quantum University, Roorkee',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black)),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  fixedSize: Size.fromHeight(30),
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  side: BorderSide(
                                      width: 1, color: Colors.black54),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7))),
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor:
                                        Colors.black.withOpacity(0),
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Container(
                                            height: 250,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10))),
                                            // padding: EdgeInsets.symmetric(
                                            //   horizontal: 5,
                                            //   vertical: 10,
                                            // ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Container(
                                                      height: 3,
                                                      width: 37,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Name',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                            SizedBox(width: 25),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(7),
                                                              width: 240,
                                                              height: 35,
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  userData[
                                                                      "username"],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontFamily:
                                                                          'Roboto'),
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xFFF2F2F2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                            )
                                                            // Container(
                                                            //   width: 250,
                                                            //   child: TextFormField(
                                                            //       controller:
                                                            //           _controllername,
                                                            //       decoration: InputDecoration(
                                                            //           hintText: "",
                                                            //           labelText: userData[
                                                            //               "username"]),
                                                            //       keyboardType:
                                                            //           TextInputType.text),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Bio',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 40,
                                                            ),
                                                            Container(
                                                              width: 240,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    bioCOntrolee,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                maxLines: 3,
                                                                // maxLength: 50,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Colors
                                                                      .black45,
                                                                ),
                                                                cursorColor:
                                                                    Colors
                                                                        .black26,
                                                                decoration:
                                                                    InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              20,
                                                                          vertical:
                                                                              10),
                                                                  hintText: "",
                                                                  hintStyle: const TextStyle(
                                                                      color: Color(
                                                                          0xFFA3A3A3),
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'Roboto'),
                                                                  fillColor:
                                                                      const Color(
                                                                          0xFFF2F2F2),
                                                                  filled: true,
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    borderSide: BorderSide(
                                                                        color: const Color(
                                                                            0xFFF2F2F2),
                                                                        width:
                                                                            1.5),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xFFF2F2F2),
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            final docRef =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "users")
                                                                    .doc(widget
                                                                        .uid);
                                                            final updates = <
                                                                String,
                                                                dynamic>{
                                                              "bio":
                                                                  bioCOntrolee
                                                                      .text
                                                            };

                                                            docRef.update(updates).then(
                                                                (value) => print(
                                                                    "DocumentSnapshot successfully updated!"),
                                                                onError: (e) =>
                                                                    print(
                                                                        "Error updating document $e"));
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('SUBMIT',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color:
                                                                    btnCOlorblue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.create,
                                      color: Colors.black54,
                                      size: 15,
                                    ),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 12),
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
                                      FirebaseAuth.instance.currentUser!.uid,
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
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['uid'],
                                    );

                                    setState(() {
                                      isFollowing = true;
                                      followers++;
                                    });
                                  },
                                ),
                      SizedBox(width: 9),
                      if (FirebaseAuth.instance.currentUser!.uid == widget.uid)
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
                  padding: const EdgeInsets.symmetric(horizontal: 27.0),
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
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black54),
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
                                      borderRadius: BorderRadius.circular(25))),
                              onPressed: () {},
                              child: Text(
                                userData['designation'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 70,
                        child:
                            Center(child: buildStatColumn(postLen, "Posts"))),
                    Container(
                      height: 50,
                      color: Colors.black54,
                      width: 1,
                    ),
                    Container(
                        width: 90,
                        child: Center(
                            child: buildStatColumn(followers, "Followers"))),
                    Container(
                      height: 50,
                      color: Colors.black54,
                      width: 1,
                    ),
                    Container(
                        width: 70,
                        child: Center(
                            child: buildStatColumn(following, "Following"))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('reels')
                        .where("uid", isEqualTo: widget.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {}
                      if ((snapshot.data! as dynamic).docs.length > 0) {
                        return SizedBox(
                          height: 90,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller:
                                  ScrollController(keepScrollOffset: true),
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        child: VideoPlayerSearch(
                                          videoUrl: (snapshot.data! as dynamic)
                                              .docs[index]['reelUrl'],
                                        ),
                                      ),
                                    ),
                                  )),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    child: ClipRRect(
                                      child: Image.asset("images/three.png",
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    child: ClipRRect(
                                      child: Image.asset("images/two.png",
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    child: ClipRRect(
                                      child: Image.asset("images/one.png",
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    child: ClipRRect(
                                      child: Image.asset("images/four.png",
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  child: Image.asset("images/gmail_icon.png"),
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  child: Image.asset("images/gmail_icon.png"),
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  child: Image.asset("images/gmail_icon.png"),
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  child: Image.asset("images/gmail_icon.png"),
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.black45),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // isDispAllPost = true;
                              // isDispSavedPostt = false;
                              opt = options.POSTS;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 6),
                            child: Icon(
                              Icons.image,
                              color: (opt == options.POSTS)
                                  ? Colors.black
                                  : Colors.black54,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      if (FirebaseAuth.instance.currentUser!.uid == widget.uid
                        Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              opt = options.QUOTE;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 4),
                            child: Icon(
                              FontAwesomeIcons.blog,
                              color: (opt == options.QUOTE)
                                  ? Colors.black
                                  : Colors.black54,
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                      if (FirebaseAuth.instance.currentUser!.uid == widget.uid)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                // isDispAllPost = false;
                                // isDispSavedPostt = true;
                                opt = options.SAVED;
                                print('saved pressed');
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 4),
                              child: Icon(
                                FontAwesomeIcons.solidBookmark,
                                color: (opt == options.SAVED)
                                    ? Colors.black
                                    : Colors.black54,
                                size: 21,
                              ),
                            ),
                          ),
                        ),
                    ]),
                Divider(
                    height: 1,
                    thickness: (opt == options.QUOTE) ? 0 : 1,
                    color: Colors.black45),
                if (opt == options.POSTS)
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.white,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  maxRadius: 12,
                                                  backgroundImage: NetworkImage(
                                                    userData['photoUrl'],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  userData['username']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
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
                                                width: MediaQuery.of(context)
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
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                LikeAnimation(
                                                  smallLike: true,
                                                  isAnimating: false,
                                                  child: IconButton(
                                                      icon: isLsoading
                                                          ? const Icon(
                                                              FontAwesomeIcons
                                                                  .solidHeart,
                                                              color: Colors.red,
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
                if (opt == options.QUOTE)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xFFF6F6F6),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(quoteImageUrl))),
                    ),
                  ),
                if (opt == options.SAVED)
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .where('saves',
                            arrayContains:
                                FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.white,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  maxRadius: 12,
                                                  backgroundImage: NetworkImage(
                                                    userData['photoUrl'],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  userData['username']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
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
                                                width: MediaQuery.of(context)
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
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                LikeAnimation(
                                                  smallLike: true,
                                                  isAnimating: false,
                                                  child: IconButton(
                                                      icon: isLsoading
                                                          ? const Icon(
                                                              FontAwesomeIcons
                                                                  .solidHeart,
                                                              color: Colors.red,
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
                    maxRadius: 12,
                    backgroundImage: NetworkImage(
                      userData['photoUrl'],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    userData['username'].toString(),
                    style: TextStyle(color: Colors.black, fontSize: 18),
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
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
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
