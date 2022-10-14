import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:zero_fin/utils/utils.dart';
import '../main.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {

bool isEmailVerified = false;
Timer? timer;
bool canResendEmail = false; 

void initState() {
  super.initState();

  isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

  if (!isEmailVerified) {
    sendVerificationEmail();

    timer = Timer.periodic(
      Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
  }
}

void dispose() {
  timer?.cancel();

  super.dispose();
}

Future checkEmailVerified() async {

await FirebaseAuth.instance.currentUser!.reload();

  setState(() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  });

  if (isEmailVerified) timer?.cancel();
}

Future sendVerificationEmail() async {
  try {
  final user = FirebaseAuth.instance.currentUser!;
  await user.sendEmailVerification();

  setState(() {
    canResendEmail = false;
  });
  await Future.delayed(Duration(seconds: 5));
} catch (e) {
  print(e);
}

}

  @override
 Widget build(BuildContext context) {
    return isEmailVerified ? MyApp(): 
    Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'A verification email has been sent to your mail',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24,),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            onPressed: canResendEmail ?sendVerificationEmail : null, 
            icon: Icon(Icons.email,size: 32,), 
            label: Text('Resent Email',
            style: TextStyle(fontSize: 24),
            ),
            ),
           SizedBox(height: 8,),
           TextButton(
            style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            onPressed: () => FirebaseAuth.instance.signOut(), 
            child: Text('Cancel',
            style: TextStyle(fontSize: 24),
            )) 
        ],
      ),
      ),
    )
    ;
  }
}