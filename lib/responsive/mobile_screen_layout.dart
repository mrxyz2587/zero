import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zero_fin/screens/SharedPostDisplay.dart';
import 'package:zero_fin/screens/event_description_screen.dart';
import '../resources/firebase_dynamic_links.dart';
import '/utils/colors.dart';
import '/utils/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  PendingDynamicLinkData? data;
  MobileScreenLayout({Key? key, this.data}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout>
    with WidgetsBindingObserver {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) => handleLinkData());

    print('homeScreenCalled');
    WidgetsBinding.instance.addObserver(this);

    FirebaseMessaging.onMessage.listen((event) {
      print("Fcm Recieved");
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>['home_tappine']);
    });
  }

  String? userName;
  void handleLinkData() {
    final Uri? uri = widget.data?.link;
    if (uri != null) {
      if (uri.path == '/post') {
        final queryParams = uri.queryParameters;

        if (queryParams.length > 0) {
          userName = queryParams["postId"];

          // verify the username is parsed correctly

          print("My users username is: $userName");
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SharedPostsDiplay(postId: userName.toString());
        }));
      }

      if (uri.path == '/event') {
        final queryParams = uri.queryParameters;

        if (queryParams.length > 0) {
          userName = queryParams["eventSnap"];

          // verify the username is parsed correctly

          print("My users username is: $userName");
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EventDescriptionScreen(snap: userName.toString());
        }));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  Future<bool> _onbackPressed() async {
    if (_page == 0) {
      return true;
    } else {
      pageController.jumpToPage(0);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        body: PageView(
          children: homeScreenItems,
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 25,
          backgroundColor: mobileBackgroundColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  FontAwesomeIcons.house,
                  size: 22,
                  color: (_page == 0) ? btnCOlorblue : webBackgroundColor,
                ),
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 22,
                    color: (_page == 1) ? btnCOlorblue : webBackgroundColor,
                  ),
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Icon(
                    FontAwesomeIcons.circlePlus,
                    size: 25,
                    color: (_page == 2) ? btnCOlorblue : webBackgroundColor,
                  ),
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  FontAwesomeIcons.graduationCap,
                  size: 22,
                  color: (_page == 3) ? btnCOlorblue : webBackgroundColor,
                ),
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  FontAwesomeIcons.fireFlameCurved,
                  size: 22,
                  color: (_page == 4) ? btnCOlorblue : webBackgroundColor,
                ),
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
