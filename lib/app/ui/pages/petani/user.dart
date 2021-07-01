import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/petani/login.dart';
import 'package:kakaoo/app/ui/pages/petani/register.dart';

class UserPetani extends StatefulWidget {
  @override
  _UserPetaniState createState() => _UserPetaniState();
}

class _UserPetaniState extends State<UserPetani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(paddingDefault),
              child: Stack(
                children: [
                  widgetHeader(), 
                  widgetButton()],
              ))),
    );
  }

  widgetHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColor().colorChocolate,
          ),
        ),
        SizedBox(
          height: 64.0,
        ),
        Text(
          'Selamat Datang, ',
          style: TextStyle(
              fontSize: 24.0,
              color: AppColor().colorChocolate,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 4.0,
        ),
        Text('Anda Masuk Sebagai Petani',
            style: TextStyle(
                fontSize: 20.0,
                color: AppColor().colorChocolate,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  widgetButton() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonTheme(
            minWidth: 140.0,
            height: 40.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ));
              },
              color: AppColor().colorCreamy,
              textColor: AppColor().colorChocolate,
              child: Text('Masuk'),
            ),
          ),
          ButtonTheme(
            minWidth: 140.0,
            height: 40.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              color: AppColor().colorCreamy,
              textColor: AppColor().colorChocolate,
              child: Text('Daftar'),
            ),
          )
        ],
      ),
    );
  }
}
