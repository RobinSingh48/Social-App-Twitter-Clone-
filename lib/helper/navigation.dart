import 'package:flutter/material.dart';
import 'package:social_app/database/model/post_model.dart';
import 'package:social_app/pages/account_setting_page.dart';
import 'package:social_app/pages/blockedUser_page.dart';
import 'package:social_app/pages/comment_page.dart';
import 'package:social_app/pages/follow_following_page.dart';
import 'package:social_app/pages/homepage.dart';
import 'package:social_app/pages/login_page.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/pages/register_page.dart';
import 'package:social_app/pages/search_page.dart';
import 'package:social_app/pages/setting_page.dart';

void goToSettingPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SettingPage()),
  );
}

void goToLoginPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

void goToRegisterPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RegisterPage()),
  );
}

void goToHomePage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
}

void goToHomePushReplace(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Homepage()),
    (route) => false,
  );
}

void goToLoginPagePushReplace(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    (route) => false,
  );
}

void goToProfilePage(BuildContext context, String uid) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilePage(uid: uid)),
  );
}

void goToCommentPage(BuildContext context, Posts post) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CommentPage(post: post)),
  );
}

void goToBlockedUserPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BlockeduserPage()),
  );
}

void goToFollowUnFollowPage(BuildContext context, String uid) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FollowFollowingPage(uid: uid)),
  );
}

void goToAccountSettingPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AccountSettingPage()),
  );
}

Route<Object?> goToDeletePageToLoginPage(BuildContext context) {
  return MaterialPageRoute(builder: (context) => LoginPage());
}

void goToSearchPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SearchPage()),
  );
}
