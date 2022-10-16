import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';
import '../widgets/event_item.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Builder(builder: (BuildContext context) {
            return Scaffold(
                backgroundColor: Color(0xFFEFEFEF),
                appBar: AppBar(
                    elevation: 1,
                    backgroundColor: Colors.white,
                    leading: Icon(FontAwesomeIcons.solidBell,
                        color: Colors.black),
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text('UNIVERSITY NOTICES (3)',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,fontFamily: 'Roboto'),),
                    ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 10.0,right: 18.0,left: 18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:
                          Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(12)),
                      ),
                      child: Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20),
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                  child: Image.asset('images/Quantumlogo.png')),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text('Quantum University',
                                        style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w700,
                                            fontFamily: 'Roboto')),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text('Feshers Party',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                            fontFamily: 'Roboto')),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 13),
                              child: Row(
                                children: [
                                  IconButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: btnCOlorblue,
                                        minimumSize: Size(50, 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                7))),
                                    onPressed:
                                        () {}, //TODO 2. button action
                                    icon: Icon(
                                      FontAwesomeIcons.streetView,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 10.0,right: 18.0,left: 18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:
                          Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(12)),
                      ),
                      child: Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20),
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                  child: Image.asset('images/Quantumlogo.png')),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text('Quantum University',
                                        style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w700,
                                            fontFamily: 'Roboto')),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text('Feshers Party',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                            fontFamily: 'Roboto')),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 13),
                              child: Row(
                                children: [
                                  IconButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: btnCOlorblue,
                                        minimumSize: Size(50, 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                7))),
                                    onPressed:
                                        () {}, //TODO 2. button action
                                    icon: Icon(
                                      FontAwesomeIcons.streetView,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 10.0,right: 18.0,left: 18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:
                          Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(12)),
                      ),
                      child: Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20),
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                  child: Image.asset('images/Quantumlogo.png')),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text('Quantum University',
                                        style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w700,
                                            fontFamily: 'Roboto')),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text('Feshers Party',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                            fontFamily: 'Roboto')),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 13),
                              child: Row(
                                children: [
                                  IconButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: btnCOlorblue,
                                        minimumSize: Size(50, 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                7))),
                                    onPressed:
                                        () {}, //TODO 2. button action
                                    icon: Icon(
                                      FontAwesomeIcons.streetView,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 18),
                      child: Center(child: Text("Show more",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black54),)),
                    ),
                    Container(
                      color: Colors.white,
                      height: 600,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ACTIVITY",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,fontFamily: 'Roboto')),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top:18.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(),
                                    SizedBox(width: 20),
                                    Text('Rohit Raj liked your post',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,fontFamily: 'Roboto'))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ]
                ));
          });
        });
  }
}
