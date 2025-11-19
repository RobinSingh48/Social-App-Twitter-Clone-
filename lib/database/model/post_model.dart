import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String id;
  final String uid;
  final String user;
  final String username;
  final String message;
  final Timestamp timestamp;
  final int likes;
  final List<String> likedBy;

  Posts({
    required this.id,
    required this.uid,
    required this.user,
    required this.username,
    required this.message,
    required this.timestamp,
    required this.likes,
    required this.likedBy,
  });

  factory Posts.fromDocument(DocumentSnapshot docs) {
    return Posts(
      id: docs.id,
      uid: docs["uid"],
      user: docs["user"],
      username: docs["username"],
      message: docs["message"],
      timestamp: docs["timestamp"],
      likes: docs["likes"],
      likedBy: List.from(docs["likedBy"] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid":uid,
      "user" : user,
      "username" : username,
      "message" : message,
      "timestamp" : timestamp,
      "likes" : likes,
      "likedBy" : likedBy,
    };
  }
}
