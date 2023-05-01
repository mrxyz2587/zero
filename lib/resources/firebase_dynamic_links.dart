import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zero_fin/models/post.dart';
import 'package:zero_fin/screens/SharedPostDisplay.dart';

class FirebaseDynamicLinksService {
  static Future<String> createDynamicLink(String postId) async {
    String linkMessage;
    print(postId);
    String link = "https://zeromonk.page.link/post?postId=$postId";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: "https://zeromonk.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.zeromonk.zero",
        minimumVersion: 30,
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    linkMessage = dynamicLink.toString();
    return linkMessage;
  }

  static Future<String> createDynamicLinkforevents(String eventSnap) async {
    String linkMessage;
    String link = "https://zeromonk.page.link/event?eventSnap=$eventSnap";

    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: "https://zeromonk.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.zeromonk.zero",
        minimumVersion: 30,
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    linkMessage = dynamicLink.toString();
    print(linkMessage);
    return linkMessage;
  }
}
