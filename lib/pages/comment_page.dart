import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/my_comment_container.dart';
import 'package:social_app/components/my_post_container.dart';
import 'package:social_app/database/database_provider.dart';

import 'package:social_app/database/model/post_model.dart';
import 'package:social_app/helper/navigation.dart';
import 'package:social_app/helper/theme_name.dart';

class CommentPage extends StatefulWidget {
  final Posts post;
  const CommentPage({super.key, required this.post});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late final databaseProvider = Provider.of<DatabaseServiceProvider>(
    context,
    listen: false,
  );
  late final listenableProvider = Provider.of<DatabaseServiceProvider>(context);

  Future<void> loadComments() async {
    await databaseProvider.loadAllCommentsProvider(widget.post.id);
  }

  @override
  void initState() {
    loadComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final comments = listenableProvider.getComments(widget.post.id);
    return Scaffold(
      appBar: AppBar(foregroundColor: context.inversePrimary),
      body: Column(
        children: [
          MyPostContainer(
            post: widget.post,
            onUserTap: () => goToProfilePage(context, widget.post.uid),
            onMessageTap: () {},
          ),
          SizedBox(height: 10),
          Text(
            "Comments",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 10),
          comments.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: Text(
                      "No Comment",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: context.primary,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return MyCommentContainer(
                      comment: comment,
                      onUserTap:()=> goToProfilePage(context,comment.uid),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
