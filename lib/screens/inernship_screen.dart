import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/widgets/course_item.dart';
import 'package:zero_fin/widgets/internship_card.dart';

import '../models/events_model.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/event_item.dart';

class InternshipScreen extends StatefulWidget {
  const InternshipScreen({Key? key}) : super(key: key);

  @override
  State<InternshipScreen> createState() => _InternshipScreenState();
}

class _InternshipScreenState extends State<InternshipScreen> {
  var name;
  File? file;
  Uint8List? _file;
  bool isSubmitted = false;
  String selectedText = " ";

  String quizUrl = "https://www.xnxx.com/";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  String imageUrl = "";
  void getdata() async {
    try {
      await FirebaseFirestore.instance
          .collection('applyIntershipCardd')
          .doc('applyCard')
          .get()
          .then((value) {
        imageUrl = value.data()!["imageUrl"].toString();
        print(imageUrl.toString());
        quizUrl = value.data()!["quizUrl"].toString();
      });
      setState(() {
        isSubmitted = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isReg = false;

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Builder(builder: (BuildContext context) {
            return Scaffold(
                backgroundColor: Color(0xFFEFEFEF),
                appBar: AppBar(
                    elevation: 1,
                    backgroundColor: Colors.white,
                    leading: Icon(FontAwesomeIcons.graduationCap,
                        color: Colors.black),
                    title: Text(
                      'Internships',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () async {
                            if (await canLaunch('quizUrl')) {
                              await launch('quizUrl',
                                  enableDomStorage: true,
                                  enableJavaScript: true,
                                  forceWebView: true);
                            }
                          },
                          icon: Icon(
                            FontAwesomeIcons.circlePlus,
                            color: webBackgroundColor,
                          ))
                    ]),
                body: isSubmitted
                    ? ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 0, right: 25, left: 25, top: 10),
                            child: InkWell(
                              onTap: () async {
                                if (await canLaunch(quizUrl)) {
                                  await launch(quizUrl,
                                      enableDomStorage: true,
                                      enableJavaScript: true,
                                      forceWebView: true);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 3,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: Image(
                                      image: NetworkImage(
                                        imageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: SingleChildScrollView(
                                      child: Column(children: [
                                        SimpleDialogOption(
                                            child: Text("all Courses"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText = " ";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text(
                                                "Computer Sciences & Engineering"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "B.Tech CSE-AIML";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text(
                                                "Civil & Petroleum Engineering"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Civil & Petroleum Engineering";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child:
                                                Text("Mechanical  Engineering"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText = "B.tech ME-ROBO";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text(
                                                "Electrical & Electronics Engineering"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Electrical & Electronics Engineering";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child:
                                                Text("Computer Applications"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Computer Applications";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child:
                                                Text("Business Administration"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Business Administration";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text("Media Studies"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText = "Media Studies";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text("Law"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText = "Law";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text("Commerce & Finance"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Commerce & Finance";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text("Sciences"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText = "Sciences";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text(
                                                "Humanities & Social Sciences"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Humanities & Social Sciences";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child:
                                                Text("Hospitality & Tourism"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Hospitality & Tourism";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text("Agricultural Studies"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Agricultural Studies";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text("Pharmacy"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText = "Pharmacy";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text(
                                                "Applied Medical Sciences"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Applied Medical Sciences";
                                              });
                                              Navigator.pop(context);
                                            }),
                                        SimpleDialogOption(
                                            child: Text("Paramedical Sciences"),
                                            onPressed: () {
                                              setState(() {
                                                selectedText =
                                                    "Paramedical Sciences";
                                              });
                                              Navigator.pop(context);
                                            }),
                                      ]),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Text(
                                "Filter",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: btnCOlorblue),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 40, vertical: 20),
                          //   child: RaisedButton(
                          //     onPressed: () async {
                          //       FilePickerResult? result = await FilePicker.platform
                          //           .pickFiles(
                          //               allowMultiple: false,
                          //               allowCompression: true,
                          //               type: FileType.custom,
                          //               allowedExtensions: ["pdf"]);
                          //       if (result != null) {
                          //         File c = File(result.files.single.path.toString());
                          //
                          //         setState(() {
                          //           file = c;
                          //           name = result.names.toString();
                          //         });
                          //         String res =
                          //             await FireStoreMethods().UploadResume(file!);
                          //       }
                          //       // if (result != null) {
                          //       //   Uint8List? fileBytes = result.files.first.bytes;
                          //       //   String fileName = result.files.first.name;
                          //       //   setState(() {
                          //       //     _file = fileBytes;
                          //       //
                          //       //     isLoading = true;
                          //       //   });
                          //       //   // Upload file
                          //       //   try {
                          //       //     String res =
                          //       //         await FireStoreMethods().UploadResume(_file!);
                          //       //     if (res == "success") {
                          //       //       setState(() {
                          //       //         isLoading = false;
                          //       //       });
                          //       //       showSnackBar(
                          //       //         context,
                          //       //         'Posted!',
                          //       //       );
                          //       //     } else {
                          //       //       showSnackBar(context, res);
                          //       //     }
                          //       //   } catch (err) {
                          //       //     setState(() {
                          //       //       isLoading = false;
                          //       //     });
                          //       //     showSnackBar(
                          //       //       context,
                          //       //       err.toString(),
                          //       //     );
                          //       //   }
                          //       // }
                          //
                          //       // FilePickerResult? result =
                          //       //     await FilePicker.platform.pickFiles(
                          //       //   type: FileType.custom,
                          //       //   allowedExtensions: ["pdf"],
                          //       //   allowCompression: true,
                          //       // );
                          //       //
                          //       // if (result != null) {
                          //       //   PlatformFile? file = result.files.first;
                          //       // } else {
                          //       //   // User canceled the picker
                          //       // }
                          //     },
                          //     child: isSubmitted
                          //         ? Text('Uploaded',
                          //             style: TextStyle(color: Colors.white))
                          //         : Text('upload Resume',
                          //             style: TextStyle(color: Colors.white)),
                          //     color: Colors.black,
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10)),
                          //   ),
                          // ),
                          StreamBuilder(
                            stream: selectedText == " "
                                ? FirebaseFirestore.instance
                                    .collection('coursesection')
                                    .doc('internship')
                                    .collection('allinternships')
                                    .snapshots()
                                : FirebaseFirestore.instance
                                    .collection('coursesection')
                                    .doc('internship')
                                    .collection('allinternships')
                                    .where('internshipcategory',
                                        isEqualTo: selectedText.toString())
                                    .snapshots(),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                controller:
                                    ScrollController(keepScrollOffset: true),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (ctx, index) => Container(
                                  child: InternshipCard(
                                    snap: snapshot.data!.docs[index].data(),
                                    onpressed: () {},
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Container());
          });
        });
  }
}
