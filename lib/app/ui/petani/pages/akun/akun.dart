import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/petani/pages/akun/edit_profil.dart';
import 'package:kakaoo/app/ui/petani/pages/akun/pengaturan/pengaturan.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
var fullName;
var email;
var password;
var phoneNumber;

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
        .collection('petani')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        setState(() {
          fullName = result.docs[0].data()['nama lengkap'];
          email = result.docs[0].data()['email'];
          password = result.docs[0].data()['password'];
          phoneNumber = result.docs[0].data()['nomor HP'];
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
                    "$fullName",
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
                                      documentId: auth.currentUser!.uid,
                                      fullName: fullName,
                                      phoneNumber: phoneNumber,
                                      email: email,
                                      password: password,
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
                  Icon(Icons.phone_android, color: AppColor().colorChocolate),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text("$phoneNumber", style: TextStyle(color: Colors.black54))
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
                  Text(
                    "$email",
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Pengaturan())),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: AppColor().colorChocolate,
                  ),
                  title: Text('Pengaturan'),
                  subtitle: Text(
                    'Privasi dan Log out',
                    style: TextStyle(color: Colors.black54),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
