import 'package:flutter/material.dart';
import 'package:social_app/helper/textstyle.dart';
import 'package:social_app/helper/theme_name.dart';

void showErrorMessage(
  BuildContext context,
  String errorMessageTitle,
  String errorMessage,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(width: 10),
          Text(errorMessageTitle, style: boldText()),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          errorMessage,
          style: TextStyle(
            color: context.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: boldText()),
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    ),
  );
}

// void showSuccessMessage(BuildContext context, String message) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: Row(
//         children: [
//           Icon(Icons.download_done_outlined, color: Colors.green, size: 50),
//           SizedBox(width: 10),
//           Text(
//             message,
//             style: TextStyle(
//               color: context.inversePrimary,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
