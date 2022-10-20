import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:zero_fin/screens/reels_comment_screen.dart';
import 'package:zero_fin/widgets/video_player_items.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/like_animation.dart';

class ReelsScreen extends StatefulWidget {
  ReelsScreen();

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  int commentLen = 0;
  // fetchCommentLen() async {
  //   try {
  //     QuerySnapshot snap = await FirebaseFirestore.instance
  //         .collection('reels')
  //         .doc()
  //         .collection('comments')
  //         .get();
  //     commentLen = snap.docs.length;
  //   } catch (err) {
  //     showSnackBar(
  //       context,
  //       err.toString(),
  //     );
  //   }
  //   setState(() {});
  // }
  var searchController = TextEditingController();

  bool isLikeAnimating = false;
  bottomSheet2(context, String txt) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.black.withOpacity(0),
      context: context,
      builder: (BuildContext c) {
        return Container(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8), topLeft: Radius.circular(8))),
            width: MediaQuery.of(context).size.width,
            height: 700,
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 6),
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: searchController,
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
                        borderSide: BorderSide(
                            color: const Color(0xFFD9D8D8), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFFFFFFFF),
                          width: 1,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {});
                    },
                    onFieldSubmitted: (String _) {
                      setState(() {});
                      print(_);
                    },
                  ),
                ),
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
                      physics: ClampingScrollPhysics(),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.white,
                            child: SizedBox(
                              height: 60,
                              child: ListTile(
                                trailing: TextButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: btnCOlorblue,
                                        minimumSize: Size(75, 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Send",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    )),
                                title: Text(
                                    (snapshot.data! as dynamic)
                                        .docs[index]['username']
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Roboto')),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic)
                                        .docs[index]['photoUrl']
                                        .toString(),
                                  ),
                                  radius: 20,
                                ),
                                subtitle: Text(
                                    (snapshot.data! as dynamic)
                                        .docs[index]['university']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 13, fontFamily: 'Roboto')),
                              ),
                            ),
                          )),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  bottomSheet4(context, String txt) {
    showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0),
      context: context,
      builder: (BuildContext c) {
        return Container(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 6),
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black87,
                                ),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(
                                FontAwesomeIcons.shareNodes,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Share',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),
                                  fontSize: 13,
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 18),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black87,
                                ),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(
                                FontAwesomeIcons.link,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Link',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),
                                  fontSize: 13,
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 18),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black87,
                                ),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(
                                FontAwesomeIcons.bookmark,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Save',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF000000),
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 0.5, color: Colors.black12),
                ListTile(
                  title: Text('Hide',
                      style: TextStyle(color: Color(0xFF000000), fontSize: 17)),
                ),
                ListTile(
                  title: Text('Report',
                      style: TextStyle(color: Colors.red, fontSize: 17)),
                ),
                // ListTile(
                //   title: Text('Delete',
                //       style: TextStyle(color: Color(0xFF000000), fontSize: 17)),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  // fetchCommentLen() async {
  //   try {
  //     QuerySnapshot snap = await FirebaseFirestore.instance
  //         .collection('reel')
  //         .doc(widget.snap['postId'])
  //         .collection('comments')
  //         .get();
  //     commentLen = snap.docs.length;
  //   } catch (err) {
  //     showSnackBar(
  //       context,
  //       err.toString(),
  //     );
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reels').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.grey.shade300,
              strokeWidth: 1.5,
            ));
          }
          return PageView.builder(
            pageSnapping: true,
            controller: PageController(initialPage: 0, keepPage: false),
            scrollDirection: Axis.vertical,
            allowImplicitScrolling: true,
            onPageChanged: (val) {},
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Stack(
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    FireStoreMethods().likeReel(
                      snapshot.data!.docs[index].data()['reelId'].toString(),
                      snapshot.data!.docs[index].data()['uid'].toString(),
                      snapshot.data!.docs[index].data()['likes'],
                    );
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(children: [
                    Container(
                      child: VideoPlayerItem(
                        videoUrl: snapshot.data!.docs[index].data()["reelUrl"],
                      ),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 100,
                        ),
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                      ),
                    ),
                  ]),
                ),
                Positioned(
                  top: 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, left: 5),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            "Social Wall",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Column(
                    children: [
                      LikeAnimation(
                        isAnimating: snapshot.data!.docs[index]
                            .data()['likes']
                            .contains(snapshot.data!.docs[index].data()['uid']),
                        smallLike: true,
                        child: IconButton(
                          icon: snapshot.data!.docs[index]
                                  .data()['likes']
                                  .contains(
                                      snapshot.data!.docs[index].data()['uid'])
                              ? const Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.white,
                                ),
                          onPressed: () => FireStoreMethods().likeReel(
                            snapshot.data!.docs[index]
                                .data()['reelId']
                                .toString(),
                            snapshot.data!.docs[index].data()['uid'].toString(),
                            snapshot.data!.docs[index].data()['likes'],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        snapshot.data!.docs[index]
                            .data()['likes']
                            .length
                            .toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReelsCommentsScreen(
                                  postId: snapshot.data!.docs[index]
                                      .data()["reelId"]),
                            ),
                          );
                        },
                        child: Icon(FontAwesomeIcons.comment,
                            color: Colors.white, size: 32),
                      ),
                      SizedBox(height: 10),
                      // Text(
                      //   snapshot.data!.docs[index]
                      //       .data()['likes']
                      //       .length
                      //       .toString(),
                      //   style: TextStyle(color: Colors.white, fontSize: 10),
                      // ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          bottomSheet2(context, 'txt');
                        },
                        child: Icon(
                          FontAwesomeIcons.solidPaperPlane,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "126",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          bottomSheet4(context, "txt");
                        },
                        child: Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Positioned(
                  left: 22,
                  bottom: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage("images/zero_logo.png"),
                            radius: 15,
                          ),
                          SizedBox(width: 8),
                          Text(
                            snapshot.data!.docs[index].data()["username"],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 20),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text(
                              'Follow',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              side: BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        child: ExpandableText(
                          'dgdshfbjba dgdfejfh sdfdhfjdsf ahefakgej jdshhffhajn njsdnjnsj hjdsvjvjjjd sdvbsd ebfhbfebbwbg  nbewbfbhbwewbefbebwfeeh ufew uhw',
                          expandText: 'more',
                          collapseText: 'less',
                          maxLines: 2,
                          linkColor: Colors.grey,
                          // text: TextSpan(
                          //   text: ' ${widget.snap['description']}',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Roboto'),
                          // ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

//TODO: double tap like animation,number of likes like button,
