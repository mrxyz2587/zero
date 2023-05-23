import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/resources/firestore_methods.dart';
import 'package:zero_fin/screens/ChatRoom.dart';
import 'package:zero_fin/screens/HomeScreen.dart';
import 'package:zero_fin/screens/Mentorship.dart';
import 'package:zero_fin/screens/resturant_showing_screen.dart';
import 'package:zero_fin/widgets/fashion_card_widget.dart';
import 'package:zero_fin/widgets/text_field_input.dart';
import 'package:zero_fin/widgets/video_player_items.dart';
import 'package:zero_fin/widgets/videoplayersearch.dart';
import '../widgets/mentors_card.dart';
import '../widgets/post_card.dart';
import '/screens/profile_screen.dart';
import '/utils/colors.dart';
import 'image_vieweing.dart';
import '/utils/global_variable.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

enum options { MEN, WOMEN, BEAUTY }

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  double longitude = 0;
  double latitude = 0;
  double distanceInMeters = 0;
  bool isLoading = true;
  String selectedText = " ";
  double otherlongitude = 0;
  double otherlatitude = 0;

  bool isTrue = false;
  Timer? timer;
  bool canShowUserNearBy = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var opt = 'men';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),

      // backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
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
              borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 1),
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
            setState(() {
              isTrue = true;
            });
          },
          onChanged: (String _) {
            setState(() {
              isShowUsers = true;
              isTrue = false;
            });
            print(_);
          },
        ),
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 5,
          ),
          child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isShowUsers = false;
                isTrue = false;
                selectedText = " ";
              });
            },
          ),
        ),
        actions: [],
      ),
      body: isTrue
          ? ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE-CSCQ"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE-CSCQ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE-AIML"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE-AIML";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child:
                                            Text("B.Tech + MBA (Integrated)"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "B.Tech + MBA (Integrated)";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma CSE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "Diploma CSE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child:
                                            Text("Doctor of Philosophy - CSE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Doctor of Philosophy - CSE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("M.Tech CSE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "M.Tech CSE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE-DS"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE-DS";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("M.Tech Thermal Engg"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "M.Tech Thermal Engg";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("M.Tech SE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "M.Tech SE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE-FSD"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE-FSD";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma CE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "Diploma CE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech PE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech PE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech ME"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech ME";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma ME"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "Diploma ME";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech ME-ROBO"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech ME-ROBO";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech EE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech EE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma EE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "Diploma EE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech ECE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech ECE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Computer Applications"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Computer Applications";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Master of Computer Applications"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Master of Computer Applications";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Business Administration"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Business Administration";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Master of Business Administration"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Master of Business Administration";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "BBA+MBA (Family Business Management)"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "BBA+MBA (Family Business Management)";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Bachelor of Commerce"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Commerce";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Arts (Hons) in Economics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Arts (Hons) in Economics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Arts (Hons) in English"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Arts (Hons) in English";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science (Hons) in Mathematics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science (Hons) in Mathematics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science (Hons) in Chemistry"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science (Hons) in Chemistry";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Arts (Hons) in Psychology"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Arts (Hons) in Psychology";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science (Hons) in Physics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science (Hons) in Physics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science (Hons) in Agriculture"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science (Hons) in Agriculture";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Arts (Hons) in Journalism and Mass Communication"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Arts (Hons) in Journalism and Mass Communication";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in Animation and VFX"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in Animation and VFX";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in UI and Graphics Design"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in UI and Graphics Design";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in UI and Graphics Design"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in UI and Graphics Design";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Master of Science in Nutrition and Dietetics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Master of Science in Nutrition and Dietetics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in Medical Radiology and Imaging Technology"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in Medical Radiology and Imaging Technology";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Bachelor of Pharmacy"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Pharmacy";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Medical Lab Technology"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Medical Lab Technology";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in Nutrition and Dietetics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in Nutrition and Dietetics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma in Pharmacy"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Diploma in Pharmacy";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Integrated Bachelor of Business Administration and Bachelor of Law (Hons)"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Integrated Bachelor of Business Administration and Bachelor of Law (Hons)";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Integrated Bachelor of Arts and Bachelor of Law (Hons)"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Integrated Bachelor of Arts and Bachelor of Law (Hons)";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Certificate Course in Hotel Management"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Certificate Course in Hotel Management";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Hotel Management"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Hotel Management";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Post Graduate Diploma in Maritime Business Management"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Post Graduate Diploma in Maritime Business Management";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Doctor of Philosophy - Management"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Doctor of Philosophy - Management";
                                          });
                                          Navigator.pop(context);
                                        }),
                                  ]),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      "Select Branch",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: btnCOlorblue),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: (selectedText == " ")
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .limit(80)
                          .get()
                      : FirebaseFirestore.instance
                          .collection('users')
                          .where("department",
                              isEqualTo: selectedText.toString())
                          .limit(40)
                          .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: ScrollController(keepScrollOffset: true),
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        List followers = (snapshot.data! as dynamic).docs[index]
                            ['followers'];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid'],
                              ),
                            ),
                          ),
                          child: Container(
                            height: 90,
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          (snapshot.data! as dynamic)
                                              .docs[index]['photoUrl']
                                              .toString(),
                                        ),
                                        radius: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                (snapshot.data! as dynamic)
                                                    .docs[index]['username']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Roboto')),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                                (snapshot.data! as dynamic)
                                                    .docs[index]['university']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                    fontFamily: 'Roboto')),
                                          ],
                                        ),
                                      ),
                                    ),
                                    (snapshot.data! as dynamic)
                                                .docs[index]['uid']
                                                .toString() !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                                .toString()
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 13),
                                            child: Row(
                                              children: [
                                                followers.contains(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid
                                                        .toString())
                                                    ? IconButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                btnCOlorblue,
                                                            minimumSize:
                                                                const Size(
                                                                    50, 12),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7))),
                                                        onPressed:
                                                            () {}, //TODO 2. button action
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .userCheck,
                                                          color:
                                                              Color(0xFF78CD00),
                                                          size: 20,
                                                        ),
                                                      )
                                                    : IconButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                btnCOlorblue,
                                                            minimumSize:
                                                                const Size(
                                                                    50, 12),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7))),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfileScreen(
                                                                uid: (snapshot
                                                                            .data!
                                                                        as dynamic)
                                                                    .docs[index]['uid'],
                                                              ),
                                                            ),
                                                          );
                                                        }, //TODO 2. button action
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .userPlus,
                                                          size: 20,
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                IconButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          btnCOlorblue,
                                                      minimumSize: Size(50, 12),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7))),
                                                  onPressed: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => ChatRoom(
                                                            otUsername: (snapshot.data! as dynamic)
                                                                .docs[index]
                                                                    ['username']
                                                                .toString(),
                                                            otUid: (snapshot.data! as dynamic)
                                                                .docs[index]
                                                                    ['uid']
                                                                .toString(),
                                                            profilePic: (snapshot.data! as dynamic)
                                                                .docs[index]
                                                                    ['photoUrl']
                                                                .toString(),
                                                            status: (snapshot.data!
                                                                    as dynamic)
                                                                .docs[index]
                                                                    ['status']
                                                                .toString(),
                                                            token: (snapshot.data!
                                                                    as dynamic)
                                                                .docs[index]['token']
                                                                .toString())));
                                                  }, //TODO 2. button action
                                                  icon: Icon(
                                                    FontAwesomeIcons
                                                        .solidPaperPlane,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            width: 50,
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            )
          : isShowUsers
              ? ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where(
                            'username',
                            isGreaterThanOrEqualTo: searchController.text,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    uid: (snapshot.data! as dynamic).docs[index]
                                        ['uid'],
                                  ),
                                ),
                              ),
                              child: ListTile(
                                focusColor: Colors.white,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['photoUrl'],
                                  ),
                                  radius: 16,
                                ),
                                subtitle: Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['university'],
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        fontFamily: 'Roboto')),
                                title: Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['username'],
                                    style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Roboto')),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
              : ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22.0, right: 22, bottom: 5, top: 15),
                          child: Row(
                            children: [
                              Text(
                                "Active Buddies",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Comfortaa"),
                              ),
                              Expanded(child: SizedBox()),
                              GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(
                                      'https://rzp.io/l/nearbybookingzeromonk')) {
                                    await launch(
                                        'https://rzp.io/l/nearbybookingzeromonk',
                                        enableDomStorage: true,
                                        enableJavaScript: true,
                                        forceWebView: true);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          color: btnCOlorblue, width: 0.5)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: Center(
                                    child: Text(
                                      "See all",
                                      style: TextStyle(
                                          color: btnCOlorblue,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where("status", isEqualTo: 'Online')
                            .limit(7)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return SizedBox(
                            height: 220,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              controller:
                                  ScrollController(keepScrollOffset: true),
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5, right: 4),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                      uid: (snapshot.data!
                                                              as dynamic)
                                                          .docs[index]['uid']
                                                          .toString(),
                                                    )));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        width: 150,
                                        height: 220,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              child: Image.network(
                                                (snapshot.data! as dynamic)
                                                    .docs[index]['photoUrl']
                                                    .toString(),
                                                fit: BoxFit.fill,
                                                height: 220,
                                                width: 150,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            // Positioned(
                                            //   bottom: 3,
                                            //   right: 6,
                                            //   child: Container(
                                            //     decoration: BoxDecoration(
                                            //         color: btnCOlorblue,
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 10),
                                            //         border: Border.all(
                                            //             color: Colors.white,
                                            //             width: 1)),
                                            //     constraints:
                                            //         BoxConstraints.tight(
                                            //             Size.fromRadius(5)),
                                            //   ),
                                            // ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 7.0),
                                                height: 50,
                                                width: 142,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .bottomCenter,
                                                        end:
                                                            Alignment.topCenter,
                                                        tileMode:
                                                            TileMode.clamp,
                                                        colors: [
                                                          Color(0xD2000000),
                                                          Color(0x8E000000),
                                                          Color(0x3D000000),
                                                          Color(0x17000000),
                                                          Color(0xB000000),
                                                        ])),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 80,
                                                      child: Text(
                                                        (snapshot.data!
                                                                as dynamic)
                                                            .docs[index]
                                                                ['username']
                                                            .toString(),
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily:
                                                                'Roboto'),
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                    CircleAvatar(
                                                        radius: 14,
                                                        backgroundColor:
                                                            Colors.red,
                                                        child: Center(
                                                            child: Icon(
                                                          FontAwesomeIcons
                                                              .solidHeart,
                                                          color: Colors.white,
                                                          size: 16,
                                                        )))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Positioned(
                                            //   left: 6,
                                            //   bottom: 20,
                                            //   child: Container(
                                            //     width: 80,
                                            //     child: Text(
                                            //       (snapshot.data! as dynamic)
                                            //           .docs[index]['username']
                                            //           .toString(),
                                            //       style: TextStyle(
                                            //           overflow:
                                            //               TextOverflow.fade,
                                            //           color: Color(0xFFFFFFFF),
                                            //           fontSize: 15,
                                            //           fontWeight:
                                            //               FontWeight.w700,
                                            //           fontFamily: 'Roboto'),
                                            //       maxLines: 1,
                                            //       softWrap: false,
                                            //       overflow: TextOverflow.fade,
                                            //       textAlign: TextAlign.left,
                                            //     ),
                                            //   ),
                                            // ),
                                            // Positioned(
                                            //     bottom: 10,
                                            //     right: 6,
                                            //     child: CircleAvatar(
                                            //         radius: 15,
                                            //         backgroundColor: Colors.red,
                                            //         child: Center(
                                            //             child: Icon(
                                            //           FontAwesomeIcons
                                            //               .solidHeart,
                                            //           color: Colors.white,
                                            //           size: 16,
                                            //         ))))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(height: 0.5, thickness: 0.5, color: Colors.black26),

                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22.0, right: 22, bottom: 15, top: 20),
                          child: Text(
                            "Top Mentors",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Comfortaa"),
                          ),
                        )),
                    Divider(height: 0.5, thickness: 0.5, color: Colors.black26),

                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('coursesection')
                          .doc('mentorship')
                          .collection('allmentors')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          controller: ScrollController(keepScrollOffset: true),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) => Container(
                            child: MentorsCard(
                              snap: snapshot.data!.docs[index].data(),
                              onpressed: () {
                                showModalBottomSheet(
                                  enableDrag: true,
                                  isDismissible: true,
                                  backgroundColor: Colors.black.withOpacity(0),
                                  context: context,
                                  builder: (BuildContext c) {
                                    return Container(
                                      color: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                topLeft: Radius.circular(20))),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: 8),
                                            Container(
                                              height: 5,
                                              width: 45,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 17),
                                            Container(
                                              height: 140,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Image.network(
                                                snapshot.data!.docs[index]
                                                    .data()["mentorcoverimg"]
                                                    .toString(),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      snapshot.data!.docs[index]
                                                          .data()[
                                                              "photomentorurl"]
                                                          .toString(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        .data()["name"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    softWrap: false,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 12.0,
                                                        horizontal: 8),
                                                    child: GestureDetector(
                                                        onTap: () {},
                                                        child: Icon(
                                                            FontAwesomeIcons
                                                                .linkedin,
                                                            size: 20,
                                                            color:
                                                                Colors.blue)),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  GestureDetector(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 16.0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          border: Border.all(
                                                            color: Color(
                                                              0xFF6F6F6F,
                                                            ),
                                                          )),
                                                      child: Image.asset(
                                                          'images/share_icons.png'),
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                              ),
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    .data()["description"]
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                maxLines: 4,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Expanded(child: SizedBox()),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 50),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7)),
                                                  border: Border.all(
                                                    color: Color(
                                                      0xFF585858,
                                                    ),
                                                  )),
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    .data()["category"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(child: SizedBox()),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15.0),
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          btnCOlorblue,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          7))),
                                                    ),
                                                    onPressed: () async {
                                                      String url = snapshot
                                                          .data!.docs[index]
                                                          .data()["applylink"]
                                                          .toString();
                                                      if (await canLaunch(
                                                          url)) {
                                                        await launch(url,
                                                            enableDomStorage:
                                                                true,
                                                            enableJavaScript:
                                                                true,
                                                            forceWebView: true);
                                                      }
                                                    },
                                                    // color: btnCOlorblue,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 50,
                                                          vertical: 8),
                                                      child: Text(
                                                        'Apply',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )

                    // Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Container(
                    //       child: Text(
                    //         "Nearby Restuarants",
                    //         style: TextStyle(
                    //             color: Colors.black54,
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.w700,
                    //             fontFamily: "Comfortaa"),
                    //       ),
                    //       padding:
                    //           EdgeInsets.only(left: 22, top: 15, bottom: 5),
                    //     )),
                    // Padding(
                    //   padding: const EdgeInsets.all(6.0),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) =>
                    //                   RestuarantShowingScreen()));
                    //     },
                    //     child: Container(
                    //       height: 172,
                    //       width: 352,
                    //       child: Card(
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(15),
                    //           child: Image.asset(
                    //             'images/eat_now.png',
                    //             fit: BoxFit.fill,
                    //           ),
                    //         ),
                    //         color: Colors.white,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(15),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //
                    //   // GridView(
                    //   //   physics: ClampingScrollPhysics(),
                    //   //   controller: ScrollController(keepScrollOffset: true),
                    //   //   children: [
                    //   //     GestureDetector(
                    //   //       onTap: () async {
                    //   //         Fluttertoast.showToast(
                    //   //             msg: "comming soon",
                    //   //             toastLength: Toast.LENGTH_SHORT,
                    //   //             gravity: ToastGravity.BOTTOM,
                    //   //             timeInSecForIosWeb: 1,
                    //   //             backgroundColor: Colors.black54,
                    //   //             textColor: Colors.white,
                    //   //             fontSize: 14.0);
                    //   //       },
                    //   //       child: Card(
                    //   //         child: ClipRRect(
                    //   //           borderRadius: BorderRadius.circular(15),
                    //   //           child: Image.asset(
                    //   //             'images/zero_store.png',
                    //   //             fit: BoxFit.cover,
                    //   //           ),
                    //   //         ),
                    //   //         color: Colors.white,
                    //   //         shape: RoundedRectangleBorder(
                    //   //           borderRadius: BorderRadius.all(
                    //   //             Radius.circular(15),
                    //   //           ),
                    //   //         ),
                    //   //       ),
                    //   //     ),
                    //   //     GestureDetector(
                    //   //       onTap: () async {
                    //   //         Fluttertoast.showToast(
                    //   //             msg: "comming soon",
                    //   //             toastLength: Toast.LENGTH_SHORT,
                    //   //             gravity: ToastGravity.BOTTOM,
                    //   //             timeInSecForIosWeb: 1,
                    //   //             backgroundColor: Colors.black54,
                    //   //             textColor: Colors.white,
                    //   //             fontSize: 14.0);
                    //   //       },
                    //   //       child: Card(
                    //   //         child: ClipRRect(
                    //   //           borderRadius: BorderRadius.circular(15),
                    //   //           child: Image.asset(
                    //   //             'images/clothing.png',
                    //   //             fit: BoxFit.cover,
                    //   //           ),
                    //   //         ),
                    //   //         color: Colors.white,
                    //   //         shape: RoundedRectangleBorder(
                    //   //           borderRadius: BorderRadius.all(
                    //   //             Radius.circular(15),
                    //   //           ),
                    //   //         ),
                    //   //       ),
                    //   //     ),
                    //   //     GestureDetector(
                    //   //       onTap: () {
                    //   //         Fluttertoast.showToast(
                    //   //             msg: "comming soon",
                    //   //             toastLength: Toast.LENGTH_SHORT,
                    //   //             gravity: ToastGravity.BOTTOM,
                    //   //             timeInSecForIosWeb: 1,
                    //   //             backgroundColor: Colors.black54,
                    //   //             textColor: Colors.white,
                    //   //             fontSize: 14.0);
                    //   //       },
                    //   //       child: Card(
                    //   //         child: ClipRRect(
                    //   //           borderRadius: BorderRadius.circular(15),
                    //   //           child: Image.asset(
                    //   //             'images/shoes.png',
                    //   //             fit: BoxFit.cover,
                    //   //           ),
                    //   //         ),
                    //   //         color: Colors.white,
                    //   //         shape: RoundedRectangleBorder(
                    //   //           borderRadius: BorderRadius.all(
                    //   //             Radius.circular(15),
                    //   //           ),
                    //   //         ),
                    //   //       ),
                    //   //     ),
                    //   //   ],
                    //   //   gridDelegate:
                    //   //       const SliverGridDelegateWithFixedCrossAxisCount(
                    //   //     crossAxisCount: 2,
                    //   //     crossAxisSpacing: 1.5,
                    //   //     mainAxisSpacing: 1.5,
                    //   //     childAspectRatio: 0.9,
                    //   //   ),
                    //   //   shrinkWrap: true,
                    //   // ),
                    // ),
                    // // FutureBuilder(
                    // //   future: FirebaseFirestore.instance
                    // //       .collection('reels')
                    // //       .where(
                    // //         'reelId',
                    // //       )
                    // //       .get(),
                    // //   builder: (context, snapshot) {
                    // //     if (!snapshot.hasData) {
                    // //       return const Center(
                    // //         child: CircularProgressIndicator(),
                    // //       );
                    // //     }
                    // //
                    // //     return StaggeredGridView.countBuilder(
                    // //       controller: ScrollController(
                    // //         keepScrollOffset: true,
                    // //       ),
                    // //       shrinkWrap: true,
                    // //       crossAxisCount: 3,
                    // //       itemCount: (snapshot.data! as dynamic).docs.length,
                    // //       itemBuilder: (context, index) => Container(
                    // //         child: VideoPlayerSearch(
                    // //           videoUrl: (snapshot.data! as dynamic)
                    // //               .docs[index]['reelUrl'],
                    // //         ),
                    // //       ),
                    // //       staggeredTileBuilder: (index) =>
                    // //           MediaQuery.of(context).size.width >
                    // //                   webScreenSize
                    // //               ? StaggeredTile.count(
                    // //                   (index % 7 == 0) ? 1 : 1,
                    // //                   (index % 7 == 0) ? 1 : 1)
                    // //               : StaggeredTile.count(
                    // //                   (index % 7 == 0) ? 2 : 1,
                    // //                   (index % 7 == 0) ? 2 : 1),
                    // //       mainAxisSpacing: 2.0,
                    // //       crossAxisSpacing: 2.0,
                    // //     );
                    // //   },
                    // // ),
                    // Divider(thickness: 6, color: Color(0xFFEFEFEF)),
                    //
                    // Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Container(
                    //       child: Text(
                    //         "College Life Style",
                    //         style: TextStyle(
                    //             color: Colors.black54,
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.w700,
                    //             fontFamily: "Comfortaa"),
                    //       ),
                    //       padding:
                    //           EdgeInsets.only(left: 22, top: 10, bottom: 10),
                    //     )),
                    // Divider(thickness: 6, color: Color(0xFFEFEFEF)),
                    //
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //   child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               opt = 'men';
                    //             });
                    //           },
                    //           child: Container(
                    //             width: 79,
                    //             height: 30,
                    //             child: Center(
                    //               child: Text(
                    //                 'MEN',
                    //                 style: TextStyle(
                    //                     color: opt == 'men'
                    //                         ? Color(0xFF3A8CC9)
                    //                         : Color(0xFF1D1C1D),
                    //                     fontFamily: 'Roboto',
                    //                     fontWeight: FontWeight.w700,
                    //                     fontSize: 12),
                    //               ),
                    //             ),
                    //             decoration: BoxDecoration(
                    //                 color: Color(
                    //                   0xFFF2F6F5,
                    //                 ),
                    //                 borderRadius: BorderRadius.circular(22)),
                    //           ),
                    //         ),
                    //         GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               opt = 'women';
                    //             });
                    //           },
                    //           child: Container(
                    //             width: 79,
                    //             height: 30,
                    //             child: Center(
                    //               child: Text(
                    //                 'WOMEN',
                    //                 style: TextStyle(
                    //                     color: opt == 'women'
                    //                         ? Color(0xFF3A8CC9)
                    //                         : Color(0xFF1D1C1D),
                    //                     fontFamily: 'Roboto',
                    //                     fontWeight: FontWeight.w700,
                    //                     fontSize: 12),
                    //               ),
                    //             ),
                    //             decoration: BoxDecoration(
                    //                 color: Color(
                    //                   0xFFF2F6F5,
                    //                 ),
                    //                 borderRadius: BorderRadius.circular(22)),
                    //           ),
                    //         ),
                    //         GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               opt = 'beauty';
                    //             });
                    //           },
                    //           child: Container(
                    //             width: 79,
                    //             height: 30,
                    //             child: Center(
                    //               child: Text(
                    //                 'BEAUTY',
                    //                 style: TextStyle(
                    //                     color: opt == 'beauty'
                    //                         ? Color(0xFF3A8CC9)
                    //                         : Color(0xFF1D1C1D),
                    //                     fontFamily: 'Roboto',
                    //                     fontWeight: FontWeight.w700,
                    //                     fontSize: 12),
                    //               ),
                    //             ),
                    //             decoration: BoxDecoration(
                    //                 color: Color(
                    //                   0xFFF2F6F5,
                    //                 ),
                    //                 borderRadius: BorderRadius.circular(22)),
                    //           ),
                    //         ),
                    //       ]),
                    // ),
                    // StreamBuilder(
                    //   stream: FirebaseFirestore.instance
                    //       .collection('ecommale')
                    //       .where('type', isEqualTo: opt)
                    //       .snapshots(),
                    //   builder: (context,
                    //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    //           snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return Center(
                    //           child: CircularProgressIndicator(
                    //         color: Colors.grey.shade300,
                    //         strokeWidth: 1.5,
                    //       ));
                    //     }
                    //     return ListView.builder(
                    //       shrinkWrap: true,
                    //       controller: ScrollController(),
                    //       scrollDirection: Axis.vertical,
                    //       itemCount: snapshot.data!.docs.length,
                    //       itemBuilder: (ctx, index) => Container(
                    //         margin: EdgeInsets.symmetric(
                    //           horizontal:
                    //               width > webScreenSize ? width * 0.3 : 0,
                    //           vertical: width > webScreenSize ? 15 : 0,
                    //         ),
                    //         child: FashionCard(
                    //           snap: snapshot.data!.docs[index].data(),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ),
    );
  }
}
