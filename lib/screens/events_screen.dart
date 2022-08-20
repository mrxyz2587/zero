import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/events_model.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/event_item.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  var name;
  File? file;
  Uint8List? _file;
  bool isSubmitted = false;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Builder(builder: (BuildContext context) {
            return Scaffold(
                appBar: AppBar(
                    elevation: 1,
                    backgroundColor: Colors.white,
                    leading: Icon(FontAwesomeIcons.graduationCap,
                        color: Colors.black),
                    title: Text(
                      'Courses & Events',
                      style: TextStyle(color: Colors.black),
                    )),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: RaisedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  allowMultiple: false,
                                  allowCompression: true,
                                  type: FileType.custom,
                                  allowedExtensions: ["pdf"]);
                          if (result != null) {
                            File c = File(result.files.single.path.toString());

                            setState(() {
                              file = c;
                              name = result.names.toString();
                            });
                            String res =
                                await FireStoreMethods().UploadResume(file!);
                          }
                          // if (result != null) {
                          //   Uint8List? fileBytes = result.files.first.bytes;
                          //   String fileName = result.files.first.name;
                          //   setState(() {
                          //     _file = fileBytes;
                          //
                          //     isLoading = true;
                          //   });
                          //   // Upload file
                          //   try {
                          //     String res =
                          //         await FireStoreMethods().UploadResume(_file!);
                          //     if (res == "success") {
                          //       setState(() {
                          //         isLoading = false;
                          //       });
                          //       showSnackBar(
                          //         context,
                          //         'Posted!',
                          //       );
                          //     } else {
                          //       showSnackBar(context, res);
                          //     }
                          //   } catch (err) {
                          //     setState(() {
                          //       isLoading = false;
                          //     });
                          //     showSnackBar(
                          //       context,
                          //       err.toString(),
                          //     );
                          //   }
                          // }

                          // FilePickerResult? result =
                          //     await FilePicker.platform.pickFiles(
                          //   type: FileType.custom,
                          //   allowedExtensions: ["pdf"],
                          //   allowCompression: true,
                          // );
                          //
                          // if (result != null) {
                          //   PlatformFile? file = result.files.first;
                          // } else {
                          //   // User canceled the picker
                          // }
                        },
                        child: isSubmitted
                            ? Text('Uploaded',
                                style: TextStyle(color: Colors.white))
                            : Text('upload Resume',
                                style: TextStyle(color: Colors.white)),
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('events')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          controller: ScrollController(keepScrollOffset: true),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) => Container(
                            child: EventItem(
                              snap: snapshot.data!.docs[index].data(),
                              onpressed: () {
                                showModalBottomSheet(
                                  enableDrag: true,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.2),
                                  context: context,
                                  builder: (BuildContext c) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 80),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.1),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  topLeft:
                                                      Radius.circular(20))),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: btnCOlorblue,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Image.network(
                                                snapshot.data!.docs[index]
                                                    .data()["imageUrl"]
                                                    .toString(),
                                              ),
                                              Text(
                                                snapshot.data!.docs[index]
                                                    .data()["evetitle"]
                                                    .toString(),
                                              ),
                                              Text(
                                                snapshot.data!.docs[index]
                                                    .data()["evedescc"]
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ));
          });
        });
  }
}
