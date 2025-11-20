import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/my_alertbox.dart';
import 'package:social_app/components/my_drawer.dart';
import 'package:social_app/components/my_post_container.dart';
import 'package:social_app/database/database_provider.dart';
import 'package:social_app/database/model/post_model.dart';
import 'package:social_app/helper/navigation.dart';
import 'package:social_app/helper/pop_messages.dart';
import 'package:social_app/helper/textstyle.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _postController = TextEditingController();

  late final databaseProvider = Provider.of<DatabaseServiceProvider>(
    context,
    listen: false,
  );
  late final listenableProvider = Provider.of<DatabaseServiceProvider>(context);

  //load all posts
  Future<void> loadPosts() async {
    try {
      await databaseProvider.loadAllPostsProvider();
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(
        context,
        "Error",
        "Something wrong, while loading posts",
      );
    }
  }

  //add post
  Future<void> addPosts() async {
    final post = _postController.text.trim();
    try {
      if (post.isNotEmpty) {
        await databaseProvider.addPostProvider(post);
      }
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(context, "Error", "Something wrong, Try again");
    }
  }

  void addPost() {
    showDialog(
      context: context,
      builder: (context) => MyAlertbox(
        controller: _postController,
        hintText: "",
        onTap: () {
          addPosts();

          _postController.clear();
          Navigator.pop(context);
        },
        buttonName: "Save",
      ),
    );
  }

  @override
  void initState() {
    loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("H O M E", style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            labelColor: Colors.purple,
            tabs: [
              Text("For You", style: boldText()),
              Text("Following", style: boldText()),
            ],
          ),
        ),

        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => addPost(),
          child: Icon(Icons.add, color: Colors.white),
        ),
        body: Consumer<DatabaseServiceProvider>(
          builder: (context, provider, _) {
            return TabBarView(
              children: [
                _buildPostContainer(provider.allPosts),
                _buildPostContainer(provider.showingFollowingPosts),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostContainer(List<Posts> posts) {
    return posts.isEmpty
        ? Center(
            child: Text(
              "No Posts Yet",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return MyPostContainer(
                post: post,
                onUserTap: () => goToProfilePage(context, post.uid),
                onMessageTap: () => goToCommentPage(context, post),
              );
            },
          );
  }
}
