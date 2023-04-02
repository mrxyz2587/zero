import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

import '../utils/colors.dart';

class GlobalGroupChatScreen extends StatefulWidget {
  const GlobalGroupChatScreen({Key? key}) : super(key: key);

  @override
  State<GlobalGroupChatScreen> createState() => _GlobalGroupChatScreenState();
}

class _GlobalGroupChatScreenState extends State<GlobalGroupChatScreen> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool emojiShowing = false;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.uid,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await FirebaseFirestore.instance
          .collection('groupchatglobal')
          .add(messages)
          .whenComplete(() {
        print('message added');
        // sendNotification("Sended you a message", widget.token);
      });
    } else {
      print("Enter Some Text");
    }
  }

  Widget messages(
    Size size,
    Map<String, dynamic> map,
    BuildContext context,
    String chatId,
  ) {
    return map['type'] == "text"
        ? GestureDetector(
            onLongPress: () async {
              if (map['sendby'] == _auth.currentUser!.uid)
              //TODO abh1: Add dialog ui and a warning message that says if you delete the message it will be permanently deleted
              {
                // await _firestore
                //     .collection('chatroom')
                //     .doc(chatDocId)
                //     .collection('chats')
                //     .doc(chatId)
                //     .delete();
              }
            },
            child: Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ChatBubble(
                elevation: 0,
                clipper: map['sendby'] == _auth.currentUser!.uid
                    ? ChatBubbleClipper1(
                        type: BubbleType.sendBubble,
                        radius: 10,
                        nipHeight: 8,
                        nipWidth: 8)
                    : ChatBubbleClipper1(
                        type: BubbleType.receiverBubble,
                        radius: 10,
                        nipHeight: 8,
                        nipWidth: 8),
                alignment: map['sendby'] == _auth.currentUser!.uid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                margin: EdgeInsets.only(top: 6),
                backGroundColor: map['sendby'] == _auth.currentUser!.uid
                    ? btnCOlorblue
                    : Colors.white,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpandableText(map['message'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: map['sendby'] == _auth.currentUser!.uid
                                ? Colors.white
                                : Colors.black87,
                          ),
                          expandText: 'more',
                          collapseText: 'hide',
                          linkColor: Colors.grey,
                          maxLines: 15,
                          urlStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B57A4),
                              fontSize: 14), onUrlTap: (url) async {
                        if (url.contains("https://www.")) {
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        } else if (!url.contains("https://www.")) {
                          if (await canLaunch("https://www." + url)) {
                            await launch("https://www." + url);
                          }
                        } else if (url.contains("https://") &&
                            !url.contains("https://www.")) {
                          if (await canLaunch("www." + url)) {
                            await launch("www." + url);
                          }
                        } else if (!url.contains("https://") &&
                            url.contains("www.")) {
                          if (await canLaunch("https://" + url)) {
                            await launch("https://" + url);
                          }
                        }
                      }),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        map['time'] == null
                            ? "sending...."
                            : DateFormat.jm()
                                .format(map['time'].toDate())
                                .toString(),
                        style: TextStyle(
                            fontSize: 9,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade700),
                      )
                    ],
                  ),
                ),
              ),
              // child: Container(
              //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              //   margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15),
              //     color: btnCOlorblue,
              //   ),
              //   child: Text(
              //     map['message'],
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
            ),
          )
        : GestureDetector(
            onLongPress: () async {
              if (map['sendby'] == _auth.currentUser!.uid)
              //TODO abh1.1: Add dialog ui and a warning message that says if you delete the message it will be permanently deleted

              {
                // await _firestore
                //     .collection('chatroom')
                //     .doc(chatDocId)
                //     .collection('chats')
                //     .doc(chatId)
                //     .delete();
              }
            },
            child: Container(
              height: size.height / 2.5,
              width: size.width,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              alignment: map['sendby'] == _auth.currentUser!.uid
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ShowImage(
                      imageUrl: map['message'],
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(4),
                  height: size.height / 2.5,
                  width: size.width / 2,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.width / 2,
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                      color: map['sendby'] == _auth.currentUser!.uid
                          ? btnCOlorblue
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  alignment: map['message'] != "" ? null : Alignment.center,
                  child: map['message'] != ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            map['message'],
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircularProgressIndicator(),
                ),
              ),
            ),
          );
  }

  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    focusNode?.addListener(() {
      print('Listener');
    });
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  File? imageFile;

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore.collection('groupchatglobal').doc(fileName).set({
      "sendby": _auth.currentUser!.uid,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore.collection('groupchatglobal').doc(fileName).delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('groupchatglobal')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker
        .pickImage(source: ImageSource.gallery, imageQuality: 5)
        .then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF000000),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          title: DialogExample(),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronLeft,
                size: 22,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          actions: [
            IconButton(
                onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => const AlertDialog(
                        title: Text(
                          'Rules of the Group',
                          style: TextStyle(
                              color: blueColor, fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                            'Please do not share pornographic content or abusive content'),
                        // actions: <Widget>[
                        //   TextButton(
                        //     onPressed: () => Navigator.pop(context, 'Cancel'),
                        //     child: const Text('Cancel'),
                        //   ),
                        //   TextButton(
                        //     onPressed: () => Navigator.pop(context, 'OK'),
                        //     child: const Text('OK'),
                        //   ),
                        // ],
                      ),
                    ),
                icon: Icon(
                  FontAwesomeIcons.circleInfo,
                  color: Colors.black45,
                ))
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  "images/chat_bg.png",
                ),
                fit: BoxFit.cover,
              )),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('groupchatglobal')
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 5.5,
                    ));
                  }
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        print(snapshot.data!.docs[index].data().toString());

                        return messages(
                          size,
                          map,
                          context,
                          snapshot.data!.docs[index].id.toString(),
                        );
                      },
                    ),
                  );
                },
              ),
            )),
            Container(
              width: size.width,
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 150,
                  minHeight: size.height / 15.5,
                ),
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Container(
                  padding: EdgeInsets.zero,
                  width: size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: GestureDetector(
                            onTap: () {
                              print("ema");
                              setState(() {
                                emojiShowing = !emojiShowing;
                                if (emojiShowing == true) {
                                  focusNode?.unfocus();
                                } else {
                                  focusNode?.requestFocus();
                                }
                              });
                            },
                            child: emojiShowing == true
                                ? Icon(CupertinoIcons.keyboard)
                                : Icon(CupertinoIcons.smiley_fill)),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          autofocus: true,
                          controller: _message,
                          onTap: () {
                            print("tapped");
                            focusNode?.requestFocus();
                            emojiShowing = false;
                          },
                          minLines: 1,
                          maxLines: 50,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            hintMaxLines: 1,
                            hintText: 'Message...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Row(children: [
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(
                        //     CupertinoIcons.mic_fill,
                        //     size: 22,
                        //   ),
                        // ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.solidImage,
                            size: 20,
                          ),
                          onPressed: () => getImage(),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 14, 8),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: btnCOlorblue,
                              ),
                              child: Container(
                                child: Transform.rotate(
                                  angle: 45 * math.pi / 180,
                                  child: IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.solidPaperPlane,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      onPressed: () {
                                        onSendMessage();
                                      }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              ),
            ),
            Offstage(
              offstage: !emojiShowing,
              child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    textEditingController: _message,
                    onBackspacePressed: () {
                      Navigator.pop(context);
                    },
                    config: Config(
                      columns: 7,
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      emojiSizeMax: 32,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      replaceEmojiOnLimitExceed: false,
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      loadingIndicator: const SizedBox.shrink(),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                      checkPlatformCompatibility: true,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.black,
          ),
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}

class DialogExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
          title: Text(
            'Rules of the Group',
            style: TextStyle(color: blueColor, fontWeight: FontWeight.bold),
          ),
          content: Text('AlertDialog description'),
          // actions: <Widget>[
          //   TextButton(
          //     onPressed: () => Navigator.pop(context, 'Cancel'),
          //     child: const Text('Cancel'),
          //   ),
          //   TextButton(
          //     onPressed: () => Navigator.pop(context, 'OK'),
          //     child: const Text('OK'),
          //   ),
          // ],
        ),
      ),
      child: const Text(
        'Confession Club',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
