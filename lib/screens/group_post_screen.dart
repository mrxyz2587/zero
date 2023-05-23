import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zero_fin/utils/colors.dart';
import 'package:zero_fin/utils/utils.dart';
import '../providers/user_provider.dart';

class GroupPostingScreen extends StatefulWidget {
  final String collectionname;
  final String clubName;
  final String currentUsername;
  final String currentUserImg;
  GroupPostingScreen(
      {Key? key,
      required this.collectionname,
      required this.clubName,
      required this.currentUsername,
      required this.currentUserImg})
      : super(key: key);

  @override
  State<GroupPostingScreen> createState() => _GroupPostingScreenState();
}

class _GroupPostingScreenState extends State<GroupPostingScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? imageFile;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    titleController.dispose();
    descriptionController.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker
        .pickImage(source: ImageSource.gallery, imageQuality: 20)
        .then((xFile) {
      if (xFile != null) {
        imageFile = File(
          xFile.path,
        );
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              scrollable: false,
              backgroundColor: Colors.white,
              title: Text("Uploading to meme club"),
              content: LinearProgressIndicator(
                color: Colors.blue,
              ),
            ));

    String msgId = const Uuid().v1();

    int status = 1;

    await FirebaseFirestore.instance
        .collection(widget.collectionname)
        .doc(msgId)
        .set({
      "msgId": msgId,
      "sendby": _auth.currentUser!.uid,
      "title": titleController.text,
      "subtitle": '',
      "type": "img",
      "time": FieldValue.serverTimestamp(),
      "sendername": widget.currentUsername,
      "userimg": widget.currentUserImg
    });

    var ref = FirebaseStorage.instance
        .ref()
        .child('memeclubimages')
        .child("$msgId.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await FirebaseFirestore.instance
          .collection(widget.collectionname)
          .doc(msgId)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection(widget.collectionname)
          .doc(msgId)
          .update({"subtitle": imageUrl});
    }
    Navigator.pop(context);
  }

  void onSendMessage() async {
    if (widget.collectionname == 'groupglobalchat') {
      if (titleController.text.isNotEmpty) {
        String msgId = const Uuid().v1();

        Map<String, dynamic> messages = {
          "msgId": msgId,
          "sendby": _auth.currentUser!.uid,
          "title": titleController.text,
          "type": "text",
          "time": FieldValue.serverTimestamp(),
          "sendername": widget.currentUsername,
          "userimg": widget.currentUserImg
        };

        titleController.clear();
        descriptionController.clear();

        await FirebaseFirestore.instance
            .collection(widget.collectionname)
            .doc(msgId)
            .set(messages);
        Navigator.pop(context);
      } else {
        showSnackBar(context, 'Please enter both the fields');
      }
    } else {
      if (titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty) {
        String msgId = const Uuid().v1();

        Map<String, dynamic> messages = {
          "msgId": msgId,
          "sendby": _auth.currentUser!.uid,
          "title": titleController.text,
          "subtitle": descriptionController.text,
          "type": "text",
          "time": FieldValue.serverTimestamp(),
          "sendername": widget.currentUsername,
          "userimg": widget.currentUserImg
        };

        titleController.clear();
        descriptionController.clear();

        await FirebaseFirestore.instance
            .collection(widget.collectionname)
            .doc(msgId)
            .set(messages);
        Navigator.pop(context);
      } else {
        showSnackBar(context, 'Please enter both the fields');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(FontAwesomeIcons.chevronLeft, color: Colors.black)),
          title: Text(
            "Start a discussion",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          titleSpacing: 0,
          actions: [
            if (widget.collectionname != "memeclubchat")
              GestureDetector(
                onTap: () {
                  onSendMessage();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: btnCOlorblue,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    height: 35,
                    width: 72,
                    child: Center(
                      child: Text('Post',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Roboto')),
                    ),
                  ),
                ),
              )
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: IconButton(
            //     icon: const Icon(
            //       Icons.share,
            //       color: Colors.black,
            //       size: 23,
            //     ),
            //     onPressed: () async {
            //       String generatedDeepLink = await FirebaseDynamicLinksService
            //           .createDynamicLinkforinternships(widget.id.toString());
            //       Share.share(
            //         generatedDeepLink,
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          NetworkImage(userProvider.getUser.photoUrl),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Posting to: ',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF111111),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.clubName,
                      style: TextStyle(
                        color: Color(0xFF4F5994),
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: titleController,
                  maxLength: 160,
                  style: TextStyle(
                      color: Color(0xff151515),
                      fontSize: 17,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      height: 1.3),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: widget.collectionname != 'groupglobalchat'
                        ? 'What do you wanna discuss about?'
                        : 'What you wanna confess',
                    hintStyle: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF929398),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (widget.collectionname != 'groupglobalchat' &&
                    widget.collectionname != "memeclubchat")
                  TextField(
                    controller: descriptionController,
                    maxLength: 160,
                    style: TextStyle(
                      color: Color(0xff151515),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Your discussion subtitle',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xff9B9B9D),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: widget.collectionname == "memeclubchat"
                ? GestureDetector(
                    onTap: () {
                      if (titleController.text.isEmpty) {
                        showSnackBar(context, 'Please enter the topic first');
                      } else {
                        getImage();
                      }
                    },
                    child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text('📸 Add Photo'))),
                  )
                : Container(),
          ),
        ));
  }
}
