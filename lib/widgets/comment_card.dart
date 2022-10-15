import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['profilePic'],
            ),
            radius: 18,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: snap.data()['name'],
                        style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Roboto'),
                    ),
                  ),
                  Text(
                    //TODO 1. import university data
                      'university'
                          .toString(),
                      style: TextStyle(
                          fontSize: 13, fontFamily: 'Roboto')),
                  SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '${snap.data()['text']}',
                            style: TextStyle(
                                color: Color(0xFF454545),
                                fontSize: 15,
                                fontFamily: 'Roboto')),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [Text(
                      'Likes',
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
                        '2 Reply',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 180,),
                      Icon(FontAwesomeIcons.heart,
                        size: 10,
                      color: Colors.red,),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
