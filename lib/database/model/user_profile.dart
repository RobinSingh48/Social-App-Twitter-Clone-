import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileData {
  final String id;
  final String uid;
  final String user;
  final String username;
  final String bio;
  final String profileImage;

  ProfileData({
    required this.id,
    required this.uid,
    required this.user,
    required this.username,
    required this.bio,
    required this.profileImage
  });

  factory ProfileData.fromDocument(DocumentSnapshot docs) {
    return ProfileData(
      id: docs.id,
      uid: docs["uid"],
      user: docs["user"],
      username: docs["username"],
      bio: docs["bio"],
      profileImage: docs["profileImage"]??"",
    );
  }

  Map<String, dynamic> toMap() {
    return {"uid": uid, "user": user, "username": username, "bio": bio,"profileImage":profileImage};
  }
}
