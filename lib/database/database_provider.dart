import 'package:flutter/material.dart';

import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/database/database.dart';
import 'package:social_app/database/model/comment.dart';
import 'package:social_app/database/model/post_model.dart';
import 'package:social_app/database/model/user_profile.dart';

class DatabaseServiceProvider extends ChangeNotifier {
  final _db = DatabaseService();
  final _auth = AuthDatabase();

  Future<void> addUserProfileProvider(String email, String username) =>
      _db.addUserProfileInFirebase(email, username);

  Future<void> upDateBioProvider(String uid, String bio) =>
      _db.upDateBioInFirebase(uid, bio);

  Future<ProfileData?> getUserProfileProvider(String uid) =>
      _db.getUserProfileFromFirebase(uid);

  List<Posts> _allPosts = [];
  List<Posts> get allPosts => _allPosts;

  Future<void> loadAllPostsProvider() async {
    final posts = await _db.getAllPostFromFirebase();
    final blockUserId = await _db.getBlockUserListFromFirebase();
    _allPosts = posts.where((doc) => !blockUserId.contains(doc.uid)).toList();
    initializedLikes();

    notifyListeners();
  }

  List<Posts> filterMyPost(String uid) {
    return allPosts.where((post) => post.uid == uid).toList();
  }

  Future<void> addPostProvider(String message) async {
    await _db.addPostInFirebase(message);
    loadAllPostsProvider();
  }

  Future<void> deletePostProvider(String postId) async {
    await _db.deletePostFromFirebase(postId);
    loadAllPostsProvider();
  }

  List<String> _likedBy = [];
  Map<String, int> _likes = {};

  bool isLikedByOwn(String postId) => _likedBy.contains(postId);
  int getLikes(String postId) => _likes[postId] ?? 0;

  void initializedLikes() {
    final currentUserId = _auth.currentUserId;
    _likedBy.clear();
    for (var post in _allPosts) {
      _likes[post.id] = post.likes;
      if (post.likedBy.contains(currentUserId)) {
        _likedBy.add(post.id);
      }
    }
  }

  Future<void> toggleLikesProvider(String postId) async {
    final originalLikedBy = _likedBy;
    final originalLikes = _likes;

    if (_likedBy.contains(postId)) {
      _likedBy.remove(postId);
      _likes[postId] = (_likes[postId] ?? 0) - 1;
    } else {
      _likedBy.add(postId);
      _likes[postId] = (_likes[postId] ?? 0) + 1;
    }
    notifyListeners();
    try {
      await _db.toggleLikesInFirebase(postId);
    } catch (e) {
      _likedBy = originalLikedBy;
      _likes = originalLikes;

      notifyListeners();
    }
  }

  //Comment Staff

  final Map<String, List<Comments>> _comments = {};
  List<Comments> getComments(String postId) => _comments[postId] ?? [];

  //get all comments
  Future<void> loadAllCommentsProvider(String postId) async {
    final blockUserId = await _db.getBlockUserListFromFirebase();
    final comment = await _db.getAllCommentsFromFirebase(postId);
    _comments[postId] = comment
        .where((doc) => !blockUserId.contains(doc.uid))
        .toList();
    loadAllPostsProvider();
    notifyListeners();
  }

  Future<void> addCommentProvider(String message, String postId) async {
    await _db.addCommentInFirebase(message, postId);
    loadAllCommentsProvider(postId);
  }

  Future<void> deleteCommentProvider(String commentId, String postId) async {
    await _db.deleteCommentFromFirebase(commentId);
    loadAllCommentsProvider(postId);
  }

  //block,report,unblock

  List<ProfileData?> _blockedUsers = [];
  List<ProfileData?> get blockedUsers => _blockedUsers;

  //Get Blocked User List
  Future<void> getBlockUsersProvider() async {
    final blockedUsersIds = await _db.getBlockUserListFromFirebase();

    await Future.wait(
      _allPosts.map((user) => loadAllCommentsProvider(user.id)),
    );

    final blockedUsersProfile = await Future.wait(
      blockedUsersIds.map((userId) => _db.getUserProfileFromFirebase(userId)),
    );
    _blockedUsers = blockedUsersProfile;
    notifyListeners();
  }

  //Block User
  Future<void> blockUserProvider(String userId) async {
    await _db.blockUserInFirebase(userId);
    await loadAllPostsProvider();
    for (var post in _allPosts) {
      await loadAllCommentsProvider(post.id);
    }
    loadAllPostsProvider();

    getBlockUsersProvider();

    notifyListeners();
  }

