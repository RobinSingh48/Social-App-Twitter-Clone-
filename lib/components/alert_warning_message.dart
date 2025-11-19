import 'package:flutter/material.dart';

class AlertWarningMessage extends StatelessWidget {
  final String title;
  final String message;
  final void Function()? onTap;
  final String buttonName;
  const AlertWarningMessage({
    super.key,
    required this.title,
    required this.message,
    required this.onTap,
    required this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: Colors.purple)),
      content: Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
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
