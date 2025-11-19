import 'package:flutter/material.dart';

import 'package:social_app/helper/theme_name.dart';

class MyButton extends StatelessWidget {
  final String buttonName;
  final bool isLoading;
  final void Function()? onTap;
  const MyButton({
    super.key,
    required this.buttonName,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 168, 67, 207),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  buttonName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.secondary,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }
}
