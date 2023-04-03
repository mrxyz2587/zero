import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:zero_fin/models/reels.dart';
import '/models/post.dart';
import '/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _currentUserUid = FirebaseAuth.instance.currentUser!.uid.toString();
  Future<String> uploadReels(
    String description,
    File file,
    String uid,
    String username,
    String profImage,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String reelUrl =
          await StorageMethods().uploadVedioToStorage('reels', file, true);

      // String vedioUrl =
      //     await StorageMethods().uploadVedioToStorage('reels', vedioFile, true);
      String reelId = const Uuid().v1(); // creates unique id based on time
      Reels reels = Reels(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        reelId: reelId,
        datePublished:
            DateFormat.yMMMMd('en_US').format(DateTime.now()).toString(),
        reelUrl: reelUrl,
        profImage: profImage,
        saves: [],
      );
      _firestore.collection('reels').doc(reelId).set(reels.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage, String privacy) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      // String vedioUrl =
      //     await StorageMethods().uploadVedioToStorage('reels', vedioFile, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished:
              DateFormat.yMMMMd('en_US').format(DateTime.now()).toString(),
          postUrl: photoUrl,
          profImage: profImage,
          saves: [],
          privacy: privacy,
          timestamp: DateTime.now());
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadReportsOnPost(String postId, String reportingUseruserId,
      String usermailIdposting) async {
    try {
      _firestore
          .collection('reports')
          .doc(reportingUseruserId)
          .collection('posts')
          .doc(postId)
          .set({
        'postId': postId,
        'reportingUserId': reportingUseruserId,
        'postinguseruid': usermailIdposting
      });
      return ' ';
    } catch (e) {
      return 'error aa gaya';
    }
  }

  Future<String> UploadResume(File file) async {
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToResumeage('resume', file, true);
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateNotifications(
      String postUid,
      String currentUsername,
      String type,
      String postId,
      List likes,
      String uid,
      String photoUrl) async {
    if (likes.contains(uid) && type == 'liked') {
    } else {
      String notifId = const Uuid().v1(); // creates unique id based on time

      await _firestore
          .collection('notifications')
          .doc(postUid)
          .collection('allNotifications')
          .doc(notifId)
          .set({
        'username': currentUsername,
        'type': type,
        'postId': postId,
        'uidcurrent': uid,
        'photoUrl': photoUrl,
        'time': DateTime.now(),
        'isSeen': false,
        'docId': notifId
      });
    }

    return '';
  }

  Future<String> likeComment(
      String commentId, String uid, List likes, String postId) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeCommentMensFashion(
      String commentId, String uid, List likes, String postId) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore
            .collection('ecommale')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore
            .collection('ecommale')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(
      String postId, String uid, List likes, Future functions) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        functions;
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeMenfashion(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('ecommale').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('ecommale').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeReel(String reelId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('reels').doc(reelId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('reels').doc(reelId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> pinnedEvents(String eventId, List savedItem) async {
    if (savedItem.contains(_currentUserUid)) {
      await _firestore.collection('events').doc(eventId).update({
        'saves': FieldValue.arrayRemove([_currentUserUid])
      });
    } else {
      await _firestore.collection('events').doc(eventId).update({
        'saves': FieldValue.arrayUnion([_currentUserUid])
      });
    }

    return '';
  }

  Future<String> SavedPosts(String postId, String uid, List saved) async {
    String res = "Some error occurred";
    try {
      if (saved.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'saves': FieldValue.arrayRemove([uid])
        });
        print("array remove called");
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'saves': FieldValue.arrayUnion([uid])
        });
        print("array Union called");
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> SavedMenFashion(String postId, String uid, List saved) async {
    String res = "Some error occurred";
    try {
      if (saved.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('ecommale').doc(postId).update({
          'saves': FieldValue.arrayRemove([uid])
        });
        print("array remove called");
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('ecommale').doc(postId).update({
          'saves': FieldValue.arrayUnion([uid])
        });
        print("array Union called");
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(
      String postId,
      String text,
      String uid,
      String name,
      String profilePic,
      Future functions,
      String universityname) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'universityname': universityname,
          'likes': []
        });
        res = 'success';
        functions;
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postCommentMensFashion(String postId, String text, String uid,
      String name, String profilePic, String universityname) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('ecommale')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'universityname': universityname,
          'likes': []
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> reelsComment(String reelsId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('reels')
            .doc(reelsId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId, String followUsername,
      String followphotoUrl, String followStatus, String followToken) async {
    try {
      DocumentSnapshot uCsnap = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var profilepic = (uCsnap.data()! as dynamic)['photoUrl'];
      var username = (uCsnap.data()! as dynamic)['username'];
      var status = (uCsnap.data()! as dynamic)['status'];
      var token = (uCsnap.data()! as dynamic)['token'];

      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();

      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore
            .collection('users')
            .doc(followId)
            .collection('followers')
            .doc(uid)
            .delete();

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('following')
            .doc(followId)
            .delete();
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore
            .collection('users')
            .doc(followId)
            .collection('followers')
            .doc(uid)
            .set({
          'followid': uid,
          'profilepic': profilepic,
          'username': username,
          'status': status,
          'token': token,
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('following')
            .doc(followId)
            .set({
          'followid': followId,
          'profilepic': followphotoUrl,
          'username': followUsername,
          'status': followStatus,
          'token': followToken,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
