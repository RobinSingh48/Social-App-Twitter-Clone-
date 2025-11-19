import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/database/database_provider.dart';
import 'package:social_app/database/model/comment.dart';

import 'package:social_app/helper/theme_name.dart';

class MyCommentContainer extends StatefulWidget {
  final Comments comment;
  final void Function()? onUserTap;
  const MyCommentContainer({
    super.key,
    required this.comment,
    required this.onUserTap,
  });

  @override
  State<MyCommentContainer> createState() => _MyCommentContainerState();
}

class _MyCommentContainerState extends State<MyCommentContainer> {
  final currentUserUid = AuthDatabase().currentUserId;
  late final databaseProvider = Provider.of<DatabaseServiceProvider>(
    context,
    listen: false,
  );
  late final listenableProvider = Provider.of<DatabaseServiceProvider>(context);

  Future<void> deleteComment() async {
    await databaseProvider.deleteCommentProvider(
      widget.comment.id,
      widget.comment.postId,
    );
  }

  void showDeleteDialog() {
    bool isMyOwnComment = widget.comment.uid == currentUserUid;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            if (isMyOwnComment)
              ListTile(
                leading: Icon(Icons.delete, size: 30, color: Colors.purple),
                title: Text(
                  "Delete",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.inversePrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  deleteComment();
                },
              )
            else ...[
              ListTile(
                leading: Icon(Icons.report, size: 30, color: Colors.purple),
                title: Text(
                  "Report",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.inversePrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  reportUser();
                },
              ),
              ListTile(
                leading: Icon(Icons.block, size: 30, color: Colors.purple),
                title: Text(
                  "Block",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.inversePrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  blockUser();
                },
              ),
            ],
            ListTile(
              leading: Icon(Icons.cancel, size: 30, color: Colors.purple),
              title: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.inversePrimary,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> blockUser() async {
    await databaseProvider.blockUserProvider(
      widget.comment.uid,
    );
  }

  Future<void> reportUser() async {
    await databaseProvider.reportUserProvider(
      widget.comment.postId,
      widget.comment.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.secondary,
        border: BoxBorder.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: context.primary,
                    radius: 16,
                    child: Icon(Icons.person, size: 28),
                  ),
                  SizedBox(width: 5),
                  //Post user text
                  GestureDetector(
                    onTap: widget.onUserTap,
                    child: Text(
                      widget.comment.user.isEmpty
                          ? "loading"
                          : "@${widget.comment.user}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                    ),
                  ),
                ],
              ),
              //Delete or Block,report button
              GestureDetector(
                onTap: showDeleteDialog,
                child: Icon(Icons.more_horiz),
              ),
            ],
          ),
          SizedBox(height: 10),
          //Post Text
          Text(
            widget.comment.message.isEmpty ? "loading" : widget.comment.message,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
