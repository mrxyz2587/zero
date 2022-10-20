import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class EditPostScreen extends StatefulWidget {
  final String postId;
  final String postUrl;
  final String postDescription;

  const EditPostScreen(
      {Key? key,
      required this.postId,
      required this.postUrl,
      required this.postDescription})
      : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  Uint8List? _file;
  File? file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  var name;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

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
                        onPressed: () {

                        },
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
                        hintText: "What's in your mind?",
                        hintStyle: TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 15,
                            fontFamily: 'Roboto'),
                        border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: NetworkImage(widget.postUrl),
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                            final docRef = FirebaseFirestore.instance
                                .collection("posts")
                                .doc(widget.postId);
                            final updates;
                            if (_descriptionController.text.isNotEmpty) {
                              updates = <String, dynamic>{
                                "description": _descriptionController.text
                              };
                            } else {
                              updates = <String, dynamic>{
                                "description": widget.postDescription
                              };
                            }

                            docRef.update(updates).then(
                                (value) => print(
                                    "DocumentSnapshot successfully updated!"),
                                onError: (e) =>
                                    print("Error updating document $e"));
                          });
                          Navigator.pop(context);
                        },
                        child: Text('UPDATE',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold)),
                        // color: btnCOlorblue,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
    // : Scaffold();
  }
}
