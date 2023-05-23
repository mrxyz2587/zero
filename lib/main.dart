import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zero_fin/resources/firebase_dynamic_links.dart';
import 'package:zero_fin/screens/SharedPostDisplay.dart';
import 'package:zero_fin/screens/newlogin/pageViewScreen.dart';
import 'package:zero_fin/screens/testing-screen.dart';
import 'package:zero_fin/utils/local_notification_services.dart';
import '/providers/user_provider.dart';
import '/responsive/mobile_screen_layout.dart';
import '/responsive/responsive_layout.dart';
import '/responsive/web_screen_layout.dart';
import '/screens/login_screen.dart';
import '/utils/colors.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDft8V3weZKfL1a33WmbWtWRNEfvGH1o3w",
          appId: "1:503950176133:android:9ce44965150346fd81deec",
          messagingSenderId: "503950176133",
          projectId: "zeroth-ed350",
          storageBucket: 'gs://zeroth-ed350.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  LocalNotificationService.initialize();
  runApp(MyApp(
    initialLink: initialLink,
  ));
}

class MyApp extends StatefulWidget {
  final PendingDynamicLinkData? initialLink;

  MyApp({Key? key, required this.initialLink})
      : super(
          key: key,
        );

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    if (widget.initialLink != null) {
      String path = widget.initialLink!.link!.path;
      print('path = ${path.toString()}');
    }

    super.initState();
  }

  String? userName;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark
        //or set color with: Color(0xFF0000FF)
        ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        title: 'zero',
        home: Splash(widget.initialLink),
      ),
    );
  }
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {}
