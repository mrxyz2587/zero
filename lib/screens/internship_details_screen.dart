import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/constants.dart';
import 'package:zero_fin/utils/colors.dart';

import '../resources/firebase_dynamic_links.dart';

class InternshpDetaailsScreen extends StatefulWidget {
  final String id;

  InternshpDetaailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<InternshpDetaailsScreen> createState() =>
      _InternshpDetaailsScreenState();
}

class _InternshpDetaailsScreenState extends State<InternshpDetaailsScreen> {
  String comapanyname = '';
  String timeposted = '';
  String internshiptitle = '';
  String internshipdescription = '';
  String internshipamount = '';
  String internshiplocation = '';
  String internshipcompanyimage = '';
  String applylink = '';

  @override
  void initState() {
    // TODO: implement initState

    something();
  }

  void something() async {
    FirebaseFirestore.instance
        .collection('coursesection')
        .doc('internship')
        .collection('allinternships')
        .doc(widget.id)
        .get()
        .then((value) {
      setState(() {
        comapanyname = value.data()!["internshipcategory"].toString();
        timeposted = value.data()!["internshipduration"].toString();
        internshiptitle = value.data()!["internshipename"].toString();
        internshipamount = value.data()!["stipened"].toString();
        internshiplocation = value.data()!["location"].toString();
        internshipdescription =
            value.data()!["internshipdescription"].toString();
        internshipcompanyimage =
            value.data()!["internshipcompanyImage"].toString();
        applylink = value.data()!["applylink"].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: Icon(FontAwesomeIcons.chevronLeft, color: Colors.black),
        title: Text(
          comapanyname,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.black,
                size: 23,
              ),
              onPressed: () async {
                String generatedDeepLink = await FirebaseDynamicLinksService
                    .createDynamicLinkforinternships(widget.id.toString());
                Share.share(
                  'Hey! \nCheckout this work notice about ${internshiptitle.toUpperCase()}. \n\nYou can apply using this link: ' +
                      generatedDeepLink,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(internshipcompanyimage),
                  radius: 20,
                ),
                SizedBox(
                  width: 13,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        comapanyname,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        timeposted,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ]),
              ],
            ),
            SizedBox(height: 15),
            Text(
              internshiptitle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                  letterSpacing: 0.5),
            ),
            SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.moneyBills,
                    size: 18, color: Colors.black54),
                SizedBox(
                  width: 10,
                ),
                Text(
                  internshipamount,
                  style: TextStyle(
                      fontSize: 13, fontFamily: 'Roboto', color: Colors.black),
                ),
                SizedBox(width: 20),
                Icon(Icons.pin_drop_outlined, size: 18, color: Colors.black54),
                SizedBox(
                  width: 10,
                ),
                Text(
                  internshiplocation,
                  style: TextStyle(
                      fontSize: 13, fontFamily: 'Roboto', color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Divider(
              color: Colors.black26,
              height: 0.9,
              thickness: 1.5,
            ),
            SizedBox(height: 10),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Roboto',
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 10),
            Text(
              internshipdescription,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontFamily: 'Roboto',
                letterSpacing: 1,
              ),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      )),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          final url = applylink;
          if (await canLaunch(url)) {
            await launch(
              url,
              forceWebView: true,
              enableJavaScript: true,
              enableDomStorage: true,
            );
          }
        },
        child: Container(
          color: Color(0xffeef2f5),
          height: 75,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 21),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF30b2cf)),
              child: Center(
                child: Text('Apply',
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        letterSpacing: 1)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
