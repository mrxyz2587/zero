import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zero_fin/widgets/dialog_progress_indicator.dart';
import '../constants.dart';
import '../widgets/bottom_sheet.dart';
import '/resources/auth_methods.dart';
import '/responsive/mobile_screen_layout.dart';
import '/responsive/responsive_layout.dart';
import '/responsive/web_screen_layout.dart';
import '/screens/signup_screen.dart';
import '/utils/colors.dart';
import '/utils/global_variable.dart';
import '/utils/utils.dart';
import '/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = '/loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      final int dialogOpen = prefs.getInt('show_dialog') ?? 0;
      if (dialogOpen == 0) {
        setState(() {
          showDialog(
              context: context,
              builder: (BuildContext ctx) => AlertDialog(
                    title: Text('Location Access'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'ok',
                            style: TextStyle(color: btnCOlorblue),
                          ))
                    ],
                    content: Text(
                        'Zero app collects location data to enable find near by buddies & showing near by restuarants '
                        'even when the app is closed or not in use'),
                  ));
        });
        prefs.setInt("show_dialog", 1);
      }
    });
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final credentials = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) {
      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid.toString())
          .get();
      print(value.user!.uid.toString() + 'laura');

      if (doc != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignupScreen()));
      }
    });

    // if (docexist) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => ResponsiveLayout(
    //               mobileScreenLayout: MobileScreenLayout(),
    //               webScreenLayout: WebScreenLayout())));
    // }
  }

  bool showDone = false;
  int num = 0;
  CarouselController _pageController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 1,
          child: CarouselSlider(
            carouselController: _pageController,
            items: [
              Image.asset('images/login_one.png',
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width),
              Image.asset('images/login_two.png',
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width),
              Image.asset('images/login_three.png',
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width),
            ],
            options: CarouselOptions(
                padEnds: false,
                viewportFraction: 1,
                height: MediaQuery.of(context).size.height,
                autoPlay: true,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    num = index;
                  });
                }),
          ),
        ),
        Align(
          heightFactor: 29,
          child: AnimatedSmoothIndicator(
            activeIndex: num,
            count: 3,
            axisDirection: Axis.horizontal,
            effect: SlideEffect(
                spacing: 8.0,
                radius: 4.0,
                dotWidth: 23.0,
                dotHeight: 3.0,
                dotColor: Color(0xFF4F4F4F).withOpacity(0.64),
                activeDotColor: Colors.white),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            ),
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF3D3939),
                        borderRadius: BorderRadius.circular(2)),
                    width: 69,
                    height: 3,
                  ),
                  GestureDetector(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: Container(
                      width: 322,
                      height: 47,
                      decoration: BoxDecoration(
                        color: Color(0xFF4286F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.google,
                                  color: Color(0xFF4286F5),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Text(
                              'Continue with Google',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto'),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                          ]),
                    ),
                  )
                ]),
          ),
        )
      ]),
    );
  }
}
