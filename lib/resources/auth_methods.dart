import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/user.dart' as model;
import '/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String designation,
      required String department,
      required String dateOfBirth,
      required Uint8List file,
      required String university,
      required String googlephotoUrls}) async {
    String res = "Some error Occurred";
    try {
      if (username.isNotEmpty ||
          designation.isNotEmpty ||
          department.isNotEmpty ||
          dateOfBirth.isNotEmpty) {
        // registering user in auth with email and password
        String? photoUrl;
        if (file != null) {
          photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
        }
        model.User _user = model.User(
          username: username.toLowerCase(),
          uid: _auth.currentUser!.uid,
          photoUrl: photoUrl ?? googlephotoUrls,
          email: email,
          designation: designation,
          department: department,
          dateOfBirth: dateOfBirth,
          followers: [],
          following: [],
          university: university,
          latitudeCoordinates: "29.564",
          longCoordinates: "85.562",
          bio: "Heyy I am also a zero",
          status: "Online",
        );
        await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update(_user.toJson());
        // adding user in our database

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
