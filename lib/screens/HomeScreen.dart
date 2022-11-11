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
      backgroundColor: Colors.white,
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
        title: Text(
          "Chats",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
              fontSize: 19),
        ),
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
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        // suffixIcon: Icon(
                        //   FontAwesomeIcons.magnifyingGlass,
                        //   color: Colors.black54,
                        // ),
                        isDense: true,
                        isCollapsed: true,
                        filled: true,
                        contentPadding: EdgeInsets.fromLTRB(
                          10,
                          10,
                          0,
                          10,
                        ),
                        hintStyle: TextStyle(fontWeight: FontWeight.w700),
                        hintText: 'Search...',
                        fillColor: Color(0xFFEFEFEF),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Color(0xFFFFFFFF), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFFFFFFF),
                            width: 1,
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, bottom: 5),
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              'https://images.unsplash.com/photo-1597466765990-64ad1c35dafc'
                                                  .toString(),
                                            ),
                                            radius: 32,
                                          ),
                                          Positioned(
                                            bottom: 3,
                                            right: 6,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: btnCOlorblue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1)),
                                              constraints: BoxConstraints.tight(
                                                  Size.fromRadius(5)),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('Abhi',
                                          style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 15,left: 15),
                  //   child: TextFormField(
                  //     decoration: InputDecoration(
                  //       // suffixIcon: Icon(
                  //       //   FontAwesomeIcons.magnifyingGlass,
                  //       //   color: Colors.black54,
                  //       // ),
                  //       isDense: true,
                  //       isCollapsed: true,
                  //       filled: true,
                  //       contentPadding: EdgeInsets.fromLTRB(
                  //         10,
                  //         10,
                  //         0,
                  //         10,
                  //       ),
                  //       hintStyle: TextStyle(fontWeight: FontWeight.w700),
                  //       hintText: 'Search...',
                  //       fillColor: Color(0xFFEFEFEF),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //         borderSide: BorderSide(
                  //             color: const Color(0xFFD9D8D8), width: 1.5),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: BorderSide(
                  //           color: Color(0xFFFFFFFF),
                  //           width: 1,
                  //         ),
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       setState(() {});
                  //     },
                  //     onFieldSubmitted: (String _) {
                  //       setState(() {
                  //
                  //
                  //       });
                  //       print(_);
                  //     },
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(5)),
                  //   backgroundColor: Colors.black87,),
                  //   onPressed: onSearch,
                  //   child: Text("Search", style: TextStyle(color: Colors.white)),
                  // ),
                  // SizedBox(
                  //   height: size.height / 30,
                  // ),
                  Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: Colors.black12),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where("uid",
                            isNotEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .toString())
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(left: 10),
                        shrinkWrap: true,
                        controller: ScrollController(keepScrollOffset: true),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) => ListTile(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                    otUsername: snapshot.data!.docs[index]
                                        .data()["username"],
                                    otUid: snapshot.data!.docs[index]
                                        .data()["uid"],
                                    profilePic: snapshot.data!.docs[index]
                                        .data()["photoUrl"],
                                    status: snapshot.data!.docs[index]
                                        .data()["status"],
                                    token: snapshot.data!.docs[index]
                                        .data()["token"]
                                        .toString()),
                              ),
                            );
                          },
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1597466765990-64ad1c35dafc'
                                      .toString(),
                                ),
                                radius: 23,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: btnCOlorblue,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  constraints:
                                      BoxConstraints.tight(Size.fromRadius(5)),
                                ),
                              )
                            ],
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              snapshot.data!.docs[index].data()["username"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text('5 new messages',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 7.0),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
