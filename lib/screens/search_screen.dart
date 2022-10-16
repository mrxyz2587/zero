import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zero_fin/widgets/text_field_input.dart';
import 'package:zero_fin/widgets/video_player_items.dart';
import 'package:zero_fin/widgets/videoplayersearch.dart';
import '/screens/profile_screen.dart';
import '/utils/colors.dart';
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
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getLocation();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }

  @override
  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      print(position == null
          ? 'Unknown'
          : ' this is locs ${position.latitude.toString()}, ${position.longitude.toString()}');
      if (position != null) {
        setState(() {
          longitude = position.longitude;
          latitude = position.latitude;
        });
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(<String, String>{
          "longCoordinates": longitude.toString(),
          "latitudeCoordinates": latitude.toString(),
        });
        print(longitude.toString() + " locas " + latitude.toString());
      }
    });
    isLoading = false;
  }

  int i = 0;
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void getdistance() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEFEFEF),
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              // suffixIcon: Icon(
              //   FontAwesomeIcons.magnifyingGlass,
              //   color: Colors.black54,
              // ),
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
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
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
                FontAwesomeIcons.chevronLeft,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
          actions: [
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Icon(
            //     FontAwesomeIcons.magnifyingGlass,
            //     color: Colors.black87,
            //     size: 20,
            //   ),
            // )
          ],
        ),
        body: isTrue
            ? ListView(
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          useRootNavigator: false,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  SimpleDialogOption(
                                      child: Text("all Courses"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText = " ";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text(
                                          "Computer Sciences & Engineering"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText =
                                              "Computer Sciences & Engineering";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child:
                                          Text("Civil & Petroleum Engineering"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText =
                                              "Civil & Petroleum Engineering";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Mechanical  Engineering"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText =
                                              "Mechanical  Engineering";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text(
                                          "Electrical & Electronics Engineering"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText =
                                              "Electrical & Electronics Engineering";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Computer Applications"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText =
                                              "Computer Applications";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Business Administration"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText =
                                              "Business Administration";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Media Studies"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText = "Media Studies";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Law"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText = "Law";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Commerce & Finance"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText = "Commerce & Finance";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Sciences"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText = "Sciences";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child:
                                          Text("Humanities & Social Sciences"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText =
                                              "Humanities & Social Sciences";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Hospitality & Tourism"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText =
                                              "Hospitality & Tourism";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Agricultural Studies"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText = "Agricultural Studies";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Pharmacy"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText = "Pharmacy";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Applied Medical Sciences"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText =
                                              "Applied Medical Sciences";
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SimpleDialogOption(
                                      child: Text("Paramedical Sciences"),
                                      onPressed: () {
                                        setState(() {
                                          selectedText = "Paramedical Sciences";
                                        });
                                        Navigator.pop(context);
                                      }),
                                ]),
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          "Filter",
                          textAlign: TextAlign.end,
                        ),
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
                                child: Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
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
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 13),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: btnCOlorblue,
                                                  minimumSize: Size(50, 12),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7))),
                                              onPressed:
                                                  () {}, //TODO 2. button action
                                              icon: Icon(
                                                FontAwesomeIcons.userPlus,
                                                size: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: btnCOlorblue,
                                                  minimumSize: Size(50, 12),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7))),
                                              onPressed:
                                                  () {}, //TODO 2. button action
                                              icon: Icon(
                                                FontAwesomeIcons
                                                    .solidPaperPlane,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
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
                        future: (selectedText == " ")
                            ? FirebaseFirestore.instance
                                .collection('users')
                                .where(
                                  'username',
                                  isGreaterThanOrEqualTo: searchController.text,
                                )
                                .get()
                            : FirebaseFirestore.instance
                                .collection('users')
                                .where(
                                  'username',
                                  isGreaterThanOrEqualTo: searchController.text,
                                )
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
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid'],
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
                                  ),
                                  title: Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['username'],
                                  ),
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
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where("uid",
                                isNotEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return SizedBox(
                            height: 110,
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
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .where("uid",
                                        isNotEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .get()
                                    .then((value) {
                                  for (var docs in value.docs) {
                                    if (docs.data()["uid"].toString() !=
                                        FirebaseAuth.instance.currentUser!.uid
                                            .toString()) {
                                      otherlatitude = double.parse(
                                          docs.data()['latitudeCoordinates']);
                                      otherlongitude = double.parse(
                                          docs.data()['longCoordinates']);
                                      print(otherlongitude.toString() +
                                          "  " +
                                          otherlatitude.toString());

                                      print(longitude.toString() +
                                          " my " +
                                          latitude.toString());
                                      distanceInMeters = calculateDistance(
                                          latitude,
                                          longitude,
                                          otherlatitude,
                                          otherlongitude);

                                      if (distanceInMeters < 100) {
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 20.0, bottom: 5),
                                            child: Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.all(4),
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                          (snapshot.data!
                                                                  as dynamic)
                                                              .docs[index]
                                                                  ['photoUrl']
                                                              .toString(),
                                                        ),
                                                        radius: 30,
                                                      ),
                                                      Positioned(
                                                        bottom: 3,
                                                        right: 6,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  btnCOlorblue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1)),
                                                          constraints:
                                                              BoxConstraints
                                                                  .tight(Size
                                                                      .fromRadius(
                                                                          5)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                      (snapshot.data!
                                                              as dynamic)
                                                          .docs[index]
                                                              ['username']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF000000),
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              'Roboto')),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      print("distance$distanceInMeters  $i");
                                      i++;
                                    }
                                  }
                                });
                                return Container();
                              },
                            ),
                          );
                        },
                      ),
                      Divider(
                          height: 0.5, thickness: 0.5, color: Colors.black26),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('reels')
                            .where(
                              'reelId',
                            )
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) => Container(
                              child: VideoPlayerSearch(
                                videoUrl: (snapshot.data! as dynamic)
                                    .docs[index]['reelUrl'],
                              ),
                            ),
                            staggeredTileBuilder: (index) =>
                                MediaQuery.of(context).size.width >
                                        webScreenSize
                                    ? StaggeredTile.count(
                                        (index % 7 == 0) ? 1 : 1,
                                        (index % 7 == 0) ? 1 : 1)
                                    : StaggeredTile.count(
                                        (index % 7 == 0) ? 2 : 1,
                                        (index % 7 == 0) ? 2 : 1),
                            mainAxisSpacing: 2.0,
                            crossAxisSpacing: 2.0,
                          );
                        },
                      ),
                    ],
                  ));
  }
}
