import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:zero_fin/models/post.dart';

class FirebaseDynamicLinksService {
  static Future<String> createDynamicLink(String post) async {
    String linkMessage;
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://be10timesbetter.page.link/post?id=${post}"),
      uriPrefix: "https://be10timesbetter.page.link/Go1D",
      androidParameters: const AndroidParameters(
        packageName: "com.example.zero_fin",
        minimumVersion: 30,
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    linkMessage = dynamicLink.toString();
    return linkMessage;
  }
}
