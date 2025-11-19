import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/database/database_provider.dart';
import 'package:social_app/helper/navigation.dart';
import 'package:social_app/helper/pop_messages.dart';
import 'package:social_app/helper/textstyle.dart';
import 'package:social_app/helper/theme_name.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool isObscure1 = true;
  bool isObscure2 = true;

  bool isLoading = false;

  late final databaseProvider = Provider.of<DatabaseServiceProvider>(
    context,
    listen: false,
  );

  @override
  void initState() {
    _passwordController.addListener(() {
      setState(() {});
    });
    _confirmPassController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPassController.text.trim();

    final emailReg = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showErrorMessage(context, "empty field", "fill all fields carefully");
      return;
    }
    if (!emailReg.hasMatch(email)) {
      showErrorMessage(context, "Not valid", "Please Enter a valid email");
      return;
    }
    if (password != confirmPassword) {
      showErrorMessage(
        context,
        "Error",
        "Password and confirmPassword are not matched",
      );
      return;
    }
    try {
      await AuthDatabase().registerUserInFirebase(email, password);
      await databaseProvider.addUserProfileProvider(email, username);
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      goToLoginPage(context);
      showSuccessMessage(context, "User Registered Successfully,Login now");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      showErrorMessage(
        context,
        "Error",
        "Something wrong user not registered,Please try again",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.note_alt_rounded, size: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Register", style: loginPageTextBold(Colors.black)),
                    Text(" Here", style: loginPageTextBold(Colors.purple)),
                  ],
                ),
                MyTextfield(
                  obscureText: false,
                  controller: _usernameController,
                  hintText: "username",
                  prefixIcon: Icon(
                    Icons.person,
                    size: 25,
                    color: context.inversePrimary,
                  ),
                ),
                SizedBox(height: 10),
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
                  obscureText: isObscure1,
                  controller: _passwordController,
                  hintText: "password",
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: _passwordController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure1 = !isObscure1;
                            });
                          },
                          icon: isObscure1
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        )
                      : null,
                ),
                SizedBox(height: 10),
                MyTextfield(
                  obscureText: isObscure2,
                  controller: _confirmPassController,
                  hintText: "confirm password",
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: _confirmPassController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure2 = !isObscure2;
                            });
                          },
                          icon: isObscure2
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        )
                      : null,
                ),
                SizedBox(height: 20),
                //Register Button
                MyButton(
                  isLoading: isLoading,
                  buttonName: "Register",
                  onTap: () {
                    registerUser();
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    // Login Text Button
                    GestureDetector(
                      onTap: () => goToLoginPage(context),
                      child: Text(
                        "LoginHere",
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
      ),
    );
  }
}
