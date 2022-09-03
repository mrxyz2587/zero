import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/selection_container.dart';
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
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  var dats = {};
  bool _isLoading = false;
  String designation = "";
  String department = "";
  String university = "";
  Uint8List? _image;
  DateTime? _selectedDate;
  String dobString = "Date Of Birth";
  String? selectedValueSingleDialog;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  final dbref = FirebaseFirestore.instance;
  void checkData() async {
    var userData = dbref
        .collection(
          'unregisteredUsers',
        )
        .where(
          'email',
          isEqualTo: _emailController.text,
        )
        .get()
        .then((event) {
      for (var docs in event.docs) {
        department = docs.data()['department'].toString();
        university = docs.data()['university'].toString();
        designation = docs.data()['designation'].toString();
        if (docs.data()['email'].toString() == _emailController.text) {
          signUpUser();
        } else {
          print('please ask your college to register');
        }
      }
    });
    var useData = dbref
        .collection(
          'unregisteredUsers',
        )
        .where('email', isNotEqualTo: _emailController.text)
        .get()
        .then((event) {
      print('user college not registered');
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    print('signUp called');
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        designation: designation,
        dateOfBirth:
            DateFormat.yMMMMd('en_US').format(_selectedDate!).toString(),
        department: department,
        file: _image!,
        university: university);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
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

  selectImage(ImageSource imageSource) async {
    Uint8List im = await pickImage(imageSource);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  bottomSheet2(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext c) {
        return Container(
          color: Color(0xFFA3A3A3),
          height: 200.h,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5))),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 10.h,
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
                  style: TextStyle(fontSize: 18.0.sp, color: Colors.black54),
                ),
                SizedBox(
                  height: 20.h,
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
                            iconSize: 40.h,
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
                            iconSize: 40.h,
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

  void presentDatePicker(context) {}

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: LayoutBuilder(
                builder:((context, constraints) => 
                 SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFDFDFDF),
                              radius: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: _image != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: CircleAvatar(
                                            radius: 80,
                                            backgroundImage: MemoryImage(_image!)),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFF2F2F2)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Icon(
                                              Icons.camera_alt_rounded,
                                              size: 25,
                                              color: Colors.black26,
                                            ),
                                            Text(
                                              'Tap to click/select ',
                                              style: TextStyle(
                                                  color: Colors.black26, fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'your profile picture',
                                              style: TextStyle(
                                                  color: Colors.black26, fontSize: 12),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
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
                            hintText: 'Full name',
                            textInputType: TextInputType.text,
                            textEditingController: _usernameController,
                            isPass: false,
                          ),
                          TextFieldInput(
                            textEditingController: _emailController,
                            hintText: 'email',
                            textInputType: TextInputType.emailAddress,
                            isPass: false,
                          ),
                                    
                          TextFieldInput(
                            textEditingController: _passwordController,
                            hintText: 'password',
                            textInputType: TextInputType.text,
                            isPass: true,
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
                          SelectionContainer(
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
                          SizedBox(height: 30.h),
                          GestureDetector(
                            onTap: () {
                              signUpUser();
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
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
                                  Radius.circular(11.r),
                                ),
                              ),
                              child: Center(
                                child: Text('Proceed',
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 15.sp,
                                        fontFamily: 'Roboto')),
                              ),
<<<<<<< HEAD
                            ),
                          ),
                        ],
=======
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
                  SizedBox(height: 30.h),
                  GestureDetector(
                    onTap: () {
                      checkData();
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
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
                          Radius.circular(11.r),
                        ),
                      ),
                      child: Center(
                        child: Text('Proceed',
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 15.sp,
                                fontFamily: 'Roboto')),
>>>>>>> 31a0fb6ee9b760494e504631daa7b618ce39421b
                      ),
                    ),
                  ),
                )
                )
              ),
            ),
          );
        });
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
