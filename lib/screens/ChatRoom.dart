import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:zero_fin/screens/profile_screen.dart';
import 'package:zero_fin/utils/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  final String otUsername;
  final otUid;
  final String profilePic;
  final status;
  ChatRoom(
      {required this.otUsername,
      required this.otUid,
      required this.profilePic,
      required this.status});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference chats = FirebaseFirestore.instance.collection("chatroom");
  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  var chatDocId;

  File? imageFile;

  bool isLoasdings = true;

  bool emojiShow = false;
  static AudioCache player = AudioCache();

  void playSound(String sound) {
    final player = AudioCache();
    player.play(sound);
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    chats
        .where("users", isEqualTo: {currentUid: null, widget.otUid: null})
        .limit(1)
        .get()
        .then((value) {
          if (value.docs.isNotEmpty) {
            chatDocId = value.docs.single.id.toString();
          } else {
            chats.add({
              "users": {currentUid: null, widget.otUid: null}
            }).then((value) => {chatDocId = value.toString()});
          }
        });
  }

  void getData() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      setState(() {
        isLoasdings = false;
      });
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(chatDocId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": _auth.currentUser!.uid,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(chatDocId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(chatDocId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.uid,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatDocId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
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
                    Text(
                      map['message'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: map['sendby'] == _auth.currentUser!.uid
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "12:06 pm",
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
          )
        : Container(
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
          );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isLoasdings
        ? Scaffold()
        : Scaffold(
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
                title: Transform.translate(
                  offset: Offset(-20, 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(uid: widget.otUid)));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(widget.profilePic)),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.otUsername.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.status.toString(),
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
              ),
            ),
            body: Stack(
              children: [
                Image.asset("images/chat_bg.png",
                    fit: BoxFit.cover, height: size.height, width: size.width),
                StreamBuilder(
                  stream: _firestore
                      .collection('chatroom')
                      .doc(chatDocId)
                      .collection('chats')
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

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 56.0),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          print(snapshot.data!.docs[index].data().toString());
                          return messages(size, map, context);
                        },
                      ),
                    );
                  },
                ),
                Container(
                  width: size.width,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: size.height / 15.5,
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
                                    emojiShow = !emojiShow;
                                  });
                                },
                                child: Icon(CupertinoIcons.smiley_fill)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _message,
                              onTap: () {
                                print("tapped");
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
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.mic_fill,
                                size: 22,
                              ),
                            ),
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
                                            setState(() {
                                              onSendMessage();

                                              playSound("chat_send.wav");
                                            });
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
                // emojiShow
                //     ? Container(
                //         height: MediaQuery.of(context).size.height / 5,
                //         child: EmojiPicker(
                //           onBackspacePressed: () {
                //             // Do something when the user taps the backspace button (optional)
                //           },
                //           textEditingController:
                //               _message, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                //           config: Config(
                //             columns: 7,
                //             emojiSizeMax: 32 *
                //                 (Platform.isIOS
                //                     ? 1.30
                //                     : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                //             verticalSpacing: 0,
                //             horizontalSpacing: 0,
                //             gridPadding: EdgeInsets.zero,
                //             initCategory: Category.RECENT,
                //             bgColor: Color(0xFFF2F2F2),
                //             indicatorColor: Colors.blue,
                //             iconColor: Colors.grey,
                //             iconColorSelected: Colors.blue,
                //             backspaceColor: Colors.blue,
                //             skinToneDialogBgColor: Colors.white,
                //             skinToneIndicatorColor: Colors.grey,
                //             enableSkinTones: true,
                //             showRecentsTab: true,
                //             recentsLimit: 28,
                //             noRecents: const Text(
                //               'No Recents',
                //               style: TextStyle(
                //                   fontSize: 20, color: Colors.black26),
                //               textAlign: TextAlign.center,
                //             ), // Needs to be const Widget
                //             loadingIndicator: const SizedBox
                //                 .shrink(), // Needs to be const Widget
                //             tabIndicatorAnimDuration: kTabScrollDuration,
                //             categoryIcons: const CategoryIcons(),
                //             buttonMode: ButtonMode.MATERIAL,
                //           ),
                //         ),
                //       )
                //     : Container()
              ],
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

//
