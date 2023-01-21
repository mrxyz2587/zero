import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  bool showOnboardScreen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      final int dialogOpen = prefs.getInt('show_intro') ?? 0;
      if (dialogOpen == 0) {
        setState(() {
          showOnboardScreen = true;
        });
        prefs.setInt("show_intro", 1);
      }
    });
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

  void loginUser() async {
    setState(() {});

    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);

      setState(() {});
    } else {
      setState(() {});
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Please enter the correct credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  bool showDone = false;
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return showOnboardScreen == true
        ? Scaffold(
            body: Stack(fit: StackFit.expand, children: [
              PageView(
                onPageChanged: (val) {
                  if (val == 3) {
                    setState(() {
                      showDone = true;
                    });
                  }
                },
                controller: _pageController,
                children: [
                  Image.asset('images/screen_1.png', fit: BoxFit.fill),
                  Image.asset('images/screen_2.png', fit: BoxFit.fill),
                  Image.asset('images/screen_3.png', fit: BoxFit.fill),
                  Image.asset('images/screen_4.png', fit: BoxFit.fill),
                ],
              ),
              Container(
                alignment: Alignment(0, 0.95),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _pageController.jumpToPage(3);
                          });
                        },
                      ),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: WormEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            activeDotColor: Colors.white,
                            dotColor: Colors.black.withOpacity(0.1)),
                      ),
                      (showDone == true)
                          ? InkWell(
                              child: Container(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showOnboardScreen = false;
                                });
                              },
                            )
                          : InkWell(
                              child: Container(
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              onTap: () {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn);
                              },
                            ),
                    ]),
              )
            ]),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    fit: FlexFit.loose,
                    child: Image(
                        image: AssetImage('images/zero_logo.png'),
                        height: 100)),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Be 10 Times Better",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Comfortaa',
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                TextFieldInput(
                  hintText: 'password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      alertProgressIndicator(context, 'Loging In');

                      (_emailController.text.isEmpty ||
                              !_emailController.text.contains('@'))
                          ? showAlertDialog()
                          : loginUser();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2B2B2B),
                            Color(0xFF000000),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.all(
                        Radius.circular(11),
                      ),
                    ),
                    child: Center(
                      child: Text('Login',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 15,
                              fontFamily: 'Roboto')),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 1.5,
                        color: Colors.black45,
                        indent: 40,
                        endIndent: 20,
                      ),
                    ),
                    Text(
                      'or',
                      style: TextStyle(fontSize: 14, color: Color(0xFFA3A3A3)),
                    ),
                    Expanded(
                      child: Divider(
                        height: 1.5,
                        color: Colors.black45,
                        indent: 20,
                        endIndent: 40,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2B2B2B),
                            Color(0xFF000000),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.all(
                        Radius.circular(11),
                      ),
                    ),
                    child: Center(
                      child: Text('Create Account',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 15,
                              fontFamily: 'Roboto')),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  alertProgressIndicator(context, text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              scrollable: false,
              backgroundColor: Colors.white,
              title: Text(text),
              content: LinearProgressIndicator(
                color: Colors.blue,
              ),
            ));
  }

  void showAlertDialog() {
    Alert(
      context: context,
      title: "Enter a valid email",
      style: AlertStyle(
          descStyle: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
          descTextAlign: TextAlign.justify),
      desc: "Please enter your college domain email id "
          "or the email reistered by you in your college",
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: Colors.black,
        )
      ],
    ).show();
  }
}
