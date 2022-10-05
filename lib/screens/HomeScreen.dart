import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zero_fin/screens/search_screen.dart';
import 'package:zero_fin/utils/colors.dart';

import '/Screens/ChatRoom.dart';
import '/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("username", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            size: 25,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Chats",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000),
                fontSize: 19)),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.plus,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GroupChatHomeScreen(),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.grey.shade300,
              strokeWidth: 1.5,
            ))
          : Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: size.height / 16,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 16,
                    width: size.width / 1.05,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: Colors.black87,),
                  onPressed: onSearch,
                  child: Text("Search", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .get(),
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
                            controller:
                                ScrollController(keepScrollOffset: true),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, index) => ListTile(
                              onTap: () async {
                                String roomId = await chatRoomId(
                                  _auth.currentUser!.uid,
                                  userMap!['username'],
                                );

                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatRoom(
                                        chatRoomId: roomId, userMap: userMap),
                                  ),
                                );
                              },
                              leading:
                                  Icon(Icons.account_box, color: Colors.black),
                              title: Text(
                                snapshot.data!.docs[index].data()["username"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                  snapshot.data!.docs[index].data()["email"]),
                              trailing: Icon(Icons.chat, color: Colors.black),
                            ),
                          );
                        },
                      )
                    : Center(child: Container()),
              ],
            ),
    );
  }
}
