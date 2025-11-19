import 'package:flutter/material.dart';
import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/components/alert_warning_message.dart';
import 'package:social_app/helper/navigation.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  bool isLoading = false;
  void deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertWarningMessage(
        title: "Delete Account",
        message: "Are you Sure? you want to Delete account",
        onTap: () async {
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });
          await AuthDatabase().deleteUser();

          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
            this.context,
            goToDeletePageToLoginPage(this.context),
            (route) => false,
          );
        },
        buttonName: "Yes",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ACCOUNT SETTING",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      body: 
       Stack(
         children: [if (isLoading) Center(child: CircularProgressIndicator()),
          Column(
          children: [
            GestureDetector(
              onTap: () => deleteAccount(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Delete Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            
          ],
               ),
         ]
       ),
    );
  }
}
