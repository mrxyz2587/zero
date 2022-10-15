import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/profile_screen.dart';
import '/models/user.dart' as model;
import '/providers/user_provider.dart';
import '/resources/firestore_methods.dart';
import '/screens/comments_screen.dart';
import '/utils/colors.dart';
import '/utils/global_variable.dart';
import '/utils/utils.dart';
import '/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  final Function()? onshareingbtnPressed;
  const PostCard(
      {Key? key, required this.snap, required this.onshareingbtnPressed})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  bool issaved = false;
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  var searchController = TextEditingController();
  bottomSheetforshare(context, String txt) {
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
                                    onPressed: () {Navigator.pop(context);},
                                    child: Text(
                                      "Send",
                                      style: TextStyle(color: Colors.white,
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

  bottomSheetforownthreedot(context, String txt) {
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
                    topRight: Radius.circular(8), topLeft: Radius.circular(8))),
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
                          InkWell(
                            onTap: (){
                              bottomSheetforshare(context, 'txt');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black87,
                                  ),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Icon(
                                  FontAwesomeIcons.solidPaperPlane,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Chat',
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
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 0.5, color: Colors.black12),
                ListTile(
                  title: Text('Edit',
                      style: TextStyle(color: Color(0xFF000000), fontSize: 17)),
                ),
                ListTile(
                  title: Text('Delete',
                      style: TextStyle(color: Color(0xFF000000), fontSize: 17)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bottomSheetforotherthreedot(context, String txt) {
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
                          InkWell(
                            onTap: (){
                              bottomSheetforshare(context, 'txt');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black87,
                                  ),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Icon(
                                  FontAwesomeIcons.solidPaperPlane,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Chat',
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

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Container(
        // boundary needed for web
        decoration: BoxDecoration(
          border: Border.all(
            color:
                width > webScreenSize ? secondaryColor : mobileBackgroundColor,
          ),
          color: mobileBackgroundColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            // HEADER SECTION OF THE POST
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: widget.snap['uid'],
                        ),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundImage: NetworkImage(
                        widget.snap['profImage'].toString(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: widget.snap['uid'],
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.snap['username'].toString(),
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto'),
                            ),
                            SizedBox(height: 2),
                            Text('Quantum University, Roorkee',
                                style: TextStyle(
                                    color: Color(0xFF1F1F1F),
                                    fontSize: 10,
                                    fontFamily: 'Roboto')),
                            SizedBox(height: 2),
                            Text(widget.snap['datePublished'].toString(),
                                style: TextStyle(
                                    color: Color(0xFF6C6B6B),
                                    fontSize: 8,
                                    fontFamily: 'Roboto')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: LikeAnimation(
                      isAnimating: widget.snap['saves'].contains(user.uid),
                      smallLike: true,
                      child: IconButton(
                          icon: widget.snap['saves'].contains(user.uid)
                              ? const Icon(
                                  FontAwesomeIcons.solidBookmark,
                                  color: Color(0xFF494949),
                                )
                              : const Icon(
                                  FontAwesomeIcons.bookmark,
                                  color: Color(0xFF494949),
                                ),
                          onPressed: () {
                            FireStoreMethods().SavedPosts(
                              widget.snap['postId'].toString(),
                              user.uid,
                              widget.snap['saves'],
                            );
                          }),
                    ),
                  ),
                  widget.snap['uid'].toString() == user.uid
                      ? IconButton(
                          onPressed: () {
                            bottomSheetforownthreedot(context, "txt");
                            // showDialog(
                            //   useRootNavigator: false,
                            //   context: context,
                            //   builder: (context) {
                            //     return Dialog(
                            //       child: ListView(
                            //           padding: const EdgeInsets.symmetric(
                            //               vertical: 16),
                            //           shrinkWrap: true,
                            //           children: [
                            //             'Delete',
                            //             'Edit',
                            //             'Share..',
                            //             'Copy Link',
                            //             'Share',
                            //           ]
                            //               .map(
                            //                 (e) => InkWell(
                            //                     child: Container(
                            //                       padding: const EdgeInsets
                            //                               .symmetric(
                            //                           vertical: 12,
                            //                           horizontal: 16),
                            //                       child: Text(e),
                            //                     ),
                            //                     onTap: () {
                            //                       if (e == "Delete") {
                            //                         deletePost(
                            //                           widget.snap['postId']
                            //                               .toString(),
                            //                         );
                            //                       }
                            //                       // remove the dialog box
                            //                       Navigator.of(context).pop();
                            //                     }),
                            //               )
                            //               .toList()),
                            //     );
                            //   },
                            // );
                          },
                          icon: const Icon(FontAwesomeIcons.ellipsisVertical),
                        )
                      : IconButton(
                          onPressed: () {
                            bottomSheetforotherthreedot(context, "txt");

                            // showDialog(
                            //   useRootNavigator: false,
                            //   context: context,
                            //   builder: (context) {
                            //     return Dialog(
                            //       child: ListView(
                            //           padding: const EdgeInsets.symmetric(
                            //               vertical: 16),
                            //           shrinkWrap: true,
                            //           children: [
                            //             'Share..',
                            //             'Copy Link',
                            //             'Share',
                            //           ]
                            //               .map(
                            //                 (e) => InkWell(
                            //                     child: Container(
                            //                       padding: const EdgeInsets
                            //                               .symmetric(
                            //                           vertical: 12,
                            //                           horizontal: 16),
                            //                       child: Text(e),
                            //                     ),
                            //                     onTap: () {
                            //                       if (e == "Delete") {
                            //                         deletePost(
                            //                           widget.snap['postId']
                            //                               .toString(),
                            //                         );
                            //                       }
                            //                       // remove the dialog box
                            //                       Navigator.of(context).pop();
                            //                     }),
                            //               )
                            //               .toList()),
                            //     );
                            //   },
                          },
                          icon: const Icon(FontAwesomeIcons.ellipsisVertical),
                        ),
                ],
              ),
            ),
            SizedBox(height: 4),
            // IMAGE SECTION OF THE POST
            if (widget.snap['description'].length > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 5, left: 16, bottom: 5, right: 16),
                child: ExpandableText(
                  ' ${widget.snap['description']}',
                  expandText: 'show more',
                  collapseText: 'show less',
                  maxLines: 3,
                  linkColor: btnCOlorblue,
                  textAlign: TextAlign.justify,
                  // text: TextSpan(
                  //   text: ' ${widget.snap['description']}',
                  style: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
                  // ),
                ),
              ),
            GestureDetector(
              onDoubleTap: () {
                FireStoreMethods().likePost(
                  widget.snap['postId'].toString(),
                  user.uid,
                  widget.snap['likes'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowImage(
                              imageUrl: widget.snap['postUrl'].toString(),
                            )));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        widget.snap['postUrl'].toString(),
                        width: MediaQuery.of(context).size.width,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
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
                ],
              ),
            ),
            // LIKE, COMMENT SECTION OF THE POST
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  LikeAnimation(
                    isAnimating: widget.snap['likes'].contains(user.uid),
                    smallLike: true,
                    child: IconButton(
                      icon: widget.snap['likes'].contains(user.uid)
                          ? const Icon(
                              FontAwesomeIcons.solidHeart,
                              color: Colors.red,
                            )
                          : const Icon(
                              FontAwesomeIcons.heart,
                            ),
                      onPressed: () => FireStoreMethods().likePost(
                        widget.snap['postId'].toString(),
                        user.uid,
                        widget.snap['likes'],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                      onTap: widget.onshareingbtnPressed,
                      child: Image.asset(
                        'images/share_icons.png',
                        height: 20,
                      )),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Comments',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            commentLen.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF797979)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Align(
                      child: const Icon(
                        FontAwesomeIcons.angleRight,
                        size: 30,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //DESCRIPTION AND NUMBER OF COMMENTS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${widget.snap['likes'].length} Likes',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 13,
                      color: Colors.black87,
                      width: 1,
                    ),
                  ),
                  Text(
                    '2 Shares',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),

                  // InkWell(
                  //   child: Container(
                  //     child: Text(
                  //       'View all $commentLen comments',
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //         color: secondaryColor,
                  //       ),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(vertical: 4),
                  //   ),
                  //   onTap: () => Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (context) => CommentsScreen(
                  //         postId: widget.snap['postId'].toString(),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   child: Text(
                  //     ),
                  //     style: const TextStyle(
                  //       color: secondaryColor,
                  //     ),
                  //   ),
                  //   padding: const EdgeInsets.symmetric(vertical: 4),
                  // ),
                ],
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
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child:
            InteractiveViewer(panEnabled: true, child: Image.network(imageUrl)),
      ),
    );
  }
}
