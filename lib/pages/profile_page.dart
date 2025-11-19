import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/components/alert_warning_message.dart';
import 'package:social_app/components/my_alertbox.dart';
import 'package:social_app/components/my_bio_container.dart';
import 'package:social_app/components/my_follow_button.dart';
import 'package:social_app/components/my_post_container.dart';
import 'package:social_app/components/my_stats.dart';
import 'package:social_app/database/database_provider.dart';
import 'package:social_app/database/model/user_profile.dart';
import 'package:social_app/helper/navigation.dart';
import 'package:social_app/helper/pop_messages.dart';
import 'package:social_app/helper/textstyle.dart';

import 'package:social_app/helper/theme_name.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData? userData;
  final currentUserId = AuthDatabase().currentUserId;
  late final databaseProvider = Provider.of<DatabaseServiceProvider>(
    context,
    listen: false,
  );
  late final listenableProvider = Provider.of<DatabaseServiceProvider>(context);

  final _bioController = TextEditingController();

  bool isLoading = true;

  void editBio() {
    showDialog(
      context: context,
      builder: (context) => MyAlertbox(
        controller: _bioController,
        hintText: "Edit Bio",
        onTap: () {
          updateBio();
          _bioController.clear();
          Navigator.pop(context);
        },
        buttonName: "Yes",
      ),
    );
  }

  Future<void> loadUserProfile() async {
    try {
      userData = await databaseProvider.getUserProfileProvider(widget.uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      showErrorMessage(
        context,
        "Error",
        "Something went wrong while loading profile",
      );
    }
  }

  Future<void> updateBio() async {
    final bio = _bioController.text.trim();
    setState(() {
      isLoading = true;
    });
    try {
      await databaseProvider.upDateBioProvider(widget.uid, bio);
      loadUserProfile();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      showErrorMessage(context, "Error", "Something went wrong while updating");
    }
  }

  Future<void> loadFollowerAndFollowingList() async {
    await databaseProvider.loadFollowFollowingListProvider(widget.uid);
  }

  Future<void> toggle() async {
    final isFollowingNow = listenableProvider.isMeFollowing(widget.uid);
    if (isFollowingNow) {
      showDialog(
        context: context,
        builder: (context) => AlertWarningMessage(
          title: "Unfollow User",
          message: "Are you sure? you want to unfollow this user",
          onTap: () async {
            await databaseProvider.unFollowUserProvider(widget.uid);
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          buttonName: "Yes",
        ),
      );
    } else {
      await databaseProvider.followUserProvider(widget.uid);
    }
    loadFollowerAndFollowingList();
  }

  @override
  void initState() {
    loadUserProfile();
    loadFollowerAndFollowingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var settingIconStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: context.primary,
      fontSize: 18,
    );
    final filterPosts = listenableProvider.filterMyPost(widget.uid);
    bool isMyProfile = currentUserId == widget.uid;
    int postsCount = listenableProvider.filterMyPost(widget.uid).length;
    int followers = listenableProvider.getFollowersCount(widget.uid);
    int following = listenableProvider.getFollowingCount(widget.uid);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isLoading ? "Loading" : userData!.username),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Text(
                isLoading ? "Loading" : "@${userData!.user}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: context.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //Profile Person Icon
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, size: 90),
            ),
            SizedBox(height: 10),
            if (!isMyProfile)
              MyFollowButton(
                isFollowing: listenableProvider.isMeFollowing(widget.uid),
                onTap: toggle,
              ),
            //MyStats Container
            GestureDetector(
              onTap: () => goToFollowUnFollowPage(context,widget.uid),
              child: MyStats(
                postNumber: postsCount,
                followerCount: followers,
                followeringCount: following,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Bio Text
                  Text("Bio", style: settingIconStyle),
                  //Bio Edit Button
                  if (isMyProfile)
                    GestureDetector(
                      onTap: () => editBio(),
                      child: Icon(
                        Icons.settings,
                        size: 30,
                        color: context.primary,
                      ),
                    ),
                ],
              ),
            ),
            //BioContainer
            MyBioContainer(message: isLoading ? "Loading" : userData!.bio),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Posts",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 10),
            filterPosts.isEmpty
                ? Center(child: Text("No Posts", style: boldText()))
                : Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filterPosts.length,
                      itemBuilder: (context, index) {
                        final filterpost = filterPosts[index];
                        return MyPostContainer(
                          post: filterpost,
                          onUserTap: () {},
                          onMessageTap: () =>
                              goToCommentPage(context, filterpost),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
