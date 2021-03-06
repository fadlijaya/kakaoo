import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/utils/constants.dart';
import 'package:kakaoo/app/view/petani/pages/login.dart';
import 'package:kakaoo/app/view/petani/pages/beranda/home.dart';
import 'package:kakaoo/app/view/tengkulak/pages/login.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: AppColor().colorCreamy,
          child: Column(
            children: [
              Container(
                height: 360.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      semanticLabel: 'logo',
                      width: 100.0,
                    ),
                    Text(
                      'Kakaoo',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 60.0, bottom: 60.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0))),
                  child: Column(
                    children: [
                      Text(
                        TitleText().titleUserLogin,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        TitleText().descUserLogin,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      ButtonTheme(
                        minWidth: 256.0,
                        height: 40.0,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          color: AppColor().colorChocolate,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginTengkulak(),
                                ));
                          },
                          child: Text(
                            'Masuk sebagai Pengepul',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      ButtonTheme(
                        minWidth: 256.0,
                        height: 40.0,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          color: AppColor().colorCreamy,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Authenticate()));
                          },
                          child: Text(
                            'Masuk sebagai Petani',
                            style: TextStyle(color: AppColor().colorChocolate),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class Authenticate extends StatelessWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (user != null) {
      return Home();
    }

    return LoginPetani();
  }
}
