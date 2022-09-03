import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '/responsive/mobile_screen_layout.dart';
import '/responsive/responsive_layout.dart';
import '/responsive/web_screen_layout.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zero_fin/screens/login_screen.dart';
import 'constants.dart';

class Splash extends StatefulWidget {
  static const id = '/SplashScreen';
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
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
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
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
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.longestSide / 9),
              child: Image(
                fit: BoxFit.scaleDown,
                image: AssetImage('images/zero_logo.png'),
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
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(0),
              //       child: Image.asset('images/logo.jpeg', height: 40),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(bottom: 8, left: 0.5),
              //       child: Text(
              //         'ERO',
              //         style: TextStyle(
              //             color: Color(0xFF000000),
              //             fontSize: 20,
              //             fontWeight: FontWeight.w700,
              //             fontFamily: 'Comfortaa'),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
