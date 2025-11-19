import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/my_setting_listtile.dart';
import 'package:social_app/helper/navigation.dart';
import 'package:social_app/helper/textstyle.dart';
import 'package:social_app/helper/theme_name.dart';
import 'package:social_app/theme/theme_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final listenableProvider = Provider.of<MyTheme>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: context.primary,
        centerTitle: true,
        title: Text("S E T T I N G", style: boldText()),
      ),
      body: Column(
        children: [
          MySettingListtile(
            title: "Dark Mode",
            action: CupertinoSwitch(
              value: listenableProvider.isDark,
              onChanged: (value) => listenableProvider.toggleTheme(),
            ),
            onTap: () {},
          ),
          MySettingListtile(
            title: "Blocked Users",
            action: Icon(Icons.keyboard_double_arrow_right_sharp),
            onTap: () => goToBlockedUserPage(context),
          ),
          MySettingListtile(
            title: "Account Setting",
            action: Icon(Icons.keyboard_double_arrow_right_sharp),
            onTap: () => goToAccountSettingPage(context),
          ),
        ],
      ),
    );
  }
}
