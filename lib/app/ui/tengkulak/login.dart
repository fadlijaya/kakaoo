import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/services/auth_services.dart';
import 'package:kakaoo/app/ui/admin/pages/dashboard.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/tengkulak/kodeOtp.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/home.dart';
import 'package:kakaoo/app/ui/user_login.dart';
import 'package:provider/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class LoginTengkulak extends StatefulWidget {
  @override
  _LoginTengkulakState createState() => _LoginTengkulakState();
}

class _LoginTengkulakState extends State<LoginTengkulak> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _username = TextEditingController();
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
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text('Silahkan masuk dengan Akun Pengepul\nyang terdaftar')
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
                      controller: _username,
                      decoration: InputDecoration(hintText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username Tidak Boleh Kosong !';
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
                          final String username = _username.text.trim();
                          final String email = '$username@gmail.com';
                          final String password = _password.text.trim();

                          if (!isLoading) {
                            if (_formKey.currentState!.validate()) {
                              displaySnackBar('Mohon Tunggu..');

                              if (username.isEmpty) {
                                print("Username is empty");
                              } else if (password.isEmpty) {
                                print("Password is empty");
                              } else {
                                if (username == 'muhtakdir' &&
                                    password == '1234567') {
                                  QuerySnapshot snapshot =
                                      await FirebaseFirestore.instance
                                          .collection('admin')
                                          .where('nama pengguna',
                                              isEqualTo: username)
                                          .get();

                                  context.read<AuthService>().login(
                                      email: snapshot.docs[0]['email'],
                                      password: password);

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Admin(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  try {
                                    UserCredential user =
                                        await auth.signInWithEmailAndPassword(
                                            email: email, password: password);

                                    // ignore: unnecessary_null_comparison
                                    if (user != null) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeTengkulak()),
                                          (route) => false);
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      print('No user found for that email.');
                                    } else if (e.code == 'wrong-password') {
                                      print(
                                          'Wrong password provided for that user.');
                                    }
                                  }
                                }
                              }
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
}
