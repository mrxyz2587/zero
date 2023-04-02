import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final saves;
  final String postId;
  final String datePublished;
  final String postUrl;
  final String profImage;
  final String privacy;
  final DateTime timestamp;

  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.likes,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.saves,
      required this.privacy,
      required this.timestamp});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        saves: snapshot['saves'],
        profImage: snapshot['profImage'],
        privacy: snapshot['privacy'],
        timestamp: snapshot['timestamp']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'saves': saves,
        'privacy': privacy,
        'timestamp': timestamp
      };
}
