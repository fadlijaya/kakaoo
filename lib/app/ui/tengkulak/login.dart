import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/tengkulak/kodeOtp.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/home.dart';
import 'package:kakaoo/app/ui/user_login.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
var username;
var password;

class LoginTengkulak extends StatefulWidget {
  @override
  _LoginTengkulakState createState() => _LoginTengkulakState();
}

class _LoginTengkulakState extends State<LoginTengkulak> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  var isLoading = false;
  var isValidUser = false;
  bool _isHidePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  void initState() {
    if (auth.currentUser != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeTengkulak(),
          ),
          (route) => false,
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => UserLogin()));
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColor().colorChocolate,
                    ),
                  ),
                  SizedBox(
                    height: 44.0,
                  ),
                  Text(
                    'Masuk',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text('Silahkan masuk dengan Akun Tengkulak\nyang terdaftar')
                ],
              ),
              SizedBox(
                height: 44.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(hintText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email Tidak Boleh Kosong !';
                        } else if (!value.contains('@')) {
                          return 'Email Salah';
                        }
                      },
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _togglePasswordVisibility();
                              },
                              child: Icon(
                                  _isHidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _isHidePassword
                                      ? Colors.grey
                                      : AppColor().colorChocolate),
                            )),
                        obscureText: _isHidePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password Tidak Boleh Kosong !';
                          } else if (value.length < 7) {
                            return 'Minimal Password 7 Digit !';
                          }
                        }),
                    SizedBox(
                      height: 32.0,
                    ),
                    ButtonTheme(
                      minWidth: 320.0,
                      height: 48.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () async {
                          if (!isLoading) {
                            if (_formKey.currentState!.validate()) {
                              displaySnackBar('Mohon Tunggu..');
                              await login();
                            }
                          }
                        },
                        color: AppColor().colorCreamy,
                        child: Container(
                          margin: EdgeInsets.only(left: 24, right: 24),
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                                color: AppColor().colorChocolate,
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Belum Punya Akun ? Silahkan'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KodeOtp()));
                          },
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future login() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);

      // ignore: unnecessary_null_comparison
      if (userCredential != null) {
        await firestore
            .collection('tengkulak')
            .where('userId', isEqualTo: auth.currentUser!.uid)
            .get()
            .then((result) {
          // ignore: unnecessary_null_comparison
          if (result != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomeTengkulak(),
              ),
              (route) => false,
            );
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        displaySnackBar('Email Tidak Ditemukan, Silahkan Daftar!');
      } else if (e.code == "week-password") {
        displaySnackBar('Email atau Password Salah!');
      }
    } catch (e) {
      print(e);
    }
  }
}
