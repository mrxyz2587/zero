import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:zero_fin/screens/reels_comment_screen.dart';
import 'package:zero_fin/widgets/video_player_items.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
import '../widgets/like_animation.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

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
            itemBuilder: (ctx, index) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  VideoPlayerItem(
                      videoUrl: snapshot.data!.docs[index].data()["reelUrl"]),
                  Positioned(
                      top: 20,
                      left: 10,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                            ),
                            color: Colors.transparent,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Social Wall",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          Icon(
                            Icons.camera_alt_sharp,
                            size: 25,
                            color: Colors.white,
                          ),
                        ],
                      )),
                  Positioned(
                      bottom: 20,
                      right: 20,
                      child: Column(
                        children: [
                          LikeAnimation(
                            isAnimating: snapshot.data!.docs[index]
                                .data()['likes']
                                .contains(userProvider.getUser.uid),
                            smallLike: true,
                            child: IconButton(
                              icon: snapshot.data!.docs[index]
                                      .data()['likes']
                                      .contains(userProvider.getUser.uid)
                                  ? const Icon(
                                      FontAwesomeIcons.solidHeart,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      FontAwesomeIcons.heart,
                                      color: Colors.white,
                                    ),
                              onPressed: () => FireStoreMethods().likePost(
                                snapshot.data!.docs[index]
                                    .data()['reelId']
                                    .toString(),
                                userProvider.getUser.uid,
                                snapshot.data!.docs[index].data()['likes'],
                              ),
                            ),
                          ),
                          Text(
                            '${snapshot.data!.docs[index].data()['likes'].length} Likes',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          SizedBox(width: 30),
                          IconButton(
                            color: Colors.transparent,
                            icon: const Icon(
                              Icons.comment_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ReelsCommentsScreen(
                                  postId: snapshot.data!.docs[index]
                                      .data()['reelId']
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '0 comments',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          SizedBox(width: 30),
                          GestureDetector(
                              child: Image.asset(
                            'images/share_icons.png',
                            height: 20,
                          )),
                        ],
                      )),
                  Positioned(
                      child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage('images/me.jpeg'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Zoya Firoz",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 30,
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Caption on reel........",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.compare_arrows_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                            Text(
                              "effets will go here",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            Icon(
                              Icons.star_purple500,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 145,
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image(
                                image: AssetImage('images/me.jpeg'),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.home,
                                size: 25,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.search,
                                size: 25,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.video_collection_outlined,
                                size: 25,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.heart_broken,
                                size: 25,
                                color: Colors.white,
                              ),
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: AssetImage('images/me.jpeg'),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
                ],
                // snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
