import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/services/auth_services.dart';
import 'package:kakaoo/app/ui/admin/pages/dashboard.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/petani/kodeOtp.dart';
import 'package:kakaoo/app/ui/petani/pages/home.dart';
import 'package:kakaoo/app/ui/user_login.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class LoginPetani extends StatefulWidget {
  @override
  _LoginPetaniState createState() => _LoginPetaniState();
}

class _LoginPetaniState extends State<LoginPetani> {
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
            builder: (BuildContext context) => Home(),
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
                  Text('Silahkan masuk dengan Akun Petani\nyang terdaftar')
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
                          if (!isLoading) {
                            if (_formKey.currentState!.validate()) {
                              displaySnackBar('Mohon Tunggu..');

                              final String username = _username.text.trim();
                              final String password = _password.text.trim();

                              if (username.isEmpty) {
                                print("Username is empty");
                              } else if (password.isEmpty) {
                                print("Password is empty");
                              } else {
                                QuerySnapshot snapshot = await FirebaseFirestore
                                    .instance
                                    .collection('petani')
                                    .where('nama pengguna', isEqualTo: username)
                                    .get();

                                if (snapshot.docs.isEmpty) {
                                  displaySnackBar(
                                      'Username dan Password Salah');
                                } else {
                                  context.read<AuthService>().login(
                                      snapshot.docs[0]['email'], password);

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => Home(),
                                    ),
                                    (route) => false,
                                  );
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

  getAdmin() async {
    await FirebaseFirestore.instance
        .collection('admin')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) => {
              // ignore: unnecessary_null_comparison
              if (user != null)
                {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Admin(),
                    ),
                    (route) => false,
                  )
                }
            });
  }

  getUsersPetani() async {
    await FirebaseFirestore.instance
        .collection('petani')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((user) => {
              // ignore: unnecessary_null_comparison
              if (user != null)
                {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(),
                    ),
                    (route) => false,
                  )
                }
            });
  }
}
