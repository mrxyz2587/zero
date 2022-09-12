import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zero_fin/widgets/text_field_input.dart';
import 'package:zero_fin/widgets/video_player_items.dart';
import 'package:zero_fin/widgets/videoplayersearch.dart';
import '/screens/profile_screen.dart';
import '/utils/colors.dart';
import '/utils/global_variable.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  double longitude = 0;
  double latitude = 0;
  double distanceInMeters = 0;
  bool isLoading = true;
  String selectedText = " ";

  bool isTrue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEFEFEF),
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              suffixIcon: Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.black54,
              ),
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
                    BorderSide(color: const Color(0xFFD9D8D8), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color(0xFFDFDFDF),
                  width: 1,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                isTrue = true;
              });
            },
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
          ),
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
          actions: [
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Icon(
            //     FontAwesomeIcons.magnifyingGlass,
            //     color: Colors.black87,
            //     size: 20,
            //   ),
            // )
          ],
        ),
        body: isTrue
            ? ListView(
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          useRootNavigator: false,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Mte"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "mte";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Master"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "medium";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Expert"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "expert";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Mte"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "mte";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Master"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "medium";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Expert"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "expert";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Mte"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "mte";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Master"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "medium";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Expert"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "expert";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Mte"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "mte";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Master"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "medium";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Expert"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "expert";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Mte"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "mte";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Master"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "medium";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Expert"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "expert";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Mte"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "mte";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Master"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "medium";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Expert"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "expert";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Mte"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "mte";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Master"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "medium";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Expert"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "expert";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("all Courses"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = " ";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Mte"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "mte";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Master"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "medium";
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SimpleDialogOption(
                                        child: Text("Expert"),
                                        onPressed: () {
                                          setState(() {
                                            selectedText = "expert";
                                          });
                                          Navigator.pop(context);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          "Filter",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: (selectedText == " ")
                        ? FirebaseFirestore.instance.collection('users').get()
                        : FirebaseFirestore.instance
                            .collection('users')
                            .where("department",
                                isEqualTo: selectedText.toString())
                            .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: (snapshot.data! as dynamic).docs[index]
                                      ['uid'],
                                ),
                              ),
                            ),
                            child: ListTile(
                              focusColor: Colors.white,
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['photoUrl'],
                                ),
                                radius: 16,
                              ),
                              subtitle: Text(
                                (snapshot.data! as dynamic).docs[index]
                                    ['distance'],
                              ),
                              title: Text(
                                (snapshot.data! as dynamic).docs[index]
                                    ['username'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              )
            : isShowUsers
                ? ListView(
                    children: [
                      FutureBuilder(
                        future: (selectedText == " ")
                            ? FirebaseFirestore.instance
                                .collection('users')
                                .where(
                                  'username',
                                  isGreaterThanOrEqualTo: searchController.text,
                                )
                                .get()
                            : FirebaseFirestore.instance
                                .collection('users')
                                .where(
                                  'username',
                                  isGreaterThanOrEqualTo: searchController.text,
                                )
                                .where("department",
                                    isEqualTo: selectedText.toString())
                                .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid'],
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  focusColor: Colors.white,
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['photoUrl'],
                                    ),
                                    radius: 16,
                                  ),
                                  subtitle: Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['distance'],
                                  ),
                                  title: Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['username'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )
                : ListView(scrollDirection: Axis.vertical, children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) => Align(
                            alignment: Alignment.topLeft,
                            child: (double.parse((snapshot.data! as dynamic)
                                        .docs[index]['distance']
                                        .toString()) <=
                                    50)
                                ? Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            (snapshot.data! as dynamic)
                                                .docs[index]['photoUrl']
                                                .toString(),
                                          ),
                                          radius: 40,
                                        ),
                                        Text(
                                            (snapshot.data! as dynamic)
                                                .docs[index]['username']
                                                .toString(),
                                            style: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto')),
                                        // Text(
                                        //   (snapshot.data! as dynamic)
                                        //       .docs[index]['university']
                                        //       .toString(),
                                        // )
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 50,
                                    child: Text(
                                        " Ladki dhoondo aur patak ke chodho")),
                          ),
                        );
                      },
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('reels')
                          .where(
                            'reelId',
                          )
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return StaggeredGridView.countBuilder(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) => VideoPlayerSearch(
                            videoUrl: (snapshot.data! as dynamic).docs[index]
                                ['reelUrl'],
                          ),
                          staggeredTileBuilder: (index) =>
                              MediaQuery.of(context).size.width > webScreenSize
                                  ? StaggeredTile.count(
                                      (index % 7 == 0) ? 1 : 1,
                                      (index % 7 == 0) ? 1 : 1)
                                  : StaggeredTile.count(
                                      (index % 7 == 0) ? 2 : 1,
                                      (index % 7 == 0) ? 2 : 1),
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        );
                      },
                    ),
                  ]));
  }
}
