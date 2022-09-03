import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zero_fin/screens/courses_screen.dart';
import 'package:zero_fin/screens/events_screen.dart';
import 'package:zero_fin/screens/reels_screen.dart';
import '/screens/add_post_screen.dart';
import '/screens/feed_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const ReelsScreen(),
  const AddPostScreen(),
  const Course_screen(),
  EventScreen()
  // ProfileScreen(
  //   uid: FirebaseAuth.instance.currentUser!.uid,
  // ),
];
