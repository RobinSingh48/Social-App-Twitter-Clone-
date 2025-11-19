import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/components/alert_warning_message.dart';
import 'package:social_app/components/my_alertbox.dart';
import 'package:social_app/database/database_provider.dart';
import 'package:social_app/database/model/post_model.dart';
import 'package:social_app/helper/format_time.dart';
import 'package:social_app/helper/pop_messages.dart';
import 'package:social_app/helper/theme_name.dart';

class MyPostContainer extends StatefulWidget {
  final Posts post;
  final void Function()? onUserTap;
  final void Function()? onMessageTap;
  const MyPostContainer({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onMessageTap,
  });

  @override
  State<MyPostContainer> createState() => _MyPostContainerState();
}

class _MyPostContainerState extends State<MyPostContainer> {
  final currentUserUid = AuthDatabase().currentUserId;
  late final databaseProvider = Provider.of<DatabaseServiceProvider>(
    context,
    listen: false,
  );
  late final listenableProvider = Provider.of<DatabaseServiceProvider>(context);

  final _commentController = TextEditingController();

  Future<void> toggleLikes() async {
    try {
      await databaseProvider.toggleLikesProvider(widget.post.id);
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(
        context,
        "Error",
        "Something went wrong while toggle likes",
      );
    }
  }

  Future<void> deletePost() async {
    await databaseProvider.deletePostProvider(widget.post.id);
  }

  void showDeleteDialog() {
    bool isMyOwnPost = widget.post.uid == currentUserUid;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            if (isMyOwnPost)
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
                  deletePost();
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertWarningMessage(
                      title: "Report User?",
                      message: "Are You Sure? Report this User",
                      onTap: () {
                        reportUser();
                        Navigator.pop(context);
                      },
                      buttonName: "Yes",
                    ),
                  );
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertWarningMessage(
                      title: "Blocked User",
                      message: "Are you sure? You want to block this user",
                      onTap: () {
                        blockUser();

                        Navigator.pop(context);
                      },
                      buttonName: "Yes",
                    ),
                  );
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

  Future<void> loadAllComments() async {
    try {
      await databaseProvider.loadAllCommentsProvider(widget.post.id);
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(
        context,
        "Error",
        "Something went wrong, while loading comments",
      );
    }
  }

  //add comment function
  Future<void> addComment() async {
    try {
      await databaseProvider.addCommentProvider(
        _commentController.text,
        widget.post.id,
      );
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(context, "Error", "Something went wrong,try again");
    }
  }

  //Add Comment DialogBox
  void showAddCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => MyAlertbox(
        controller: _commentController,
        hintText: "your comment",
        onTap: () {
          addComment();
          _commentController.clear();
          Navigator.pop(context);
        },
        buttonName: "save",
      ),
    );
  }

  //report User
  Future<void> reportUser() async {
    try {
      await databaseProvider.reportUserProvider(
        widget.post.id,
        widget.post.uid,
      );
      if (!mounted) return;
      showSuccessMessage(context, "Report Successfully");
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(context, "Error", "Something went wrong, try again");
    }
  }

  //BlockUser
  Future<void> blockUser() async {
    try {
      await databaseProvider.blockUserProvider(widget.post.uid);
      if (!mounted) return;
      showSuccessMessage(context, "@${widget.post.user} blocked successfully");
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(
        context,
        "Can't Block",
        "Something went wrong, try again",
      );
    }
  }

  @override
  void initState() {
    loadAllComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLikedByMe = listenableProvider.isLikedByOwn(widget.post.id);
    int likesCount = listenableProvider.getLikes(widget.post.id);
    int commentCount = listenableProvider.getComments(widget.post.id).length;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.secondary,
        border: BoxBorder.all(color: Colors.purple, width: 2),
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
                      widget.post.user.isEmpty
                          ? "loading"
                          : "@${widget.post.user}",
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
          GestureDetector(
            onTap: widget.onMessageTap,
            child: Text(
              widget.post.message.isEmpty ? "loading" : widget.post.message,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              //Like Button
              GestureDetector(
                onTap: toggleLikes,
                child: isLikedByMe
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_border_outlined),
              ),

              SizedBox(width: 5),
              //Likes Count
              Text(likesCount == 0 ? "" : likesCount.toString()),
              SizedBox(width: 5),
              //Comment Button
              GestureDetector(
                onTap: showAddCommentDialog,
                child: Icon(Icons.message),
              ),
              SizedBox(width: 5),
              //comment count text
              Text(commentCount == 0 ? "" : commentCount.toString()),
              Spacer(),
              Text(
                formatDateTime(widget.post.timestamp),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
