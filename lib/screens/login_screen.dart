import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

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

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: Image(
                  image: AssetImage('images/zero_logo.png'), height: 100)),
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
          // TextFormField(
          //   key: _emailFormKey,
          //   decoration: InputDecoration(
          //       hintText: 'Enter your mail ID',
          //       hintStyle:
          //           TextStyle(color: Color.fromARGB(88, 0, 0, 0)),
          //       border: InputBorder.none,
          //       fillColor: Color(0xFFDBDCDC)),
          //   controller: emailController,
          //   cursorColor: Colors.black,
          //   cursorHeight: 25.sp,
          // ),
          SizedBox(height: 15),

          GestureDetector(
            onTap: () {
              setState(() {
                (_emailController.text.isEmpty ||
                        !_emailController.text.contains('@'))
                    ? showAlertDialog()
                    : checkData();
              });
            },
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
                child: Text('Login',
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 15,
                        fontFamily: 'Roboto')),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       vertical: 8.0, horizontal: 40),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       setState(() {
          //         _emailController.text.isEmpty ||
          //                 !_emailController.text.contains('@')
          //             ? showAlertDialog()
          //             : checkEmail();
          //       });
          //     },
          //     child: Text(
          //       'Login',
          //       style: TextStyle(
          //           color: Color(0xFFFFFFFF), fontSize: 16.sp),
          //     ),
          //     style: ElevatedButton.styleFrom(
          //       padding: EdgeInsets.all(16),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(13.r)),
          //       primary: Color(0xFF000000),
          //     ),
          //   ),
          // ),
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
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       horizontal: 8.0, vertical: 20),
          //   child: TextButton(
          //       onPressed: () {},
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: const [
          //           Image(
          //             image: AssetImage('images/gmail_icon.png'),
          //             height: 30,
          //             width: 30,
          //           ),
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Text(
          //             'Log in using Google',
          //             style: TextStyle(
          //                 fontSize: 15, color: Color(0xFFA3A3A3)),
          //           )
          //         ],
          //       )),
          // ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignupScreen(),
              ),
            ),
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
                child: Text('Sign Up',
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 15,
                        fontFamily: 'Roboto')),
              ),
            ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       child: const Text(
          //         'Dont have an account?',
          //       ),
          //       padding: const EdgeInsets.symmetric(vertical: 8),
          //     ),
          //     GestureDetector(
          //       onTap: () => Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (context) => const SignupScreen(),
          //         ),
          //       ),
          //       child: Container(
          //         child: const Text(
          //           ' Signup.',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         padding: const EdgeInsets.symmetric(vertical: 8),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );

    // body: SafeArea(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Flexible(
    //         child: Container(),
    //         flex: 2,
    //       ),
    //       SvgPicture.asset(
    //         'assets/ic_instagram.svg',
    //         color: primaryColor,
    //         height: 64,
    //       ),
    //       const SizedBox(
    //         height: 64,
    //       ),
    //       TextFieldInput(
    //         hintText: 'Enter your email',
    //         textInputType: TextInputType.emailAddress,
    //         textEditingController: _emailController,
    //       ),
    //       const SizedBox(
    //         height: 24,
    //       ),
    //       TextFieldInput(
    //         hintText: 'Enter your password',
    //         textInputType: TextInputType.text,
    //         textEditingController: _passwordController,
    //         isPass: true,
    //       ),
    //       const SizedBox(
    //         height: 24,
    //       ),
    //       InkWell(
    //         child: Container(
    //           child: !_isLoading
    //               ? const Text(
    //                   'Log in',
    //                 )
    //               : const CircularProgressIndicator(
    //                   color: primaryColor,
    //                 ),
    //           width: double.infinity,
    //           alignment: Alignment.center,
    //           padding: const EdgeInsets.symmetric(vertical: 12),
    //           decoration: const ShapeDecoration(
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(4)),
    //             ),
    //             color: blueColor,
    //           ),
    //         ),
    //         onTap: loginUser,
    //       ),
    //       const SizedBox(
    //         height: 12,
    //       ),
    //       Flexible(
    //         child: Container(),
    //         flex: 2,
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Container(
    //             child: const Text(
    //               'Dont have an account?',
    //             ),
    //             padding: const EdgeInsets.symmetric(vertical: 8),
    //           ),
    //           GestureDetector(
    //             onTap: () => Navigator.of(context).push(
    //               MaterialPageRoute(
    //                 builder: (context) => const SignupScreen(),
    //               ),
    //             ),
    //             child: Container(
    //               child: const Text(
    //                 ' Signup.',
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //               padding: const EdgeInsets.symmetric(vertical: 8),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // ),
  }

  void checkData() async {
    var userData = FirebaseFirestore.instance
        .collection(
          'users',
        )
        .where(
          'email',
          isEqualTo: _emailController.text,
        )
        .get()
        .then((event) {
      for (var docs in event.docs) {
        if (docs.data()['email'].toString() == _emailController.text) {
          loginUser();
        } else {}
      }
    });
    var useData = FirebaseFirestore.instance
        .collection(
          'users',
        )
        .where('email', isNotEqualTo: _emailController.text)
        .get()
        .then((event) {
      for (var docs in event.docs) {
        if (docs.data()['email'].toString() != _emailController.text) {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => SignupScreen()));
        }
      }
    });
  }

  void checkEmail() {
    if (!_isLoading) {}
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
