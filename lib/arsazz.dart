import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Reels',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Stack(
            children: [
              Positioned(
                  bottom: 60,
                  right: 18,
                  child: Column(children: [
                    Icon(
                      FontAwesomeIcons.heart,
                      size: 30,
                      color: Colors.black,
                    ),
                    Text('695k'),
                    SizedBox(
                      height: 15,
                    ),
                    Icon(
                      FontAwesomeIcons.comment,
                      size: 30,
                      color: Colors.black,
                    ),
                    Text('695k'),
                    SizedBox(
                      height: 15,
                    ),
                    Icon(
                      FontAwesomeIcons.paperPlane,
                      size: 30,
                      color: Colors.black,
                    ),
                  ])),
              Positioned(
                  bottom: 50,
                  left: 30,
                  child: Row(
                    children: [
                      Text('pragyaachhajer'),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Follow'),
                        style: TextButton.styleFrom(
                            side: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        )),
                      )
                    ],
                  )),
              Positioned(
                  bottom: 30, left: 30, child: Text('What even!????    '))
            ],
          )),
    );
  }
}
