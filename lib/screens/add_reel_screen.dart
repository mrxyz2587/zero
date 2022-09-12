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
            onPressed: () {},
          ),
        ),
        title: const Text('Upload',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000),
                fontSize: 19)),
        centerTitle: false,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isPaused = !isPaused;
                    });
                    isPaused ? controller.pause() : controller.play();
                  },
                  child: VideoPlayer(controller)),
              Positioned(
                top: 20,
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
                    // OutlinedButton(
                    //   style: OutlinedButton.styleFrom(
                    //       side: BorderSide(width: 1.2, color: Colors.lightBlue),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(5))),
                    //   onPressed: () {},
                    //   child: Text(
                    //     'Edit Privacy',
                    //     style: TextStyle(
                    //         color: Colors.lightBlue,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 10),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    elevation: 0,
                    backgroundColor: btnCOlorblue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),),
                    onPressed: () {
                      setState(() {
                        postReels(
                          userProvider.getUser.uid,
                          userProvider.getUser.username,
                          userProvider.getUser.photoUrl,
                        );
                      });

                      print("btn pressed");
                    },
                    child: Text('POST',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold)),
                    // color: btnCOlorblue,
                  )),
              isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(padding: EdgeInsets.only(top: 15.0)),
            ],
          ),
        ),
      ),
    );
  }
}
