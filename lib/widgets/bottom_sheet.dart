import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BottomSheetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF898989),
      height: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black,
              ),
            ),
            Lottie.asset('assets/mail_icon.json', height: 130, width: 150),
            Text(
              'Please check your E-mail',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Text(
                'A Verfication link has been sent to your mail ID Please Verify to proceed',
                style: TextStyle(fontSize: 18, color: Color(0xFFA3A3A3)),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 20),
              child: OutlinedButton(
                onPressed: () {},
                child: Text(
                  'Send Again',
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 15),
                    side: BorderSide(
                        color: Colors.black26.withOpacity(0.3), width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
