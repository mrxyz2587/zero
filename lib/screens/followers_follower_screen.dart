import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowersFollowingScreen extends StatefulWidget {
  final String uid;

  const FollowersFollowingScreen({Key? key, required this.uid})
      : super(key: key);

  @override
  State<FollowersFollowingScreen> createState() =>
      _FollowersFollowingScreenState();
}

class _FollowersFollowingScreenState extends State<FollowersFollowingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: widget.uid)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.grey.shade300,
            strokeWidth: 1.5,
          ));
        }
        return ListView.builder(
          shrinkWrap: true,
          controller: ScrollController(keepScrollOffset: true),
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (ctx, index) => Container(
            child: ListTile(
              title: Text(
                snapshot.data!.docs[index].data()["followers"],
              ),
            ),
          ),
        );
      },
    );
  }
}
