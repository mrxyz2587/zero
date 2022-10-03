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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: VideoPlayerItem(
                    videoUrl: snapshot.data!.docs[index].data()["reelUrl"],
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
