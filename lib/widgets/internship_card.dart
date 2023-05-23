import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/screens/internship_details_screen.dart';
import 'package:zero_fin/utils/colors.dart';

import '../resources/firebase_dynamic_links.dart';

class InternshipCard extends StatelessWidget {
  final snap;
  int? num;
  InternshipCard({Key? key, required this.snap, this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InternshpDetaailsScreen(id: snap['id'])));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('images/zero_logo.png'),
                    radius: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        snap['internshipcategory'],
                        // 'Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
                        maxLines: 4,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '3 months ago',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                  Spacer(flex: 1),
                  TextButton(
                    onPressed: () async {
                      final url = snap["applylink"].toString();
                      if (await canLaunch(url)) {
                        await launch(
                          url,
                          forceWebView: true,
                          enableJavaScript: true,
                          enableDomStorage: true,
                        );
                      }
                    },
                    child: Text('Apply',
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: btnCOlorblue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                snap['internshipename'],
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 12),
                  SizedBox(width: 2),
                  Text(
                    snap["location"].toString(),
                    // 'Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
                    maxLines: 4,
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                snap["internshipduration"].toString() +
                    ' | ' +
                    snap["stipened"].toString(),
                // 'Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
                maxLines: 4,
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: Colors.black26,
                height: 0.9,
                thickness: 1.5,
              ),
              GestureDetector(
                onTap: () async {
                  String generatedDeepLink = await FirebaseDynamicLinksService
                      .createDynamicLinkforinternships(snap['id']);
                  Share.share(
                    'Hey! \nCheckout this work notice about ${snap['internshipename']}. \n\nYou can apply using this link: ' +
                        generatedDeepLink,
                  );
                },
                child: Container(
                  height: 40,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 13,
                        ),
                        SizedBox(width: 10),
                        Text(num.toString()),
                        Spacer(),
                        Text(
                          'Share',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
