import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/resources/firestore_methods.dart';
import 'package:zero_fin/utils/colors.dart';

class EventItem extends StatelessWidget {
  final snap;
  final Function()? onpressed;
  final _currentUserUid = FirebaseAuth.instance.currentUser!.uid.toString();

  EventItem({Key? key, required this.snap, this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
      child: GestureDetector(
        onTap: onpressed,
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  snap['imageUrl'].toString(),
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snap['evetitle'],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        constraints: BoxConstraints.tight(Size.fromRadius(20)),
                        onPressed: () {
                          FireStoreMethods().pinnedEvents(
                              snap['id'], (snap['saves'] as List));
                        },
                        icon: (snap['saves'] as List).contains(_currentUserUid)
                            ? Transform.rotate(
                                angle: 45,
                                child: Icon(
                                  FontAwesomeIcons.thumbtack,
                                  color: Color(0xFFFFD86D),
                                ),
                              )
                            : Transform.rotate(
                                angle: 45,
                                child: Icon(
                                  FontAwesomeIcons.thumbtack,
                                  color: Colors.black26,
                                ),
                              ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snap["eventDate"].toString(),
                      // 'Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
                      maxLines: 1,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    ),
                    snap['type'].toString() == "paid"
                        ? InkWell(
                            onTap: () async {
                              final url = snap["url"].toString();
                              if (await canLaunch(url)) {
                                await launch(url,
                                    enableDomStorage: true,
                                    enableJavaScript: true,
                                    forceWebView: true);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: btnCOlorblue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              final url = snap["url"].toString();
                              if (await canLaunch(url)) {
                                await launch(url,
                                    enableDomStorage: true,
                                    enableJavaScript: true,
                                    forceWebView: true);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              child: Text(
                                'Join',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                color: btnCOlorblue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
