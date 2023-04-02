import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageViewing extends StatefulWidget {
  final String docId;

  const ImageViewing({Key? key, required this.docId}) : super(key: key);

  @override
  State<ImageViewing> createState() => _ImageViewingState();
}

class _ImageViewingState extends State<ImageViewing> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String phoneNumber = '';
  int callBtnClicked = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    await _firestore
        .collection('restuarants')
        .doc(widget.docId)
        .get()
        .then((value) {
      phoneNumber = value.data()!['call'].toString();
      callBtnClicked = value.data()!['callBtnClicked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final CarouselController _controller = CarouselController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('restuarants')
                      .doc(widget.docId)
                      .collection('menuandcall')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.grey.shade300,
                        strokeWidth: 1.5,
                      ));
                    }
                    return CarouselSlider.builder(
                      carouselController: _controller,
                      itemCount: snapshot.data!.docs.length,
                      options: CarouselOptions(
                        viewportFraction: 1,
                        enableInfiniteScroll: false,
                        height: MediaQuery.of(context).size.height * 0.90,
                        scrollDirection: Axis.horizontal,
                      ),
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Column(
                        children: [
                          Expanded(
                            child: InteractiveViewer(
                              child: Image.network(
                                      snapshot.data!.docs[itemIndex]
                                          .data()["image"]
                                          .toString(),
                                      fit: BoxFit.fill) ??
                                  Image.asset("images/logo.jpeg",
                                      fit: BoxFit.fill),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    '${itemIndex + 1}/${snapshot.data!.docs.length}',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () async {
                  _firestore
                      .collection('restuarants')
                      .doc(widget.docId)
                      .update({'callBtnClicked': callBtnClicked + 1});

                  await FlutterPhoneDirectCaller.callNumber(
                      phoneNumber.toString());
                },
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 35),
                      child: Text(
                        'Call',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
