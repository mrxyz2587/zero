import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/utils.dart';
import '../widgets/post_card.dart';

class SharedPostsDiplay extends StatefulWidget {
  final String postId;

  const SharedPostsDiplay({Key? key, required this.postId}) : super(key: key);

  @override
  State<SharedPostsDiplay> createState() => _SharedPostsDiplayState();
}

class _SharedPostsDiplayState extends State<SharedPostsDiplay> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var postisSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.grey.shade300,
              strokeWidth: 1.5,
            )),
          )
        : Scaffold(
            appBar: AppBar(
                elevation: 2,
                titleSpacing: 0,
                title: Text('Posts',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                        fontSize: 19)),
                backgroundColor: Colors.white,
                leading: IconButton(
                  padding: EdgeInsets.only(right: 0),
                  icon: Icon(
                    FontAwesomeIcons.chevronLeft,
                    size: 25,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('postId', isEqualTo: widget.postId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      controller: ScrollController(keepScrollOffset: true),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return PostCard(
                          snap: snap,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }
}
