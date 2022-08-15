import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String designation;
  final String department;
  final String dateOfBirth;
  final String bio;

  final List followers;
  final List following;

  const User(
      {required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.designation,
      required this.department,
      required this.dateOfBirth,
      required this.followers,
      required this.following,
      required this.bio});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
        designation: snapshot["designation"],
        department: snapshot["department"],
        dateOfBirth: snapshot["dateOfBirth"],
        followers: snapshot["followers"],
        following: snapshot["following"],
        bio: snapshot["bio"]);
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "designation": designation,
        "department": department,
        "dateOfBirth": dateOfBirth,
        "followers": followers,
        "following": following,
        "bio": bio
      };
}
