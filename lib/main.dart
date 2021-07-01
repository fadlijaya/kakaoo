import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/user_login.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/ui/pages/petani/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kakaoo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/home' : (context) => Home()
      },
      theme: ThemeData(
          primaryColor: AppColor().colorCreamy,
          primarySwatch: Colors.brown,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.grey),
          ),
          backgroundColor: Colors.white),
      home: MySplash(),
    );
  }
}

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      backgroundColor: AppColor().colorCreamy,
      image: Image.asset('assets/logo_png.png'),
      photoSize: 100.0,
      loaderColor: AppColor().colorCreamy,
      navigateAfterSeconds: UserLogin(),
    );
  }
}
