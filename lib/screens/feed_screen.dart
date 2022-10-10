import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/screens/HomeScreen.dart';
import 'package:zero_fin/screens/profile_screen.dart';
import 'package:zero_fin/screens/search_screen.dart';
import '../providers/user_provider.dart';
import '/utils/colors.dart';
import '/utils/global_variable.dart';
import '/widgets/post_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  double longitude = 0;
  double latitude = 0;
  double distanceInMeters = 0;
  bool isLoading = true;
  bool isLoasdings = true;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.

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
  void initState() {
    _determinePosition();
    getData();

    // TODO: implement initState
    // getLocation();
    super.initState();
  }

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
        longitude = position.longitude;
        latitude = position.latitude;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(<String, String>{
          "longCoordinates": longitude.toString(),
          "latitudeCoordinates": latitude.toString(),
          "distance": distanceInMeters.toString()
        });
        print(longitude.toString() + "" + latitude.toString());
      }
    });
    getdistance();

    isLoading = false;
  }

  int i = 0;
  void getData() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      setState(() {
        isLoasdings = false;
      });
    });
  }

  void getdistance() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var docs in value.docs) {
        var lats = double.parse(docs.data()['latitudeCoordinates']);
        var long = double.parse(docs.data()['longCoordinates']);
        print(lats.toString() + long.toString());
        distanceInMeters =
            Geolocator.distanceBetween(latitude, longitude, lats, long);

        print("distance$distanceInMeters  $i");
        i++;
        FirebaseFirestore.instance
            .collection("users")
            .doc(docs.data()["uid"])
            .update(<String, dynamic>{"distance": distanceInMeters.toString()});
        distanceInMeters = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    getLocation();

    return isLoasdings
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.grey.shade300,
              strokeWidth: 1.5,
            )),
          )
        : Scaffold(
            backgroundColor: Color(0xFFEFEFEF),
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                uid: userProvider.getUser.uid,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      ClipOval(
                        child: Image.network(
                          userProvider.getUser.photoUrl,
                          fit: BoxFit.cover,
                          height: 34,
                          width: 34,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Image.asset('images/logo.jpeg', height: 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 0.5),
                    child: Text(
                      'ERO',
                      style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Comfortaa'),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.solidBell,
                    color: Colors.black,
                    size: 18,
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => N()));
                  },
                ),
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.solidPaperPlane,
                    size: 18,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatScreen()));
                  },
                ),
              ],
            ),
            body: ListView(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('banners')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.grey.shade300,
                        strokeWidth: 1.5,
                      ));
                    }
                    return ClipRRect(
                      child: CarouselSlider.builder(
                        itemCount: snapshot.data!.docs.length,

                        options: CarouselOptions(
                          viewportFraction: 0.8,
                          disableCenter: true,
                          height: MediaQuery.of(context).size.height * 0.25,
                          autoPlay: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            GestureDetector(
                          onTap: () async {
                            final url = snapshot.data!.docs[itemIndex]
                                .data()["url"]
                                .toString();
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 1, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                        snapshot.data!.docs[itemIndex]
                                            .data()["imageUrl"]
                                            .toString(),
                                        fit: BoxFit.fill) ??
                                    Image.asset("images/logo.jpeg",
                                        fit: BoxFit.fill
                                    )),
                          ),
                        ),
                        // imageUrls.map((i) {
                        //   return Container(
                        //     margin: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Colors.grey.shade200),
                        //     child: ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.network(  snapshot.data!.docs[index]
                        //             .data()["imageUrl"]
                        //             .toString(),
                        //             , fit: BoxFit.fill)),
                        //   );
                        // }).toList(),
                      ),
                    );

                    // ListView.builder(
                    //   addAutomaticKeepAlives: true,
                    //   shrinkWrap: true,
                    //   controller: ScrollController(keepScrollOffset: true),
                    //   scrollDirection: Axis.vertical,
                    //   itemCount: snapshot.data!.docs.length,
                    //   itemBuilder: (ctx, index) => Container(
                    //     margin:
                    //     EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: Colors.grey.shade200),
                    //     child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(10),
                    //         child: Image.network(
                    //             snapshot.data!.docs[index]
                    //                 .data()["imageUrl"]
                    //                 .toString(),
                    //             fit: BoxFit.fill)),
                    //   ),
                    // );
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.grey.shade300,
                        strokeWidth: 1.5,
                      ));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: ScrollController(keepScrollOffset: true),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width > webScreenSize ? width * 0.3 : 0,
                          vertical: width > webScreenSize ? 15 : 0,
                        ),
                        child: PostCard(
                          snap: snapshot.data!.docs[index].data(),
                          onshareingbtnPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return Container(
                                    color: Colors.transparent,
                                    child: Container(
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                (snapshot.data! as dynamic)
                                                    .docs
                                                    .length,
                                            itemBuilder: (context, index) =>
                                                Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: Column(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                              (snapshot.data!
                                                                      as dynamic)
                                                                  .docs[index][
                                                                      'photoUrl']
                                                                  .toString(),
                                                            ),
                                                            radius: 40,
                                                          ),
                                                          Text(
                                                              (snapshot.data!
                                                                      as dynamic)
                                                                  .docs[index][
                                                                      'username']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF000000),
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontFamily:
                                                                      'Roboto')),
                                                          // Text(
                                                          //   (snapshot.data! as dynamic)
                                                          //       .docs[index]['university']
                                                          //       .toString(),
                                                          // )
                                                        ],
                                                      ),
                                                    )),
                                          );
                                        },
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20))),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            )
            // : Center(
            //     child: CircularProgressIndicator(
            //     color: Colors.grey.shade300,
            //     strokeWidth: 1.5,
            //   )),
            );
  }
}
