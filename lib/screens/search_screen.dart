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
import 'package:zero_fin/screens/resturant_showing_screen.dart';
import 'package:zero_fin/widgets/text_field_input.dart';
import 'package:zero_fin/widgets/video_player_items.dart';
import 'package:zero_fin/widgets/videoplayersearch.dart';
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

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      print(position == null
          ? 'Unknown'
          : ' this is locs ${position.latitude.toString()}, ${position.longitude.toString()}');
      if (position != null) {}
    });
    setState(() {
      longitude = position.longitude;
      latitude = position.latitude;
    });
    print(longitude.toString() + " locas " + latitude.toString());

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(<String, String>{
      "longCoordinates": longitude.toString(),
      "latitudeCoordinates": latitude.toString(),
    });

    isLoading = false;
  }

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
                      ? FirebaseFirestore.instance.collection('users').get()
                      : FirebaseFirestore.instance
                          .collection('users')
                          .where("department",
                              isEqualTo: selectedText.toString())
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
                  children: [
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where(
                            'username',
                            isGreaterThanOrEqualTo: searchController.text,
                          )
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
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
                        child: Container(
                          child: Text(
                            "Nearby Buddies",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Comfortaa"),
                          ),
                          padding:
                              EdgeInsets.only(left: 22, top: 15, bottom: 5),
                        )),
                    Container(
                        height: 110,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text('Comming Soon'),
                        )),
                    Divider(height: 0.5, thickness: 0.5, color: Colors.black26),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Text(
                            "Nearby Stores",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Comfortaa"),
                          ),
                          padding:
                              EdgeInsets.only(left: 22, top: 15, bottom: 5),
                        )),

                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RestuarantShowingScreen()));
                        },
                        child: Container(
                          height: 172,
                          width: 352,
                          child: Card(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'images/eat_now.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // GridView(
                      //   physics: ClampingScrollPhysics(),
                      //   controller: ScrollController(keepScrollOffset: true),
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () async {
                      //         Fluttertoast.showToast(
                      //             msg: "comming soon",
                      //             toastLength: Toast.LENGTH_SHORT,
                      //             gravity: ToastGravity.BOTTOM,
                      //             timeInSecForIosWeb: 1,
                      //             backgroundColor: Colors.black54,
                      //             textColor: Colors.white,
                      //             fontSize: 14.0);
                      //       },
                      //       child: Card(
                      //         child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(15),
                      //           child: Image.asset(
                      //             'images/zero_store.png',
                      //             fit: BoxFit.cover,
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
                      //     GestureDetector(
                      //       onTap: () async {
                      //         Fluttertoast.showToast(
                      //             msg: "comming soon",
                      //             toastLength: Toast.LENGTH_SHORT,
                      //             gravity: ToastGravity.BOTTOM,
                      //             timeInSecForIosWeb: 1,
                      //             backgroundColor: Colors.black54,
                      //             textColor: Colors.white,
                      //             fontSize: 14.0);
                      //       },
                      //       child: Card(
                      //         child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(15),
                      //           child: Image.asset(
                      //             'images/clothing.png',
                      //             fit: BoxFit.cover,
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
                      //     GestureDetector(
                      //       onTap: () {
                      //         Fluttertoast.showToast(
                      //             msg: "comming soon",
                      //             toastLength: Toast.LENGTH_SHORT,
                      //             gravity: ToastGravity.BOTTOM,
                      //             timeInSecForIosWeb: 1,
                      //             backgroundColor: Colors.black54,
                      //             textColor: Colors.white,
                      //             fontSize: 14.0);
                      //       },
                      //       child: Card(
                      //         child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(15),
                      //           child: Image.asset(
                      //             'images/shoes.png',
                      //             fit: BoxFit.cover,
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
                      //   ],
                      //   gridDelegate:
                      //       const SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 2,
                      //     crossAxisSpacing: 1.5,
                      //     mainAxisSpacing: 1.5,
                      //     childAspectRatio: 0.9,
                      //   ),
                      //   shrinkWrap: true,
                      // ),
                    ),

                    // FutureBuilder(
                    //   future: FirebaseFirestore.instance
                    //       .collection('reels')
                    //       .where(
                    //         'reelId',
                    //       )
                    //       .get(),
                    //   builder: (context, snapshot) {
                    //     if (!snapshot.hasData) {
                    //       return const Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //
                    //     return StaggeredGridView.countBuilder(
                    //       controller: ScrollController(
                    //         keepScrollOffset: true,
                    //       ),
                    //       shrinkWrap: true,
                    //       crossAxisCount: 3,
                    //       itemCount: (snapshot.data! as dynamic).docs.length,
                    //       itemBuilder: (context, index) => Container(
                    //         child: VideoPlayerSearch(
                    //           videoUrl: (snapshot.data! as dynamic)
                    //               .docs[index]['reelUrl'],
                    //         ),
                    //       ),
                    //       staggeredTileBuilder: (index) =>
                    //           MediaQuery.of(context).size.width >
                    //                   webScreenSize
                    //               ? StaggeredTile.count(
                    //                   (index % 7 == 0) ? 1 : 1,
                    //                   (index % 7 == 0) ? 1 : 1)
                    //               : StaggeredTile.count(
                    //                   (index % 7 == 0) ? 2 : 1,
                    //                   (index % 7 == 0) ? 2 : 1),
                    //       mainAxisSpacing: 2.0,
                    //       crossAxisSpacing: 2.0,
                    //     );
                    //   },
                    // ),

                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Text(
                            "Life Style",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Comfortaa"),
                          ),
                          padding:
                              EdgeInsets.only(left: 22, top: 15, bottom: 5),
                        )),

                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: Colors.grey.shade300,
                            strokeWidth: 1.5,
                          ));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          controller: ScrollController(),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) => Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  width > webScreenSize ? width * 0.3 : 0,
                              vertical: width > webScreenSize ? 15 : 0,
                            ),
                            child: PostCard(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
    );
  }
}
