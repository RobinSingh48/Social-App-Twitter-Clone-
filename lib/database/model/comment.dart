import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  final String id;
  final String uid;
  final String user;
  final String username;
  final String postId;
  final String message;
  final Timestamp timestamp;

  Comments({
    required this.id,
    required this.uid,
    required this.user,
    required this.username,
    required this.postId,
    required this.message,
    required this.timestamp,
  });

  factory Comments.fromDocuments(DocumentSnapshot docs) {
    return Comments(
      id: docs.id,
      uid: docs["uid"],
      user: docs["user"],
      username: docs["username"],
      postId: docs["postId"],
      message: docs["message"],
      timestamp: docs["timestamp"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "user" : user,
      "username" : username,
      "postId" : postId,
      "message" : message,
      "timestamp" : timestamp,
    };
  }
}
