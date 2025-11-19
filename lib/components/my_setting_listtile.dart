import 'package:flutter/material.dart';
import 'package:social_app/helper/textstyle.dart';
import 'package:social_app/helper/theme_name.dart';

class MySettingListtile extends StatelessWidget {
  final String title;
  final Widget action;
  final void Function()? onTap;
  const MySettingListtile({
    super.key,
    required this.title,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: context.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple),
      ),
      child: ListTile(
        leading: Text(title, style: settingPageTitle(context.inversePrimary)),
        trailing: action,
        onTap: onTap,
      ),
    );
  }
}
