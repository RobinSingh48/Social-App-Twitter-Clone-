import 'package:flutter/material.dart';
import 'package:social_app/helper/theme_name.dart';

class MyFollowButton extends StatelessWidget {
  final bool isFollowing;
  final void Function()? onTap;
  const MyFollowButton({
    super.key,
    required this.isFollowing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isFollowing ? context.primary : Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            isFollowing ? "UnFollow" : "Follow",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
