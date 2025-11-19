import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/auth_database.dart';
import 'package:social_app/database/database_provider.dart';
import 'package:social_app/firebase_options.dart';
import 'package:social_app/pages/homepage.dart';
import 'package:social_app/pages/login_page.dart';
import 'package:social_app/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  var box = await Hive.openBox("theme_selected");
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => MyTheme(box)),
      ChangeNotifierProvider(create: (context) => DatabaseServiceProvider(),)
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = AuthDatabase().user;
    final selectedTheme = Provider.of<MyTheme>(context);
    return MaterialApp(
      title: 'Social App',
      debugShowCheckedModeBanner: false,
      theme: selectedTheme.themeData,
      home: (user != null) ? Homepage() : LoginPage(),
    );
  }
}
