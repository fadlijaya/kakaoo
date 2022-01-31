import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/services/auth_services.dart';
import 'package:kakaoo/app/view/admin/pages/dashboard.dart';
import 'package:kakaoo/app/view/admin/pages/orders.dart';
import 'package:kakaoo/app/utils/constants.dart';
import 'package:kakaoo/app/view/petani/pages/login.dart';
import 'package:kakaoo/app/view/tengkulak/pages/login.dart';
import 'package:kakaoo/app/view/user_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
        bodyColor: AppColor().colorChocolate,
        displayColor: AppColor().colorChocolate);
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: [])
      ],
      child: MaterialApp(
        title: 'Kakaoo',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/loginPetani': (_) => LoginPetani(),
          '/dashboard': (_) => Admin(),
          '/orders': (_) => Orders(),
          '/loginTengkulak': (_) => LoginTengkulak(),
        },
        theme: ThemeData(
            textTheme: newTextTheme,
            primaryColor: AppColor().colorCreamy,
            primarySwatch: Colors.brown,
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.grey),
            ),
            backgroundColor: Colors.white),
        home: MySplash()
      ),
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
    return SplashScreenView(
        imageSrc: 'assets/logo.png',
        imageSize: 160,
        text: 'Kakaoo',
        textStyle: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        backgroundColor: AppColor().colorCreamy,
        duration: 3000,
        navigateRoute: UserLogin());
  }
}
