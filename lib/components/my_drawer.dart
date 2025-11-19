import 'package:flutter/material.dart';
import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/helper/navigation.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    String currentUserUid = AuthDatabase().currentUserId;
    var boldText = TextStyle(fontWeight: FontWeight.bold);
    return Drawer(
      width: 280,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Icon(Icons.person_outline, size: 100),
          ),
          SizedBox(height: 5),
          Divider(indent: 15, endIndent: 15, thickness: 2.5),
          ListTile(
            leading: Icon(Icons.home, size: 30),
            title: Text("H O M E", style: boldText),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.person, size: 30),
            title: Text("P R O F I L E", style: boldText),
            onTap: () => goToProfilePage(context, currentUserUid),
          ),
          ListTile(
            leading: Icon(Icons.search, size: 30),
            title: Text("S E A R C H", style: boldText),
            onTap: () => goToSearchPage(context),
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 30),
            title: Text("S E T T I N G", style: boldText),
            onTap: () => goToSettingPage(context),
          ),

          Spacer(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("L O G O U T", style: boldText),
            onTap: () {
              AuthDatabase().signOut();
              goToLoginPagePushReplace(context);
            },
          ),
        ],
      ),
    );
  }
}
