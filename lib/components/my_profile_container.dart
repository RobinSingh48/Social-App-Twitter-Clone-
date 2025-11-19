import 'package:flutter/material.dart';
import 'package:social_app/database/model/user_profile.dart';
import 'package:social_app/helper/navigation.dart';
import 'package:social_app/helper/theme_name.dart';

class MyProfileContainer extends StatelessWidget {
  final ProfileData userProfile;
  const MyProfileContainer({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    var userStyle = TextStyle(
      color: context.primary,
      fontWeight: FontWeight.bold,
    );
    var usernameStyle = TextStyle(
      color: context.inversePrimary,
      fontWeight: FontWeight.bold,
    );
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: context.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple),
      ),
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text("@${userProfile.user}", style: userStyle),
        subtitle: Text(userProfile.username, style: usernameStyle),
        trailing: Icon(Icons.arrow_forward),
        onTap: () => goToProfilePage(context, userProfile.uid),
      ),
    );
  }
}
