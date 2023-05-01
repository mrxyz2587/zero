import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zero_fin/screens/search_screen.dart';
import 'package:zero_fin/utils/colors.dart';

import '/Screens/ChatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'global_group_chat_screen.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.usersLine,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GlobalGroupChatScreen(),
                ),
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
          : ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: TextFormField(
                    controller: _search,
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
                Container(
                  height: 100,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where("uid",
                            isNotEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .toString())
                        .limit(50)
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
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 20),
                        shrinkWrap: true,
                        controller: ScrollController(keepScrollOffset: true),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) => snapshot.data!.docs[index]
                                    .data()["status"] ==
                                'Online'
                            ? GestureDetector(
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
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(),
                                    child: Container(
                                      width: 100,
                                      color: Colors.white,
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data!.docs[index]
                                                        .data()['photoUrl']),
                                                radius: 32,
                                              ),
                                              if (snapshot.data!.docs[index]
                                                      .data()["status"] ==
                                                  'Online')
                                                Positioned(
                                                  bottom: 3,
                                                  right: 6,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: btnCOlorblue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 1)),
                                                    constraints:
                                                        BoxConstraints.tight(
                                                            Size.fromRadius(5)),
                                                  ),
                                                )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Center(
                                            child: SizedBox(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    .data()["username"],
                                                style: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                ),
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      );
                    },
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
                  stream: _search.text.toString() == ""
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .where("uid",
                              isNotEqualTo: FirebaseAuth
                                  .instance.currentUser!.uid
                                  .toString())
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('users')
                          .where("username",
                              isGreaterThanOrEqualTo: _search.text.toString())
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
                      physics: ClampingScrollPhysics(),
                      controller: ScrollController(keepScrollOffset: true),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) => ListTile(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                  otUsername: snapshot.data!.docs[index]
                                      .data()["username"],
                                  otUid:
                                      snapshot.data!.docs[index].data()["uid"],
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
                                snapshot.data!.docs[index].data()['photoUrl'],
                              ),
                              radius: 23,
                            ),
                            if (snapshot.data!.docs[index].data()["status"] ==
                                'Online')
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
    );
  }
}
