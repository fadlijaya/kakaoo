// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/user_login.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
var userName = '';
var email = '';

class Akun extends StatefulWidget {
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
    if (auth.currentUser != null) {
      var cellNumber = auth.currentUser?.phoneNumber;
      cellNumber =
          '0' + auth.currentUser!.phoneNumber!.substring(3, cellNumber!.length);
      debugPrint(cellNumber);
      await firestore
          .collection('petani')
          .where('nomorHP', isEqualTo: cellNumber)
          .get()
          .then((result) {
        if (result.docs.length > 0) {
          setState(() {
            userName = result.docs[0].data()['nama'];
            email = result.docs[0].data()['email'];
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          widgetHeader(),
          widgetBody(),
        ],
      )),
    );
  }

  widgetHeader() {
    return Container(
      padding: EdgeInsets.all(paddingDefault),
      color: AppColor().colorCreamy,
      height: 200.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.0,),
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
                    userName,
                    style: TextStyle(
                        color: AppColor().colorChocolate,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  widgetBody() {
    return Container(
      margin: EdgeInsets.only(top: 200.0),
      child: Column(
        children: [
          Card(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.phone, color: AppColor().colorChocolate),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text((auth.currentUser!.phoneNumber != null)
                      ? auth.currentUser!.phoneNumber!
                      : 'No. Telepon', style: TextStyle(color: Colors.black54),)
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
                    Icons.email,
                    color: AppColor().colorChocolate,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(email, style: TextStyle(color: Colors.black54),)
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
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: AppColor().colorChocolate,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text('Keluar')
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
                  child: Text('Batal')),
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
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => UserLogin()), (route) => false);
  }
}
