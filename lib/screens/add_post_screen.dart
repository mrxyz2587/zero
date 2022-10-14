import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '/providers/user_provider.dart';
import '/resources/firestore_methods.dart';
import '/utils/colors.dart';
import '/utils/utils.dart';
import 'package:provider/provider.dart';

import 'add_reel_screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  File? file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  var name;

  @override
  void initState() {
    super.initState();
  }

  _setImageFromCamera() async {
    Uint8List file = await pickImage(ImageSource.camera);
    setState(() {
      _file = file;
    });
  }

  _setImageFromGallery() async {
    Uint8List file = await pickImage(ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    // if (file != null) {
    //   setState(() {
    //     controller = VideoPlayerController.file(file!);
    //   });
    //   controller.initialize();
    //   controller.play();
    //   controller.setVolume(1);
    //   controller.setLooping(true);
    // }
    return _file != null
        ? Scaffold(
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
                  onPressed: clearImage,
                ),
              ),
              title: const Text('Upload',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                      fontSize: 19)),
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
                                  side: BorderSide(
                                      width: 1.2, color: Colors.lightBlue),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 25),
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
                              hintText: "What's in your mind?",
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

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Stack(children: [
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                                image: MemoryImage(_file!),
                              )),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: GestureDetector(
                                onTap: clearImage,
                                child: Icon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => _setImageFromCamera(),
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                size: 29,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                            IconButton(
                                onPressed: () => _setImageFromGallery(),
                                icon: Icon(
                                  FontAwesomeIcons.solidImage,
                                  color: Color(0xFF9E9E9E),
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.slow_motion_video,
                                  size: 29,
                                  color: Color(0xFF9E9E9E),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                elevation: 0,
                                backgroundColor: btnCOlorblue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => postImage(
                                userProvider.getUser.uid,
                                userProvider.getUser.username,
                                userProvider.getUser.photoUrl,
                              ),
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
                  const Divider(),
                ],
              ),
            ),
          )
        : Scaffold(
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
                  onPressed: clearImage,
                ),
              ),
              title: const Text('Upload',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                      fontSize: 19)),
              centerTitle: false,
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 15.0)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                              Text(
                                userProvider.getUser.username.toString(),
                                style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                              SizedBox(height: 2),
                              Text('Quantum University, Roorkee',
                                  style: TextStyle(
                                      color: Color(0xFF1F1F1F),
                                      fontSize: 10,
                                      fontFamily: 'Roboto')),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1.2, color: Color(0xFF000000)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {},
                            child: Text(
                              'Edit Privacy',
                              style: TextStyle(
                                  color: Color(0xFF232323),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
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
                              hintText: "What's in your mind?",
                              hintStyle: TextStyle(
                                  color: Color(0xFFA3A3A3),
                                  fontSize: 15,
                                  fontFamily: 'Roboto'),
                              border: InputBorder.none),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => _setImageFromCamera(),
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              size: 29,
                            ),
                          ),
                          IconButton(
                              onPressed: () => _setImageFromGallery(),
                              icon: Icon(FontAwesomeIcons.solidImage)),
                          IconButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  allowCompression: true,
                                  type: FileType.video,
                                );
                                if (result != null) {
                                  File c =
                                      File(result.files.single.path.toString());

                                  setState(() {
                                    file = c;
                                    name = result.names.toString();
                                  });
                                  // String res = await FireStoreMethods()
                                  //     .UploadResume(file!);
                                }
                                if (file != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AddReelsScreen(
                                          filePath: file,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.slow_motion_video,
                                size: 29,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              elevation: 0,
                              backgroundColor: Color(0xFFEEEEEE),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {},
                            child: Text('POST',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9E9E9E),
                                    fontWeight: FontWeight.bold)),
                            // color: Color(0xFFEEEEEE),
                          )
                        ],
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
                ),
                const Divider(),
              ],
            ),
          );
  }
}
