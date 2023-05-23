import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zero_fin/screens/signup_screen.dart';

class DesignationSelectionPage extends StatefulWidget {
  final GoogleSignInAccount? userObj;
  DesignationSelectionPage({Key? key, required this.userObj}) : super(key: key);

  @override
  State<DesignationSelectionPage> createState() =>
      _DesignationSelectionPageState();
}

class _DesignationSelectionPageState extends State<DesignationSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/zero_logo.png',
                height: 90,
                width: 90,
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                child: Text('Choose your Profile',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                    'Your Profile level helps you to find your community &  your target audience',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignupScreen(
                            userObj: widget.userObj,
                            designation: 'student',
                          )));
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFB1B5B8),
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text('School Student',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 0.5),
                        softWrap: true,
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignupScreen(
                            userObj: widget.userObj,
                            designation: 'universitystudent',
                          )));
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFB1B5B8),
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      'University Student',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 0.5),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignupScreen(
                            userObj: widget.userObj,
                            designation: 'faculty',
                          )));
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFB1B5B8),
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text('Faculty',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 0.5),
                        softWrap: true,
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignupScreen(
                            userObj: widget.userObj,
                            designation: 'universitystudent',
                          )));
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFB1B5B8),
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text('Alumni',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 0.5),
                        softWrap: true,
                        textAlign: TextAlign.center),
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
