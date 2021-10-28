import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';

class LihatProfil extends StatefulWidget {
  final String userName;
  final String location;
  final String phoneNumber;

  const LihatProfil({
    Key? key,
    required this.userName,
    required this.location,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _LihatProfilState createState() => _LihatProfilState();
}

class _LihatProfilState extends State<LihatProfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [_widgetHeader(), _widgetBody()],
        ),
      ),
    );
  }

  Widget _widgetHeader() {
    return Container(
      padding: EdgeInsets.all(paddingDefault),
      color: AppColor().colorCreamy,
      height: 200.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle_rounded,
                  size: 90.0, color: Colors.white),
              SizedBox(
                width: 40.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: TextStyle(
                        color: AppColor().colorChocolate,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _widgetBody() {
    return Container(
      margin: EdgeInsets.only(top: 200.0),
      child: Column(
        children: [
          Card(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: AppColor().colorChocolate),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.location,
                            style: TextStyle(color: Colors.black54))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.phone_android, color: AppColor().colorChocolate),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(widget.phoneNumber,
                      style: TextStyle(color: Colors.black54))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
