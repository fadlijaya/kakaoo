import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/services/auth_services.dart';
import 'package:kakaoo/app/utils/constants.dart';
import 'package:kakaoo/app/view/tengkulak/pages/akun/edit_profil.dart';
import 'package:kakaoo/app/view/tengkulak/pages/notifikasi.dart';
import 'package:kakaoo/app/view/user_login.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
var fullname;
var phoneNumber;
var username;
var email;
String? userId;

class Akun extends StatefulWidget {
  const Akun({
    Key? key,
  }) : super(key: key);
  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    await firestore
        .collection('tengkulak')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        setState(() {
          fullname = result.docs[0].data()['nama lengkap'];
          phoneNumber = result.docs[0].data()['nomor HP'];
          username = result.docs[0].data()['nama pengguna'];
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
      color: AppColor().colorChocolate,
      height: 200.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 4.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
              IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Notifikasi(username: username))), icon: Icon(Icons.notifications), color: Colors.white,)
            ],
          ),
          Center(
            child: Text(
              'Akun Saya',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          SizedBox(
            height: 4.0,
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
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0),
                  ),
                  TextButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.white,
                      ))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfil(
                                    isEdit: true,
                                    documentId: userId.toString(),
                                    fullname: fullname,
                                    username: username,
                                    phoneNumber: phoneNumber,
                                    email: email)));
                      },
                      child: Text(
                        'Edit Profil',
                        style: TextStyle(color: Colors.white),
                      ))
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
                  Icon(Icons.account_circle_sharp,
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
            onTap: () {
              showAlertDialog(context);
            },
            child: Card(
                child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    'Log out',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
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
                    signOut();
                  },
                  child: Text('Ya'))
            ],
          );
        });
  }

  Future<void> signOut() async {
    await context.read<AuthService>().signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => UserLogin()), (route) => false);
  }
}

