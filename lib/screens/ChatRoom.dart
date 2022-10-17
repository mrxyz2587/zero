import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:zero_fin/utils/colors.dart';

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

            child: ChatBubble(
              elevation: 0,
              clipper: map['sendby'] == _auth.currentUser!.uid
                  ? ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 10)
                  : ChatBubbleClipper1(
                      type: BubbleType.receiverBubble, radius: 12),
              alignment: map['sendby'] == _auth.currentUser!.uid
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20),
              backGroundColor: Colors.grey.shade100,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  map['message'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
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
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),
              child: ChatBubble(
                elevation: 0,
                alignment: map['sendby'] == _auth.currentUser!.uid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,

                clipper: map['sendby'] == _auth.currentUser!.uid
                    ? ChatBubbleClipper1(
                        type: BubbleType.sendBubble, radius: 10, nipRadius: 2)
                    : ChatBubbleClipper1(
                        type: BubbleType.receiverBubble,
                        radius: 10,
                        nipRadius: 2),
                // alignment: map['message'] != "" ? null : Alignment.centerRight,
                margin: EdgeInsets.only(top: 20),
                backGroundColor: map['sendby'] == _auth.currentUser!.uid
                    ? btnCOlorblue
                    : Colors.grey.shade100,
                child: map['message'] != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          map['message'],
                          fit: BoxFit.fill,
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
              // child: Container(
              //   height: size.height / 2.5,
              //   width: size.width / 2,
              //   decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(15)),
              //   alignment: map['message'] != "" ? null : Alignment.centerRight,
              //   child: map['message'] != ""
              //       ? Image.network(
              //           map['message'],
              //           fit: BoxFit.cover,
              //         )
              //       : CircularProgressIndicator(),
              // ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: Transform.translate(
          offset: Offset(-20, 0),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 14, backgroundImage: NetworkImage(widget.profilePic)),
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
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.20,
              child: StreamBuilder(
                stream: _firestore
                    .collection('chatroom')
                    .doc(chatDocId)
                    .collection('chats')
                    .orderBy("time", descending: false)
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

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> map = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return map['type'] == "text"
                          ? Container(
                              width: size.width,
                              alignment: map['sendby'] == _auth.currentUser!.uid
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 14),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: btnCOlorblue,
                                ),
                                child: Text(
                                  map['message'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: size.height / 2.5,
                              width: size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              alignment: map['sendby'] ==
                                      _auth.currentUser!.displayName
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
                                  height: size.height / 2.5,
                                  width: size.width / 2,
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  alignment: map['message'] != ""
                                      ? null
                                      : Alignment.center,
                                  child: map['message'] != ""
                                      ? Image.network(
                                          map['message'],
                                          fit: BoxFit.cover,
                                        )
                                      : CircularProgressIndicator(),
                                ),
                              ),
                            );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Container(
                height: size.height / 17,
                width: size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Container(
                  padding: EdgeInsets.zero,
                  width: size.width / 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Icon(CupertinoIcons.smiley_fill),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            hintText: 'Type your message here...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Row(children: [
                          Icon(
                            CupertinoIcons.mic_fill,
                            size: 22,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.solidImage,
                              size: 20,
                            ),
                            onPressed: () => getImage(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              icon: Icon(Icons.send), onPressed: onSendMessage),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
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

//
