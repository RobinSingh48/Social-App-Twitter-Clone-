import 'package:flutter/material.dart';
import 'package:social_app/helper/theme_name.dart';

class MyBioContainer extends StatefulWidget {
  final String message;
  const MyBioContainer({super.key, required this.message});

  @override
  State<MyBioContainer> createState() => _MyBioContainerState();
}

class _MyBioContainerState extends State<MyBioContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 120,
      decoration: BoxDecoration(
        color: context.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          widget.message.isEmpty ? "Empty Bio" : widget.message,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
