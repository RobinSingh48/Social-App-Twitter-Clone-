import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/database/model/comment.dart';
import 'package:social_app/database/model/post_model.dart';
import 'package:social_app/database/model/user_profile.dart';

class DatabaseService {
  final _auth = AuthDatabase();
  final _db = FirebaseFirestore.instance;

  //Add UserProfile
  Future<void> addUserProfileInFirebase(String email, String username) async {
    String currentUserId = _auth.currentUserId;
    String user = email.split("@")[0];
    ProfileData? data = ProfileData(
      id: "",
      uid: currentUserId,
      user: user,
      username: username,
      bio: "",
      profileImage: "",
    );
    Map<String, dynamic> dataMap = data.toMap();
    await _db.collection("UserProfile").doc(currentUserId).set(dataMap);
  }

  //Get user Profile
  Future<ProfileData?> getUserProfileFromFirebase(String uid) async {
    DocumentSnapshot snapshot = await _db
        .collection("UserProfile")
        .doc(uid)
        .get();
    return ProfileData.fromDocument(snapshot);
  }

  //Update Bio
  Future<void> upDateBioInFirebase(String uid, String bio) async {
    await _db.collection("UserProfile").doc(uid).update({"bio": bio});
  }

  //Add Post
  Future<void> addPostInFirebase(String message) async {
    final currentUserId = _auth.currentUserId;
    ProfileData? user = await getUserProfileFromFirebase(currentUserId);
    Posts post = Posts(
      id: "",
      uid: currentUserId,
      user: user!.user,
      username: user.username,
      message: message,
      timestamp: Timestamp.now(),
      likes: 0,
      likedBy: [],
    );
    Map<String, dynamic> postMap = post.toMap();
    await _db.collection("Posts").add(postMap);
  }

  //Get Load Posts
  Future<List<Posts>> getAllPostFromFirebase() async {
    QuerySnapshot snapshot = await _db
        .collection("Posts")
        .orderBy("timestamp", descending: true)
        .get();

    return snapshot.docs
        .map((snapshot) => Posts.fromDocument(snapshot))
        .toList();
  }

  //Delete Post
  Future<void> deletePostFromFirebase(String postId) async {
    await _db.collection("Posts").doc(postId).delete();
  }

