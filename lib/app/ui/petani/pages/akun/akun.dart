import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/services/auth_services.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/petani/pages/akun/edit_profil.dart';
import 'package:kakaoo/app/ui/user_login.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
var fullname;
var username;
var phoneNumber;
var email;

class Akun extends StatefulWidget {
  const Akun({
    Key? key,
  }) : super(key: key);

  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  String? userId;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    await firestore.collection('petani').where('userId', isEqualTo: auth.currentUser!.uid).get().then((result) {
      if (result.docs.length > 0) {
        setState(() {
          fullname = result.docs[0].data()['nama lengkap'];
          username = result.docs[0].data()['nama pengguna'];
          phoneNumber = result.docs[0].data()['nomor HP'];
          email = result.docs[0].data()['email'];
          userId = result.docs[0].data()['userId'];
        });
      }
    });
  }

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
      height: 180.0,
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
                    "$fullname",
                    style: TextStyle(
                        color: AppColor().colorChocolate,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0),
                  ),
                  TextButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                        style: BorderStyle.solid,
                        color: AppColor().colorChocolate,
                      ))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfil(
                                      isEdit: true,
                                      documentId: userId.toString(),
                                      fullName: fullname,
                                      username: username,
                                      phoneNumber: phoneNumber,
                                      email: email
                                    )));
                      },
                      child: Text('Edit Profil'))
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
      margin: EdgeInsets.only(top: 180.0),
      child: Column(
        children: [
          Card(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.account_circle_rounded,
                      color: AppColor().colorChocolate),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text("$username", style: TextStyle(color: Colors.black54))
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.phone_android,
                    color: AppColor().colorChocolate,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    "$phoneNumber",
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
              onTap: () => showAlertDialog(),
              child: Card(
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text('Log out',
                          style: TextStyle(
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  showAlertDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Anda yakin ingin Keluar ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    context.read<AuthService>().signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => UserLogin()),
                        (route) => false);
                  },
                  child: Text('Ya'))
            ],
          );
        });
  }
}
