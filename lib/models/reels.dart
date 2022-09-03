import 'package:cloud_firestore/cloud_firestore.dart';

class Reels {
  final String description;
  final String uid;
  final String username;
  final likes;
  final saves;
  final String reelId;
  final String datePublished;
  final String reelUrl;
  final String profImage;

  const Reels(
      {required this.description,
      required this.uid,
      required this.username,
      required this.likes,
      required this.reelId,
      required this.datePublished,
      required this.reelUrl,
      required this.profImage,
      required this.saves});

  static Reels fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Reels(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        reelId: snapshot["reelId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        reelUrl: snapshot['reelUrl'],
        saves: snapshot['saves'],
        profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "reelId": reelId,
        "datePublished": datePublished,
        'reelUrl': reelUrl,
        'profImage': profImage,
        'saves': saves
      };
}
