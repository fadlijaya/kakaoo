import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/petani/pages/akun/pengaturan/ubah_password.dart';
import 'package:kakaoo/app/ui/user_login.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  _PengaturanState createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  @override
  Widget build(BuildContext context) {
    final String title = "Pengaturan";

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: AppColor().colorChocolate),),
        backgroundColor: AppColor().colorCreamy,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: AppColor().colorChocolate)),
      ),
      body: Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UbahPassword())),
              child: Card(
                child: ListTile(
                  title: Text('Privasi'),
                  subtitle: Text(
                    'Ganti Kata Sandi',
                    style: TextStyle(color: Colors.black54),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => showAlertDialog(context),
              child: Card(
                  child: ListTile(
                title: Text('Log out'),
              )),
            ),
          ],
        ),
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
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => UserLogin()), (route) => false);
  }
}
