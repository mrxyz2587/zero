import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class AddReelsScreen extends StatefulWidget {
  File? filePath;

  AddReelsScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  State<AddReelsScreen> createState() => _AddReelsScreenState();
}

class _AddReelsScreenState extends State<AddReelsScreen> {
  late VideoPlayerController controller;
  bool isLoading = false;
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void postReels(String uid, String username, String profImage) async {
    print("post reels");

    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadReels(
        _descriptionController.text,
        widget.filePath!,
        uid,
        username,
        profImage,
      );
      print("entered");

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        print('posted');
        showSnackBar(
          context,
          'Posted!',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err.toString());
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.filePath!);
    });
    controller.initialize();
    isPaused ? controller.pause() : controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  bool isPaused = false;
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 5,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
            ),
            onPressed: () {
              _descriptionController.dispose();
              controller.dispose();
              Navigator.of(context).pop();
            },
          ),
        ),
        title: const Text('New Social Wall',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
              fontSize: 19,
            )),
        centerTitle: false,
      ),
      // POST FORM
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 15.0)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          userProvider.getUser.photoUrl,
                        ),
                        radius: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userProvider.getUser.username.toString(),
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto')),
                          SizedBox(height: 2),
                          Text('Quantum University, Roorkee',
                              style: TextStyle(
                                  color: Color(0xFF1F1F1F),
                                  fontSize: 10,
                                  fontFamily: 'Roboto'))
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side:
                                BorderSide(width: 1.2, color: Colors.lightBlue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        onPressed: () {},
                        child: Text(
                          'Edit Privacy',
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(0),
                          child: Icon(
                            FontAwesomeIcons.solidFaceSmile,
                            color: Color(0xFF5E5E5E),
                            size: 22,
                          ),
                        ),
                        hintText: "Write a caption...",
                        hintStyle: TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 15,
                            fontFamily: 'Roboto'),
                        border: InputBorder.none),
                  ),
                ),

                // GestureDetector(
                //   onTap: () {
                //     controller.pause();
                //   },
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     height: MediaQuery.of(context).size.height,
                //     child: VideoPlayer(controller),
                //   ),
                // ),
                // const Padding(
                //   padding: EdgeInsets.all(4.0),
                //   child: Center(
                //     child: Text('Social Wall',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w700,
                //           color: Color(0xFF000000),
                //           fontSize: 15,
                //         )),
                //   ),
                // ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 300,
                      width: 170,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPaused = !isPaused;
                            });
                            isPaused ? controller.pause() : controller.play();
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: VideoPlayer(controller))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Divider(thickness: 0.5, color: Colors.black12),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       vertical: 8.0, horizontal: 8.0),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(5),
                //     child: Stack(children: [
                //       Container(
                //         height: 300,
                //         decoration: BoxDecoration(
                //             image: DecorationImage(
                //           fit: BoxFit.fill,
                //           alignment: FractionalOffset.topCenter,
                //           image: MemoryImage(_file!),
                //         )),
                //       ),
                //       Positioned(
                //         right: 10,
                //         top: 10,
                //         child: GestureDetector(
                //           onTap: clearImage,
                //           child: Icon(
                //             FontAwesomeIcons.solidCircleXmark,
                //             color: Color(0xFFFFFFFF),
                //           ),
                //         ),
                //       )
                //     ]),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.slow_motion_video,
                        size: 27,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Share to Social Walls',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                            fontSize: 17,
                          )),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 27),
                  child: Text(
                      'Your video may appear in Social Walls and can be seen on the search tab or your profile.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                      )),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(
                          child: Text('',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 15,
                              )),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          elevation: 0,
                          backgroundColor: btnCOlorblue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          setState(() {
                            postReels(
                              userProvider.getUser.uid,
                              userProvider.getUser.username,
                              userProvider.getUser.photoUrl,
                            );
                          });
                        },
                        child: Text('POST',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold)),
                        // color: btnCOlorblue,
                      )
                    ],
                  ),
                ),

                // SizedBox(
                //   height: 45.0,
                //   child: AspectRatio(
                //     aspectRatio: 487 / 451,
                //     child: Container(
                //       decoration: BoxDecoration(
                //           image: DecorationImage(
                //         fit: BoxFit.fill,
                //         alignment: FractionalOffset.topCenter,
                //         image: MemoryImage(_file!),
                //       )),
                //     ),
                //   ),
                // ),
              ],
            ),
            // const Divider(),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 1,
    //     titleSpacing: 5,
    //     backgroundColor: Colors.white,
    //     leading: Padding(
    //       padding: const EdgeInsets.only(left: 5),
    //       child: IconButton(
    //         icon: const Icon(
    //           FontAwesomeIcons.chevronLeft,
    //           color: Colors.black,
    //         ),
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //       ),
    //     ),
    //     title: const Text('New Social Wall',
    //         style: TextStyle(
    //             fontWeight: FontWeight.w700,
    //             color: Color(0xFF000000),
    //             fontSize: 19)),
    //     centerTitle: false,
    //   ),
    //   body: Container(
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height,
    //     child: SafeArea(
    //       child: Container(
    //         color: Colors.white,
    //         child: Column(
    //           children: [
    //             GestureDetector(
    //                 onTap: () {
    //                   setState(() {
    //                     isPaused = !isPaused;
    //                   });
    //                   isPaused ? controller.pause() : controller.play();
    //                 },
    //                 child: VideoPlayer(controller)),
    //             Positioned(
    //               top: 20,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: <Widget>[
    //                   CircleAvatar(
    //                     backgroundImage: NetworkImage(
    //                       userProvider.getUser.photoUrl,
    //                     ),
    //                     radius: 18,
    //                   ),
    //                   SizedBox(
    //                     width: 10,
    //                   ),
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(userProvider.getUser.username.toString(),
    //                           style: TextStyle(
    //                               color: Color(0xFF000000),
    //                               fontSize: 15,
    //                               fontWeight: FontWeight.w700,
    //                               fontFamily: 'Roboto')),
    //                       SizedBox(height: 2),
    //                       Text('Quantum University, Roorkee',
    //                           style: TextStyle(
    //                               color: Color(0xFF1F1F1F),
    //                               fontSize: 10,
    //                               fontFamily: 'Roboto'))
    //                     ],
    //                   ),
    //                   // OutlinedButton(
    //                   //   style: OutlinedButton.styleFrom(
    //                   //       side: BorderSide(width: 1.2, color: Colors.lightBlue),
    //                   //       shape: RoundedRectangleBorder(
    //                   //           borderRadius: BorderRadius.circular(5))),
    //                   //   onPressed: () {},
    //                   //   child: Text(
    //                   //     'Edit Privacy',
    //                   //     style: TextStyle(
    //                   //         color: Colors.lightBlue,
    //                   //         fontWeight: FontWeight.bold,
    //                   //         fontSize: 10),
    //                   //   ),
    //                   // ),
    //                 ],
    //               ),
    //             ),
    //             Positioned(
    //                 bottom: 20,
    //                 right: 20,
    //                 child: ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     padding: EdgeInsets.symmetric(horizontal: 30),
    //                     elevation: 0,
    //                     backgroundColor: btnCOlorblue,
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(8)),
    //                   ),
    //                   onPressed: () {
    //                     setState(() {
    //                       postReels(
    //                         userProvider.getUser.uid,
    //                         userProvider.getUser.username,
    //                         userProvider.getUser.photoUrl,
    //                       );
    //                     });
    //
    //                     print("btn pressed");
    //                   },
    //                   child: Text(
    //                     'POST',
    //                     style: TextStyle(
    //                         fontSize: 12,
    //                         color: Color(0xFFFFFFFF),
    //                         fontWeight: FontWeight.bold),
    //                   ),
    //                   // color: btnCOlorblue,
    //                 )),
    //             isLoading
    //                 ? const LinearProgressIndicator()
    //                 : const Padding(padding: EdgeInsets.only(top: 15.0)),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
