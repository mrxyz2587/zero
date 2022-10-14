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
                Container(
                  child: VideoPlayerItem(
                    videoUrl: snapshot.data!.docs[index].data()["reelUrl"],
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                Positioned(
                  top: 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                        SizedBox(width: 20),
                        Text(
                          "Social Wall",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 80,
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite_outlined,
                        color: Colors.red,
                        size: 30,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "126.5K",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      SizedBox(height: 20),
                      Icon(FontAwesomeIcons.comment,
                          color: Colors.white, size: 25),
                      SizedBox(height: 10),
                      Text(
                        "126",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      SizedBox(height: 20),
                      Icon(
                        FontAwesomeIcons.solidPaperPlane,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "126",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Positioned(
                  left: 25,
                  bottom: 80,
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
                          SizedBox(width: 10),
                          Text(
                            snapshot.data!.docs[index].data()["username"],
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      Container(
                        width: 250,
                        child: Text(
                          "desvkgmb fvmfbdl mbmbgkbm bkmbokgm gkbgbgb  "
                          " gbgt bg  kr rg rgrgbrgbv rfrgr rgrg",
                          softWrap: true,
                          style: TextStyle(color: Colors.grey),
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
