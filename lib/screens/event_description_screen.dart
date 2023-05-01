import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/utils/colors.dart';

import '../resources/firebase_dynamic_links.dart';

class EventDescriptionScreen extends StatefulWidget {
  var snap;
  EventDescriptionScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<EventDescriptionScreen> createState() => _EventDescriptionScreenState();
}

class _EventDescriptionScreenState extends State<EventDescriptionScreen> {
  final _razorpay = Razorpay();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          leading: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              size: 25,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            widget.snap['evetitle'],
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000),
                fontSize: 19),
          ),
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
                      .createDynamicLinkforevents(widget.snap.toString());
                  Share.share(
                    generatedDeepLink,
                  );
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(widget.snap['eventposterimg'],
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.27),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Color(0xFF040606),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              widget.snap['category'],
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto',
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        if (widget.snap['mode'] == 'online')
                          GestureDetector(
                            onTap: () async {
                              String generatedDeepLink =
                                  await FirebaseDynamicLinksService
                                      .createDynamicLinkforevents(
                                          widget.snap.toString());
                              Share.share(
                                generatedDeepLink,
                              );
                            },
                            child: Container(
                              height: 24,
                              width: 60,
                              child: Center(
                                child: Text('Online',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Text(widget.snap['evetitle'],
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 11),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 16, color: Colors.black87),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.snap['eventDate'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.black87,
                            letterSpacing: 1,
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 13, right: 13, bottom: 13),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.pin_drop_outlined,
                            size: 17, color: Colors.black87),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.snap['venue'],
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.black87),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Divider(
                      height: 0.5, thickness: 0.5, color: Colors.black26),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 12),
                  child: Text('Event Description',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 17,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                  ),
                  child: Text(widget.snap['evedescc']),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Divider(
                      height: 0.5, thickness: 0.5, color: Colors.black26),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 12),
                  child: Text(
                    'More Information',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Row(children: [
                    Icon(Icons.hourglass_empty_rounded,
                        size: 17, color: Colors.black54),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.snap['courseTiming'],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                          color: Colors.black54),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 12),
                  child: Row(children: [
                    Icon(Icons.sort_by_alpha_outlined,
                        size: 17, color: Colors.black54),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.snap['language'],
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          color: Colors.black54),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Row(children: [
                    Icon(Icons.person_outline_rounded,
                        size: 17, color: Colors.black54),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.snap['agegroup'],
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          color: Colors.black54),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12),
                  child: Divider(
                      height: 0.5, thickness: 0.5, color: Colors.black26),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Text('Terms & Condition',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 17,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 13),
                  child: Text(widget.snap['t&c'],
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          letterSpacing: 0.5,
                          color: Colors.black87),
                      textAlign: TextAlign.justify),
                ),
              ]),
        ),
        bottomNavigationBar: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFF5F5F5),
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rs ${widget.snap['price']}',
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 0.5,
                          fontFamily: 'Roboto'),
                    ),
                    Container(
                      height: 32,
                      width: 112,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: Color(
                            0xFFff3131,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text('Filling Fast',
                            style: TextStyle(
                              color: Color(0xFFff3131),
                              fontSize: 15,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0xFF00c2cb),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 55)),
                  onPressed: () async {
                    // if (await canLaunch(widget.snap['paymentUrl'].toString())) {
                    //   await launch(widget.snap['paymentUrl'],
                    //       enableDomStorage: true,
                    //       enableJavaScript: true,
                    //       forceWebView: true);
                    // }
                  },
                  child: Text('BOOK',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700)),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
