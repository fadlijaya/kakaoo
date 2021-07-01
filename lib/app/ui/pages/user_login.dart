import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/petani/user.dart';
import 'package:kakaoo/app/ui/pages/tengkulak/user.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: AppColor().colorCreamy,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 360.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24.0),
                      topLeft: Radius.circular(24.0))),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 120.0),
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/logo_png.png',
              semanticLabel: 'logo kakaoo',
              width: 100.0,
            )),
        Positioned(
          bottom: 60.0,
          left: 40.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(paddingDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TitleText().titleUserLogin, 
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppColor().colorChocolate),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      TitleText().descUserLogin,
                      style: TextStyle(color: AppColor().colorChocolate),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 36.0,
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
                    Navigator.push( context, MaterialPageRoute( builder: (context) => UserTengkulak(), )); },
                  child: Text(
                    'Masuk sebagai Tengkulak',
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
                   Navigator.push( context, MaterialPageRoute( builder: (context) => UserPetani(), )); },
                  child: Text(
                    'Masuk sebagai Petani',
                    style: TextStyle(color: AppColor().colorChocolate),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
