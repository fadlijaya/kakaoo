import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
var fullname;
var username;
var phoneNumber;

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  Future getUser() async {
    if (auth.currentUser != null) {
      await firestore
          .collection('admin')
          .where('userId', isEqualTo: auth.currentUser!.uid)
          .get()
          .then((result) {
        if (result.docs.length > 0) {
          setState(() {
            fullname = result.docs[0].data()['nama lengkap'];
            username = result.docs[0].data()['nama pengguna'];
            phoneNumber = result.docs[0].data()['nomor HP'];
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    final String title = "Profil";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColor().colorCreamy,
      ),
      body: Container(
          child: Stack(
        children: [header(), profil()],
      )),
    );
  }

  header() {
    return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColor().colorCreamy,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_rounded,
              size: 60,
              color: Colors.white,
            ),
            SizedBox(
              height: 8,
            ),
            Text("$fullname",  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),)
          ],
        ));
  }

  profil() {
    return Container(
      margin: EdgeInsets.only(top: 120),
      child: ListView(
        children: [
          Card(
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(
                  vertical: paddingDefault / 2, horizontal: paddingDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text("$username",  style: TextStyle(fontWeight: FontWeight.w500),)
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(
                  vertical: paddingDefault / 2, horizontal: paddingDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nomor HP",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text("$phoneNumber",  style: TextStyle(fontWeight: FontWeight.w500),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
