import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/my_profile_container.dart';
import 'package:social_app/database/database_provider.dart';
import 'package:social_app/database/model/user_profile.dart';

class FollowFollowingPage extends StatefulWidget {
  final String uid;
  const FollowFollowingPage({super.key, required this.uid});

  @override
  State<FollowFollowingPage> createState() => _FollowFollowingPageState();
}

class _FollowFollowingPageState extends State<FollowFollowingPage> {
  late final databaseProvider = Provider.of<DatabaseServiceProvider>(
    context,
    listen: false,
  );
  late final listenableProvider = Provider.of<DatabaseServiceProvider>(context);

  Future<void> loadFollowFollowingList() async {
    await databaseProvider.getFollowerProfileListProvider(widget.uid);
    await databaseProvider.getFollowingProfileListProvider(widget.uid);
  }

  @override
  void initState() {
    loadFollowFollowingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.purple,
      fontSize: 16,
    );
    final followerProfileList = listenableProvider.getFollowerProfileList(
      widget.uid,
    );
    final followingProfileList = listenableProvider.getFollowingProfileList(
      widget.uid,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Text("Followers", style: textStyle),
              Text("Following", style: textStyle),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(followerProfileList, "No Followers Yet..."),
            _buildUserList(followingProfileList, "Empty Following..."),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(List<ProfileData> userList, String errorMessage) {
    return userList.isEmpty
        ? Center(child: Text(errorMessage))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return MyProfileContainer(userProfile: user,);
            },
          );
  }
}
