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
    String link = "https://betentimebetter.page.link/post?postId=$postId";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: "https://be10timesbetter.page.link/Go1D",
      androidParameters: const AndroidParameters(
        packageName: "com.example.zero_fin",
        minimumVersion: 30,
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    linkMessage = dynamicLink.toString();
    print('methods \n\n\n');
    print(dynamicLink.toString());
    return linkMessage;
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    print('init dynamic link called');
    FirebaseDynamicLinks.instance.onLink.listen((dynamiclinkData) async {
      print('onclick dynamic link called');
      final Uri deepLink = dynamiclinkData.link;
      print(dynamiclinkData.link.toString());
      var isStory = deepLink.pathSegments.contains('post');
      print("$isStory is story called");
      // TODO :Modify Accordingly

      if (isStory) {
        var id = deepLink.queryParameters['postId'];
        print('$id \n\n\n' + ' this is the postid');

        if (deepLink != null) {
          // TODO : Navigate to your pages accordingly here
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SharedPostsDiplay(
                        postId: id.toString(),
                      )));

          print(id.toString());
          try {
            // await FirebaseFirestore.instance
            //     .collection('posts')
            //     .doc(id)
            //     .get()
            //     .then((snapshot) {
            //   // StoryData storyData = StoryData.fromSnapshot(snapshot);
            //   //
            //   // return Navigator.push(context, MaterialPageRoute(builder: (context) =>
            //   //   StoryPage(story: storyData,)
            //   // ));
            // });
          } catch (e) {
            print(e);
          }
        } else {
          return print('error');
        }
      }
    }).onError((error) {
      print(error.toString());
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    print('${deepLink?.toString()} \n\n\n pending');
    var isStory = deepLink?.pathSegments.contains('post');
    if (isStory == true) {
      // TODO :Modify Accordingly
      String? id =
          deepLink!.queryParameters['postId']; // TODO :Modify Accordingly
      print('$id \n\n\n' + ' this is the postid');
      // TODO : Navigate to your pages accordingly here
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SharedPostsDiplay(
                    postId: id.toString(),
                  )));
      if (deepLink != null) {}
      try {
        //   await firebaseFirestore.collection('Stories').doc(id).get()
        //       .then((snapshot) {
        //     StoryData storyData = StoryData.fromSnapshot(snapshot);
        //
        //     return Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //         StoryPage(story: storyData,)
        //     ));
        //   });
      } catch (e) {
        print(e);
      }
    }

    try {} catch (e) {
      print('No deepLink found');
    }
  }
}
