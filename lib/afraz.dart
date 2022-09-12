import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            Positioned(
              top: 20,
              left: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1661747675166-5cf96bd5d0dc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzR8fHByb2Zlc2lvbmFsJTIwcGVyc29ufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Afraz Hasan Naqvi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 30,
                left: 20,
                child: Text(
                  'This is Description.....🙂🙂',
                  style: TextStyle(fontSize: 18),
                )),
            Positioned(
                bottom: 25,
                right: 15,
                child: Icon(
                  FontAwesomeIcons.imagePortrait,
                  size: 35,
                ))
          ]),
        ),
      ),
    );
  }
}
