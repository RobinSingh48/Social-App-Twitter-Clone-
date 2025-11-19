import 'package:flutter/material.dart';
import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/helper/navigation.dart';
import 'package:social_app/helper/pop_messages.dart';
import 'package:social_app/helper/textstyle.dart';
import 'package:social_app/helper/theme_name.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isObscure = true;

  bool isLoading = false;

  @override
  void initState() {
    _passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorMessage(context, "Empty Field", "Please fill all details");
      return;
    } else {
      try {
        await AuthDatabase().loginUserInFirebase(email, password);
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        goToHomePushReplace(context);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        showErrorMessage(
          context,
          "Error",
          "Something went wrong,Please try again",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome", style: loginPageTextBold(Colors.black)),
                  Text(" LoginHere", style: loginPageTextBold(Colors.purple)),
                ],
              ),
              MyTextfield(
                obscureText: false,
                controller: _emailController,
                hintText: "email",
                prefixIcon: Icon(
                  Icons.email_outlined,
                  size: 25,
                  color: context.inversePrimary,
                ),
              ),
              SizedBox(height: 10),
              MyTextfield(
                obscureText: isObscure,
                controller: _passwordController,
                hintText: "password",
                prefixIcon: Icon(Icons.password),
                suffixIcon: _passwordController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon: isObscure
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      )
                    : null,
              ),
              SizedBox(height: 20),
              MyButton(
                isLoading: isLoading,
                buttonName: "Login",
                onTap: () {
                  loginUser();
                },
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account? ",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () => goToRegisterPage(context),
                    child: Text(
                      "RegisterHere",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
