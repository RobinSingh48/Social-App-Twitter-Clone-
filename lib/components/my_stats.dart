import 'package:flutter/material.dart';
import 'package:social_app/helper/theme_name.dart';

class MyStats extends StatelessWidget {
  final int postNumber;
  final int followerCount;
  final int followeringCount;
  const MyStats({
    super.key,
    required this.postNumber,
    required this.followerCount,
    required this.followeringCount,
  });

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.purple,
    );
    var numberTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: context.inversePrimary,
      fontSize: 16,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text("POSTS", style: textStyle),
              Text(postNumber.toString(), style: numberTextStyle),
            ],
          ),
        ),

        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text("FOLLOWER", style: textStyle),
              Text(followerCount.toString(), style: numberTextStyle),
            ],
          ),
        ),

        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text("FOLLOWING", style: textStyle),
              Text(followeringCount.toString(), style: numberTextStyle),
            ],
          ),
        ),
      ],
    );
  }
}