  //Unblock User
  Future<void> unBlockUserProvider(String userId) async {
    await _db.unblockUserFromFirebase(userId);

    loadAllPostsProvider();
    getBlockUsersProvider();
    notifyListeners();
  }

  //Report User
  Future<void> reportUserProvider(String postId, String userId) async {
    await _db.reportUserInFirebase(postId, userId);
  }

  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};

  final Map<String, int> _followersCount = {};
  final Map<String, int> _followingCount = {};

  int getFollowersCount(String userId) => _followersCount[userId] ?? 0;
  int getFollowingCount(String userId) => _followingCount[userId] ?? 0;

  bool isMeFollowing(String userId) {
    final currentUserId = AuthDatabase().currentUserId;
    return _followers[userId]?.contains(currentUserId) ?? false;
  }

  Future<void> loadFollowFollowingListProvider(String userId) async {
    final followers = await _db.getFollowerListFromFirebase(userId);
    final following = await _db.getFollowingListFromFirebase(userId);
    _followers[userId] = followers;
    _followersCount[userId] = followers.length;

    _following[userId] = following;
    _followingCount[userId] = following.length;
    notifyListeners();
  }

  //Follow User
  Future<void> followUserProvider(String userId) async {
    final currentUserId = AuthDatabase().currentUserId;

    _followers.putIfAbsent(userId, () => []);
    _following.putIfAbsent(currentUserId, () => []);

    if (!_followers[userId]!.contains(currentUserId)) {
      _followers[userId]?.add(currentUserId);
      _followersCount[userId] = (_followersCount[userId] ?? 0) + 1;

      _following[currentUserId]?.add(userId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;

      notifyListeners();
      try {
        await _db.followUserInFirebase(userId);
        await _db.getFollowerListFromFirebase(currentUserId);
        await _db.getFollowingListFromFirebase(currentUserId);
      } catch (e) {
        _followers[userId]?.remove(currentUserId);
        _followersCount[userId] = (_followersCount[userId] ?? 0) - 1;

        _following[currentUserId]?.remove(userId);
        _followingCount[currentUserId] =
            (_followingCount[currentUserId] ?? 0) - 1;
        notifyListeners();
      }
    }
  }

  Future<void> unFollowUserProvider(String userId) async {
    final currentUserId = AuthDatabase().currentUserId;

    _followers.putIfAbsent(userId, () => []);
    _following.putIfAbsent(currentUserId, () => []);

    if (_followers[userId]!.contains(currentUserId)) {
      _followers[userId]?.remove(currentUserId);
      _followersCount[userId] = (_followersCount[userId] ?? 0) - 1;

      _following[currentUserId]?.remove(userId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) - 1;

      notifyListeners();
      try {
        await _db.unFollowUserInFirebase(userId);
        await _db.getFollowerListFromFirebase(currentUserId);
        await _db.getFollowingListFromFirebase(currentUserId);
      } catch (e) {
        _followers[userId]?.add(currentUserId);
        _followersCount[userId] = (_followersCount[userId] ?? 0) + 1;

        _following[currentUserId]?.add(userId);
        _followingCount[currentUserId] =
            (_followingCount[currentUserId] ?? 0) + 1;
        notifyListeners();
      }
    }
  }

  final Map<String, List<ProfileData>> _followerProfileList = {};
  final Map<String, List<ProfileData>> _followingProfileList = {};

  List<ProfileData> getFollowerProfileList(String userId) =>
      _followerProfileList[userId] ?? [];
  List<ProfileData> getFollowingProfileList(String userId) =>
      _followingProfileList[userId] ?? [];

  Future<void> getFollowerProfileListProvider(String userId) async {
    final followerList = await _db.getFollowerListFromFirebase(userId);
    final followerProfile = await Future.wait(
      followerList.map((userId) => _db.getUserProfileFromFirebase(userId)),
    );
    _followerProfileList[userId] = followerProfile
        .whereType<ProfileData>()
        .toList();
    notifyListeners();
  }

  Future<void> getFollowingProfileListProvider(String userId) async {
    final followingList = await _db.getFollowingListFromFirebase(userId);
    final followingProfile = await Future.wait(
      followingList.map((userId) => _db.getUserProfileFromFirebase(userId)),
    );
    _followingProfileList[userId] = followingProfile
        .whereType<ProfileData>()
        .toList();
    notifyListeners();
  }

  List<ProfileData> _searchUserList = [];
  List<ProfileData> get searchUserList => _searchUserList;

  Future<void> searchUserProvider(String username) async {
    final searchUser = await _db.searchUserInFirebase(username);
    _searchUserList = searchUser;
    notifyListeners();
  }
}
