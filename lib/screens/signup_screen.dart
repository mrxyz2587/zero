import 'dart:ffi';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/screens/email_verification.dart';
import '../widgets/selection_container.dart' as sc;
import '/resources/auth_methods.dart';
import '/responsive/mobile_screen_layout.dart';
import '/responsive/responsive_layout.dart';
import '/responsive/web_screen_layout.dart';
import '/screens/login_screen.dart';
import '/utils/colors.dart';
import '/utils/global_variable.dart';
import '/utils/utils.dart';
import '/widgets/text_field_input.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  final GoogleSignInAccount? userObj;

  SignupScreen({Key? key, required this.userObj}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _universitycontroller = TextEditingController();
  String selectedText = "department";

  var dats = {};
  bool _isLoading = false;
  String designation = "designation";
  String department = "";
  String university = "";
  Uint8List? _image;
  DateTime? _selectedDate;
  String dobString = "Date Of Birth";
  String? selectedValueSingleDialog;
  bool checkDataDialog = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  final dbref = FirebaseFirestore.instance;
  // void checkData() async {
  //   String res = "Some error occurred";
  //   var userData = dbref
  //       .collection(
  //         'unregisteredUsers',
  //       )
  //       .where(
  //         'email',
  //         isEqualTo: _emailController.text,
  //       )
  //       .get()
  //       .then((event) {
  //     for (var docs in event.docs) {
  //       department = docs.data()['department'].toString();
  //       university = docs.data()['university'].toString();
  //       designation = docs.data()['designation'].toString();
  //       if (docs.data()['email'].toString() == _emailController.text) {
  //       } else {}
  //     }
  //   });
  //
  //   var useData = dbref
  //       .collection(
  //         'unregisteredUsers',
  //       )
  //       .where('email', isNotEqualTo: _emailController.text)
  //       .get()
  //       .then((event) {
  //     for (var docs in event.docs) {
  //       if (docs.data()['email'].toString() != _emailController.text) {
  //         // Navigator.pop(context);
  //         // alertBOxNotifiying(context, "ENETERE");
  //       }
  //     }
  //   });
  // }

  selectImage(ImageSource imageSource) async {
    Uint8List im = await pickImage(imageSource);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    print('signUp called');
    String res = await AuthMethods().signUpUser(
        email: widget.userObj!.email.toString(),
        password: _passwordController.text,
        username: _usernameController.text.isEmpty
            ? widget.userObj!.displayName.toString()
            : _usernameController.text,
        designation: designation,
        dateOfBirth:
            DateFormat.yMMMMd('en_US').format(_selectedDate!).toString(),
        department: selectedText,
        file: _image!,
        university: _universitycontroller.text,
        googlephotoUrls: widget.userObj!.displayName.toString());
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout())),
        (route) => false,
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
    // set loading to true

    //
    // String res = await AuthMethods().signUpUser(
    //     email: _emailController.text,
    //     password: _passwordController.text,
    //     username: _usernameController.text,
    //     designation: "_designationController.text",
    //     dateOfBirth:
    //         DateFormat.yMMMMd('en_US').format(_selectedDate!).toString(),
    //     department: "_deptController.text",
    //     file: _image!);
    // // if string returned is sucess, user has been created
    // if (res == "success") {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   // navigate to the home screen
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => const ResponsiveLayout(
    //         mobileScreenLayout: MobileScreenLayout(),
    //         webScreenLayout: WebScreenLayout(),
    //       ),
    //     ),
    //   );
    // } else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   // show the error
    //   showSnackBar(context, res);
    // }
  }

  // selectImage(ImageSource imageSource) async {
  //   Uint8List im = await pickImage(imageSource);
  //   // set state because we need to display the image we selected on the circle avatar
  //   setState(() {
  //     _image = im;
  //   });
  // }
  @override
  void initState() {
    super.initState();
  }

  alertBOxNotifiying(context, text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              scrollable: false,
              backgroundColor: Colors.white,
              title: Text(text),
              content: Center(child: Text(text)),
            ));
  }

  alertProgressIndicator(context, text) {
    showDialog(
        barrierDismissible: false,
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

  bottomSheet2(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext c) {
        return Container(
          color: Color(0xFFA3A3A3),
          height: 200,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5))),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: btnCOlorblue,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Choose Profile Picture",
                  style: TextStyle(fontSize: 18.0, color: Colors.black54),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.camera),
                            iconSize: 40,
                            onPressed: () {
                              selectImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                          Text('Camera'),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.image, semanticLabel: 'Gallery'),
                            iconSize: 40,
                            onPressed: () {
                              selectImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          ),
                          Text('Gallery'),
                        ]),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onbackPressed() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 60),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFDFDFDF),
                    radius: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                                widget.userObj!.photoUrl.toString())),
                      ),
                    ),
                  ),
                  onTap: () {
                    bottomSheet2(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Create your account ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Comfortaa'),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextFieldInput(
                  hintText: widget.userObj!.displayName.toString(),
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                  isPass: false,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFFF2F2F2),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      side: BorderSide(width: 1.5, color: Color(0xFFD9D8D8)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE-CSCQ"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE-CSCQ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE-AIML"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE-AIML";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child:
                                            Text("B.Tech + MBA (Integrated)"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "B.Tech + MBA (Integrated)";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma CSE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "Diploma CSE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child:
                                            Text("Doctor of Philosophy - CSE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Doctor of Philosophy - CSE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("M.Tech CSE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "M.Tech CSE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE-DS"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE-DS";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("M.Tech Thermal Engg"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "M.Tech Thermal Engg";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("M.Tech SE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "M.Tech SE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CSE-FSD"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CSE-FSD";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech CE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech CE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma CE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "Diploma CE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech PE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech PE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech ME"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech ME";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma ME"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "Diploma ME";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech ME-ROBO"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech ME-ROBO";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech EE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech EE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma EE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "Diploma EE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("B.Tech ECE"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "B.Tech ECE";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Computer Applications"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Computer Applications";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Master of Computer Applications"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Master of Computer Applications";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Business Administration"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Business Administration";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Master of Business Administration"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Master of Business Administration";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "BBA+MBA (Family Business Management)"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "BBA+MBA (Family Business Management)";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Bachelor of Commerce"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Commerce";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Arts (Hons) in Economics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Arts (Hons) in Economics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Arts (Hons) in English"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Arts (Hons) in English";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science (Hons) in Mathematics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science (Hons) in Mathematics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science (Hons) in Chemistry"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science (Hons) in Chemistry";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Arts (Hons) in Psychology"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Arts (Hons) in Psychology";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science (Hons) in Physics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science (Hons) in Physics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science (Hons) in Agriculture"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science (Hons) in Agriculture";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Arts (Hons) in Journalism and Mass Communication"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Arts (Hons) in Journalism and Mass Communication";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in Animation and VFX"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in Animation and VFX";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in UI and Graphics Design"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in UI and Graphics Design";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in UI and Graphics Design"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in UI and Graphics Design";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Master of Science in Nutrition and Dietetics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Master of Science in Nutrition and Dietetics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in Medical Radiology and Imaging Technology"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in Medical Radiology and Imaging Technology";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Bachelor of Pharmacy"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Pharmacy";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Medical Lab Technology"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Medical Lab Technology";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Science in Nutrition and Dietetics"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Science in Nutrition and Dietetics";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Diploma in Pharmacy"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Diploma in Pharmacy";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Integrated Bachelor of Business Administration and Bachelor of Law (Hons)"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Integrated Bachelor of Business Administration and Bachelor of Law (Hons)";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Integrated Bachelor of Arts and Bachelor of Law (Hons)"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Integrated Bachelor of Arts and Bachelor of Law (Hons)";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Certificate Course in Hotel Management"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Certificate Course in Hotel Management";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Bachelor of Hotel Management"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Bachelor of Hotel Management";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Post Graduate Diploma in Maritime Business Management"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Post Graduate Diploma in Maritime Business Management";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text(
                                            "Doctor of Philosophy - Management"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Doctor of Philosophy - Management";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Others"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText =
                                                "Less Popular Department";
                                          });
                                          Navigator.pop(context);
                                        }),
                                  ]),
                            ),
                          );
                        },
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedText,
                        style:
                            TextStyle(color: Color(0xFFA3A3A3), fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFFF2F2F2),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      side: BorderSide(width: 1.5, color: Color(0xFFD9D8D8)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          enableDrag: true,
                          isScrollControlled: true,
                          isDismissible: true,
                          builder: (BuildContext ctx) {
                            return Container(
                              color: Colors.black.withOpacity(0.1),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        topLeft: Radius.circular(5))),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          designation = "Student";
                                        });
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        ' Student',
                                        style: TextStyle(
                                            color: Color(0xFFA3A3A3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          designation = "Faculty";
                                        });
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        'Faculty',
                                        style: TextStyle(
                                            color: Color(0xFFA3A3A3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          designation = "Mentor";
                                        });
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        'Mentor',
                                        style: TextStyle(
                                            color: Color(0xFFA3A3A3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            );
                          });
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        designation.toString(),
                        style:
                            TextStyle(color: Color(0xFFA3A3A3), fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                TextFieldInput(
                  textEditingController: _universitycontroller,
                  hintText: 'university name',
                  textInputType: TextInputType.text,
                  isPass: false,
                ),

                // TextFieldInput(
                //   textEditingController: _designationController,
                //   hintText: 'Designation',
                //   textInputType: TextInputType.text,
                //   isPass: true,
                // ),
                // TextFieldInput(
                //   textEditingController: _deptController,
                //   hintText: 'department',
                //   textInputType: TextInputType.text,
                //   isPass: true,
                // ),
                // SelectionContainer(
                //     onPressing: () {
                //       print('pressed');
                //       showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return Dialog(
                //               shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(
                //                       12.0)), //this right here
                //               child: Container(
                //                 height: 300.h,
                //                 child: Column(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.start,
                //                   crossAxisAlignment:
                //                       CrossAxisAlignment.stretch,
                //                   children: <Widget>[
                //                     Padding(
                //                       padding: EdgeInsets.all(10.0),
                //                       child: Text(
                //                         'Select Designation',
                //                         style: TextStyle(
                //                             color: Colors.black,
                //                             fontWeight: FontWeight.bold,
                //                             fontSize: 20.sp),
                //                       ),
                //                     ),
                //                     TextButton(
                //                         onPressed: () {
                //                           Navigator.of(context).pop();
                //                         },
                //                         child: Text(
                //                           'Faculty',
                //                           style: TextStyle(
                //                               color: Colors.black,
                //                               fontSize: 18.sp),
                //                         )),
                //                     TextButton(
                //                         onPressed: () {
                //                           Navigator.of(context).pop();
                //                         },
                //                         child: Text(
                //                           'Developer',
                //                           style: TextStyle(
                //                               color: Colors.black,
                //                               fontSize: 20.0),
                //                         )),
                //                     TextButton(
                //                         onPressed: () {
                //                           Navigator.of(context).pop();
                //                         },
                //                         child: Text(
                //                           'Officer',
                //                           style: TextStyle(
                //                               color: Colors.black,
                //                               fontSize: 20.0),
                //                         )),
                //                     TextButton(
                //                         onPressed: () {
                //                           Navigator.of(context).pop();
                //                         },
                //                         child: Text(
                //                           'Student',
                //                           style: TextStyle(
                //                               color: Colors.black,
                //                               fontSize: 20.0),
                //                         )),
                //                     TextButton(
                //                         onPressed: () {
                //                           Navigator.of(context).pop();
                //                         },
                //                         child: Text(
                //                           'Influencer',
                //                           style: TextStyle(
                //                               color: Colors.black45,
                //                               fontSize: 20.0),
                //                         )),
                //                   ],
                //                 ),
                //               ),
                //             );
                //           });
                //     },
                //     title: "Designation",
                //     icon: Icons.keyboard_arrow_down_rounded),
                // SelectionContainer(
                //     onPressing: () {
                //
                //     },
                //     title: "Department",
                //     icon: Icons.keyboard_arrow_down_rounded),
                sc.SelectionContainer(
                    onPressing: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1901),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              backgroundColor: Colors.black,
                              colorScheme: ColorScheme.light(
                                background: Colors.black,

                                primary: Color(
                                    0xFF2B2B2B), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black,
                                // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: btnCOlorblue, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      ).then((pickedDate) {
                        if (pickedDate == null) return;
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      });
                    },
                    title: _selectedDate != null
                        ? DateFormat.yMMMMd('en_US')
                            .format(_selectedDate!)
                            .toString()
                        : dobString,
                    icon: Icons.calendar_month_rounded),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print("builder setStare");
                    });
                    if (_usernameController.text.isEmpty ||
                        _selectedDate == null ||
                        _image == null) {
                      showSnackBar(context, "Please fill all details");
                    } else {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                scrollable: false,
                                backgroundColor: Colors.white,
                                title: Text("Saving Profile"),
                                content: LinearProgressIndicator(
                                  color: Colors.blue,
                                ),
                              ));

                      signUpUser();
                    }
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
                      child: Text('Proceed',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 15,
                              fontFamily: 'Roboto')),
                    ),
                  ),
                ),
                Text('By Signing up you Agreeing all the'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String url = 'https://zeromonk.com/Terms&Condition';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                      child: Text(
                        'Terms and Conditions',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B57A4),
                            fontSize: 14),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String url = 'https://zeromonk.com/Privacy-Policy';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                      child: Text(
                        'and Privacy Policy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B57A4),
                            fontSize: 14),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   body: SafeArea(
    //     child: Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 32),
    //       width: double.infinity,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Flexible(
    //             child: Container(),
    //             flex: 2,
    //           ),
    //           SvgPicture.asset(
    //             'assets/ic_instagram.svg',
    //             color: primaryColor,
    //             height: 64,
    //           ),
    //           const SizedBox(
    //             height: 64,
    //           ),
    //           Stack(
    //             children: [
    //               _image != null
    //                   ? CircleAvatar(
    //                       radius: 64,
    //                       backgroundImage: MemoryImage(_image!),
    //                       backgroundColor: Colors.red,
    //                     )
    //                   : const CircleAvatar(
    //                       radius: 64,
    //                       backgroundImage: NetworkImage(
    //                           'https://i.stack.imgur.com/l60Hf.png'),
    //                       backgroundColor: Colors.red,
    //                     ),
    //               Positioned(
    //                 bottom: -10,
    //                 left: 80,
    //                 child: IconButton(
    //                   onPressed: selectImage,
    //                   icon: const Icon(Icons.add_a_photo),
    //                 ),
    //               )
    //             ],
    //           ),
    //           const SizedBox(
    //             height: 24,
    //           ),
    //           TextFieldInput(
    //             hintText: 'Enter your username',
    //             textInputType: TextInputType.text,
    //             textEditingController: _usernameController,
    //           ),
    //           const SizedBox(
    //             height: 24,
    //           ),
    //           TextFieldInput(
    //             hintText: 'Enter your email',
    //             textInputType: TextInputType.emailAddress,
    //             textEditingController: _emailController,
    //           ),
    //           const SizedBox(
    //             height: 24,
    //           ),
    //           TextFieldInput(
    //             hintText: 'Enter your password',
    //             textInputType: TextInputType.text,
    //             textEditingController: _passwordController,
    //             isPass: true,
    //           ),
    //           const SizedBox(
    //             height: 24,
    //           ),
    //           TextFieldInput(
    //             hintText: 'Enter your bio',
    //             textInputType: TextInputType.text,
    //             textEditingController: _bioController,
    //           ),
    //           const SizedBox(
    //             height: 24,
    //           ),
    //           InkWell(
    //             child: Container(
    //               child: !_isLoading
    //                   ? const Text(
    //                       'Sign up',
    //                     )
    //                   : const CircularProgressIndicator(
    //                       color: primaryColor,
    //                     ),
    //               width: double.infinity,
    //               alignment: Alignment.center,
    //               padding: const EdgeInsets.symmetric(vertical: 12),
    //               decoration: const ShapeDecoration(
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.all(Radius.circular(4)),
    //                 ),
    //                 color: blueColor,
    //               ),
    //             ),
    //             onTap: signUpUser,
    //           ),
    //           const SizedBox(
    //             height: 12,
    //           ),
    //           Flexible(
    //             child: Container(),
    //             flex: 2,
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Container(
    //                 child: const Text(
    //                   'Already have an account?',
    //                 ),
    //                 padding: const EdgeInsets.symmetric(vertical: 8),
    //               ),
    //               GestureDetector(
    //                 onTap: () => Navigator.of(context).push(
    //                   MaterialPageRoute(
    //                     builder: (context) => const LoginScreen(),
    //                   ),
    //                 ),
    //                 child: Container(
    //                   child: const Text(
    //                     ' Login.',
    //                     style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                   padding: const EdgeInsets.symmetric(vertical: 8),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
