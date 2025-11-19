import 'package:flutter/material.dart';
import 'package:social_app/helper/theme_name.dart';

class MyAlertbox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function()? onTap;
  final String buttonName;
  const MyAlertbox({
    super.key,

    required this.controller,
    required this.hintText,
    required this.onTap,
    required this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: controller,
        maxLength: 140,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.primary,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.purple, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.secondary, width: 3),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            buttonName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
        ),
      ],
    );
  }
}
