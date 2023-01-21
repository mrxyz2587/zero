import 'dart:async';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_top/scroll_to_top.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/resources/firebase_dynamic_links.dart';
import 'package:zero_fin/screens/HomeScreen.dart';
import 'package:zero_fin/screens/profile_screen.dart';
import 'package:zero_fin/screens/search_screen.dart';
import '../providers/user_provider.dart';
import '../utils/local_notification_services.dart';
import '/utils/colors.dart';
import '/utils/global_variable.dart';
import '/widgets/post_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'notice_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double longitude = 0;
  double latitude = 0;
  double otherlongitude = 0;
  double otherlatitude = 0;

  double distanceInMeters = 0;
  bool isLoading = true;
  bool isLoasdings = true;

  var searchController = TextEditingController();

  bool isSended = false;

  bottomSheetforshare(context, String txt) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
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
                    topRight: Radius.circular(8), topLeft: Radius.circular(8))),
            width: MediaQuery.of(context).size.width,
            height: 700,
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                        borderSide: BorderSide(
                            color: const Color(0xFFD9D8D8), width: 1.5),
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
                      setState(() {});
                    },
                    onFieldSubmitted: (String _) {
                      setState(() {});
                      print(_);
                    },
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.white,
                            child: SizedBox(
                              height: 60,
                              child: ListTile(
                                trailing: isSended == false
                                    ? TextButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: btnCOlorblue,
                                            minimumSize: Size(75, 12),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        onPressed: () {
                                          setState(() {
                                            isSended = !isSended;
                                          });
                                        },
                                        child: Text(
                                          isSended == false ? "Send" : "sent",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ))
                                    : TextButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            minimumSize: Size(75, 12),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        onPressed: () {
                                          setState(() {
                                            isSended = !isSended;
                                          });
                                        },
                                        child: Text(
                                          "sent",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700),
                                        )),
                                title: Text(
                                    (snapshot.data! as dynamic)
                                        .docs[index]['username']
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Roboto')),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic)
                                        .docs[index]['photoUrl']
                                        .toString(),
                                  ),
                                  radius: 20,
                                ),
                                subtitle: Text(
                                    (snapshot.data! as dynamic)
                                        .docs[index]['university']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 13, fontFamily: 'Roboto')),
                              ),
                            ),
                          )),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

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

    getLocation();
    setStatus("Online");

    storeNotificationToken();
    super.initState();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
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
        });
        print(longitude.toString() + "" + latitude.toString());
      }
    });
    getdistance();

    isLoading = false;
  }

  int i = 0;

  void getdistance() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var docs in value.docs) {
        if (docs.data()["uid"].toString() !=
            FirebaseAuth.instance.currentUser!.uid.toString()) {
          otherlatitude = double.parse(docs.data()['latitudeCoordinates']);
          otherlongitude = double.parse(docs.data()['longCoordinates']);
          print(otherlongitude.toString() + otherlatitude.toString());
          distanceInMeters = Geolocator.distanceBetween(
              latitude, longitude, otherlatitude, otherlongitude);
          print("distance$distanceInMeters  $i");
          i++;
        }
      }
    });
  }

  bool badgeShown = false;
  void getData() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      setState(() {
        isLoasdings = false;
      });
    });
    _firestore
        .collection('notifications')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('allNotifications')
        .orderBy('time', descending: true)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.single.data()['isSeen'] == false) {
        setState(() {
          badgeShown = true;
        });
      } else {
        setState(() {
          badgeShown = false;
        });
      }
    });
  }

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final ScrollController _scrollController =
        ScrollController(keepScrollOffset: true);
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
              elevation: 0.6,
              backgroundColor: mobileBackgroundColor,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: userProvider.getUser.uid,
                      ),
                    ),
                  );
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
              title: Image.asset('images/logoofzeroappbar.png', height: 38),
              actions: [
                IconButton(
                  icon: Badge(
                    ignorePointer: true,
                    badgeContent: Text('1',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold)),
                    position: BadgePosition.topEnd(),
                    shape: BadgeShape.circle,
                    showBadge: badgeShown,
                    child: const Icon(
                      FontAwesomeIcons.solidBell,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoticeScreen()));
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
            body: ScrollToTop(
              scrollController: _scrollController,
              btnColor: Colors.white70,
              txtColor: Colors.black87,
              scrollOffset: 1000,
              child: ListView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
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
                                          fit: BoxFit.fill)),
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
                        .orderBy('timestamp', descending: true)
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
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width > webScreenSize ? width * 0.3 : 0,
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
            )
            // : Center(
            //     child: CircularProgressIndicator(
            //     color: Colors.grey.shade300,
            //     strokeWidth: 1.5,
            //   )),
            );
  }
}