  //Toggle Likes
  Future<void> toggleLikesInFirebase(String postId) async {
    final currentUserId = _auth.currentUserId;
    DocumentReference postRef = _db.collection("Posts").doc(postId);
    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);
      Map<String, dynamic> postData = snapshot.data() as Map<String, dynamic>;
      List<String> likedBy = List<String>.from(postData["likedBy"] ?? []);
      int likes = postData["likes"];
      if (!likedBy.contains(currentUserId)) {
        likedBy.add(currentUserId);
        likes++;
      } else {
        likedBy.remove(currentUserId);
        likes--;
      }
      transaction.update(postRef, {"likedBy": likedBy, "likes": likes});
    });
  }

  //add comment
  Future<void> addCommentInFirebase(String message, String postId) async {
    final currentUserId = _auth.currentUserId;
    ProfileData? user = await getUserProfileFromFirebase(currentUserId);
    Comments comment = Comments(
      id: "",
      uid: currentUserId,
      user: user!.user,
      username: user.username,
      postId: postId,
      message: message,
      timestamp: Timestamp.now(),
    );
    Map<String, dynamic> commentMap = comment.toMap();
    await _db.collection("Comments").add(commentMap);
  }

  //get all comments
  Future<List<Comments>> getAllCommentsFromFirebase(String postId) async {
    QuerySnapshot snapshot = await _db
        .collection("Comments")
        .where("postId", isEqualTo: postId)
        .get();
    return snapshot.docs
        .map((comment) => Comments.fromDocuments(comment))
        .toList();
  }

  //delete comment
  Future<void> deleteCommentFromFirebase(String commentId) async {
    await _db.collection("Comments").doc(commentId).delete();
  }

  //report user
  Future<void> reportUserInFirebase(String postId, String userId) async {
    final currentUserUid = _auth.currentUserId;
    final report = {
      "report": postId,
      "reportUser": userId,
      "reportBy": currentUserUid,
      "timestamp": FieldValue.serverTimestamp(),
    };
    await _db.collection("Report").add(report);
  }

  //block user
  Future<void> blockUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUserId;
    await _db
        .collection("UserProfile")
        .doc(currentUserId)
        .collection("BlockedUser")
        .doc(userId)
        .set({});
  }

  // List of Blocked Users
  Future<List<String>> getBlockUserListFromFirebase() async {
    final currentUserId = _auth.currentUserId;
    QuerySnapshot snapshot = await _db
        .collection("UserProfile")
        .doc(currentUserId)
        .collection("BlockedUser")
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // Unblock user
  Future<void> unblockUserFromFirebase(String userId) async {
    final currentUserId = _auth.currentUserId;
    await _db
        .collection("UserProfile")
        .doc(currentUserId)
        .collection("BlockedUser")
        .doc(userId)
        .delete();
  }

  //Follow, Unfollow

  //Follow user
  Future<void> followUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUserId;
    await _db
        .collection("UserProfile")
        .doc(userId)
        .collection("Followers")
        .doc(currentUserId)
        .set({});
    await _db
        .collection("UserProfile")
        .doc(currentUserId)
        .collection("Following")
        .doc(userId)
        .set({});
  }

  //UnFollow user
  Future<void> unFollowUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUserId;
    await _db
        .collection("UserProfile")
        .doc(userId)
        .collection("Followers")
        .doc(currentUserId)
        .delete();

    await _db
        .collection("UserProfile")
        .doc(currentUserId)
        .collection("Following")
        .doc(userId)
        .delete();
  }

  //Get Following List
  Future<List<String>> getFollowingListFromFirebase(String userId) async {
    QuerySnapshot snapshot = await _db
        .collection("UserProfile")
        .doc(userId)
        .collection("Following")
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  //Get Followers List
  Future<List<String>> getFollowerListFromFirebase(String userId) async {
    QuerySnapshot snapshot = await _db
        .collection("UserProfile")
        .doc(userId)
        .collection("Followers")
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  //Delete UserData

  Future<void> deleteProfileFromFirebase(String uid) async {
    WriteBatch batch = _db.batch();
    DocumentReference userProfileRef = _db.collection("UserProfile").doc(uid);
    batch.delete(userProfileRef);

    QuerySnapshot postSnapshot = await _db
        .collection("Posts")
        .where("uid", isEqualTo: uid)
        .get();

    for (var post in postSnapshot.docs) {
      batch.delete(post.reference);
    }

    QuerySnapshot commentSnapshot = await _db
        .collection("Comments")
        .where("uid", isEqualTo: uid)
        .get();
    for (var comment in commentSnapshot.docs) {
      batch.delete(comment.reference);
    }

    QuerySnapshot allPosts = await _db.collection("Posts").get();
    for (var post in allPosts.docs) {
      Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
      List likedBy = postData["likedBy"];

      if (likedBy.contains(uid)) {
        batch.update(post.reference, {
          "likedBy": FieldValue.arrayRemove([uid]),
          "likes": FieldValue.increment(-1),
        });
      }
    }
    await batch.commit();
  }

  Future<List<ProfileData>> searchUserInFirebase(String username) async {
    String upperCaseUsername = username.toUpperCase();
    QuerySnapshot snapshot = await _db
        .collection("UserProfile")
        .where("username", isGreaterThanOrEqualTo: upperCaseUsername)
        .where("username", isLessThanOrEqualTo: "$upperCaseUsername\uf8ff")
        .get();
    return snapshot.docs.map((doc) => ProfileData.fromDocument(doc)).toList();
  }
}
