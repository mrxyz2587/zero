import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:open_mail_app/open_mail_app.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zero_fin/resources/auth_methods.dart';
import 'package:zero_fin/responsive/mobile_screen_layout.dart';
import 'package:zero_fin/responsive/web_screen_layout.dart';
import 'package:zero_fin/screens/login_screen.dart';
import 'package:zero_fin/utils/colors.dart';
import 'package:zero_fin/utils/utils.dart';

import '../responsive/responsive_layout.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  bool canSendEmailVerification = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        setState(() {
          checkEmailVerified();
        });
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    timer!.cancel();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer!.cancel();
    }
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      print(user.sendEmailVerification().toString());

      setState(() => canSendEmailVerification = false);
      await Future.delayed(Duration(seconds: 10));
      setState(() => canSendEmailVerification = true);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                  onPressed: (){
                    AuthMethods().signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => LoginScreen()));
                  },
                  icon: Icon(Icons.arrow_back_ios,),color: Colors.black),
              title: Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Row(
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
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 230,
                        width: 230,
                        child: Lottie.asset('images/LottieLogo1.json')),
                    Text(
                      "Please check your E-mail",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF000000),
                          fontSize: 19),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 40,right: 40),
                      child: Text(
                          "Email verification link has been sent to your email id. "
                          "Please check your inbox or spam folder",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () =>
                            canSendEmailVerification ? sendVerificationEmail() : {},
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                          padding: EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xFF2B2B2B),
                              Color(0xFF000000),
                            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                            borderRadius: BorderRadius.all(
                              Radius.circular(11),
                            ),
                          ),
                          child: Center(
                            child: Text('RESEND',
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 15,
                                    fontFamily: 'Roboto')),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () async {
                        // Android: Will open mail app or show native picker.
                        // iOS: Will open mail app if single mail app found.
                        var result = await OpenMailApp.openMailApp();

                        // If no mail apps found, show error
                        if (!result.didOpen && !result.canOpen) {
                          showNoMailAppsDialog(context);

                          // iOS: if multiple mail apps found, show dialog to select.
                          // There is no native intent/default app system in iOS so
                          // you have to do it yourself.
                        } else if (!result.didOpen && result.canOpen) {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return MailAppPickerDialog(
                                mailApps: result.options,
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 46),
                        padding: EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xFF2B2B2B),
                            Color(0xFF000000),
                          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                          borderRadius: BorderRadius.all(
                            Radius.circular(11),
                          ),
                        ),
                        child: Center(
                          child: Text('OPEN EMAIL APP',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 15,
                                  fontFamily: 'Roboto')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
