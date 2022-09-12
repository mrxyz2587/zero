import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/text_field_input.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: 'https://zeroth-ed350.firebaseapp.com',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.zeroth_fin',
      androidPackageName: 'com.example.zeroth_fin',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');
  final db = FirebaseFirestore.instance;
  final textController = TextEditingController();
  void getData() async {
    // var userData = await db
    //     .collection('unregisteredUsers')
    //     .where('email', isEqualTo: textController.text)
    //     .get()
    //     .then(
    //         (event) => {
    //               for (var doc in event.docs)
    //                 {print("${doc.id} => ${doc.data()['email']}")}
    //             },
    //         onError: (e) => print('notFound'));

    await FirebaseAuth.instance
        .sendSignInLinkToEmail(
            email: textController.text, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFieldInput(
            textInputType: TextInputType.emailAddress,
            textEditingController: textController,
            hintText: 'email',
          ),
          ElevatedButton(
            onPressed: () => getData(),
            child: Text('Fetch'),
          ),
        ],
      ),
    );
  }
}
