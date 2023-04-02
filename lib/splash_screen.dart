import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zero_fin/resources/firebase_dynamic_links.dart';
import 'package:zero_fin/screens/email_verification.dart';

import '/responsive/mobile_screen_layout.dart';
import '/responsive/responsive_layout.dart';
import '/responsive/web_screen_layout.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zero_fin/screens/login_screen.dart';

class Splash extends StatefulWidget {
  static const id = '/SplashScreen';
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String uid = "";
  void initState() {
    super.initState();
    process();
  }

/*
* Void process first checks the network state of the mobile and then accordingly pushes the user to next screen
* or pritns a snackbar this  method is called in initstate. In timer function we also check that user isalready logged in or not
* using snapshot.ConnectionState
*
* */
  @override
  void process() async {
    await DataConnectionChecker().onStatusChange.listen((event) {
      switch (event) {
        case DataConnectionStatus.connected:
          Timer(
            Duration(seconds: 5),
            () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      // Checking if the snapshot has any data or not
                      if (snapshot.hasData) {
                        // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                        if (FirebaseAuth.instance.currentUser!.emailVerified)
                          return ResponsiveLayout(
                              mobileScreenLayout: MobileScreenLayout(),
                              webScreenLayout: WebScreenLayout());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      }
                    }

                    // means connection to future hasnt been made yet
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return LoginScreen();
                  },
                );
              }));
              dispose();
            },
          );
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
      // if (DataConnectionStatus.connected ==) {
      // }
      // if (DataConnectionStatus.disconnected == true) {
      //   setState(() {
      //     Builder(
      //       builder: (BuildContext context) => SnackBar(
      //         content: Text("Please CheckYour Network"),
      //       ),
      //     );
      //   });
      // }
    });

    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
    } else {
      print('No internet :( Reason:');

      print(DataConnectionChecker().connectionStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: SizedBox()),
            Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.longestSide / 9),
              child: Image(
                height: 110,
                width: 110,
                fit: BoxFit.scaleDown,
                image: AssetImage(
                  'images/zero_logo.png',
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Center(
              child: Text(
                'from',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFACACAC),
                    fontSize: 15,
                    fontFamily: 'Roboto'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset('images/capture.PNG', height: 30, width: 50),
            ),
          ],
        ),
      ),
    );
  }
}
