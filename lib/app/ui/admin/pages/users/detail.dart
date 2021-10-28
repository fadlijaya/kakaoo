import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';

class DetailUsers extends StatefulWidget {
  final String typeUser;
  final String userName;
  final String email;
  final String phoneNumber;
  final String address;
  final String password;

  const DetailUsers(
      {Key? key,
      required this.typeUser,
      required this.userName,
      required this.email,
      required this.phoneNumber,
      required this.address,
      required this.password})
      : super(key: key);

  @override
  _DetailUsersState createState() => _DetailUsersState();
}

class _DetailUsersState extends State<DetailUsers> {
  final String title = 'Detail Users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: Column(
          children: [
            Text(widget.typeUser, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),),
            SizedBox(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nama Lengkap',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(widget.userName)
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(widget.email)
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'No. HP',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(widget.phoneNumber)
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alamat',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(widget.address)
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kata Sandi',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(widget.password)
              ],
            )
          ],
        ),
      ),
    );
  }
}
