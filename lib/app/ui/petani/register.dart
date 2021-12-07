import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakaoo/app/services/auth_services.dart';
import 'package:kakaoo/app/ui/constants.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class Register extends StatefulWidget {
  final String phoneNumber;

  const Register({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final String title = 'Petani';

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _userName = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.infinity,
        child: SafeArea(
            child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 60.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(paddingDefault),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColor().colorChocolate,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            height: 44.0,
                          ),
                          Text(
                            'Daftar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text('Lengkapi data dirimu di bawah ini, ya'),
                          SizedBox(
                            height: 44.0,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingDefault),
                            child: TextFormField(
                              controller: _userName,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration:
                                  InputDecoration(labelText: 'Nama Lengkap'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukkan Nama Lengkap';
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingDefault),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _username,
                              onEditingComplete: () => node.nextFocus(),
                              decoration:
                                  InputDecoration(labelText: 'Username'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukkan Username';
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingDefault),
                            child: TextFormField(
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              controller: _password,
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukkan Password';
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: paddingDefault),
                            child: Text(
                              'Minimal 7 Karakter',
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingDefault),
                            child: TextFormField(
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) => node.unfocus(),
                              controller: _confirmPassword,
                              decoration: InputDecoration(
                                  labelText: 'Konfirmasi Password'),
                              validator: (value) {
                                if (value!.isEmpty || value != _password.text) {
                                  return 'Konfirmasi Password';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: paddingDefault,
                left: paddingDefault,
                right: paddingDefault,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 48.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () async {
                          final String fullname = _userName.text.trim();
                          final String username = _username.text.trim();
                          final String email = '$username@gmail.com';
                          final String password = _password.text.trim();
                          final String phoneNumber = widget.phoneNumber;
                          try {
                            if (email.isEmpty) {
                              print('Email is empty');
                            } else if (password.isEmpty) {
                              print('Password is empty');
                            } else {
                              context
                                  .read<AuthService>()
                                  .signUp(email: email, password: password)
                                  .then((value) async {
                                User? user = FirebaseAuth.instance.currentUser;

                                await firestore
                                    .collection('petani')
                                    .doc(user!.uid)
                                    .set({
                                  'userId': user.uid,
                                  'nama lengkap': fullname,
                                  'nama pengguna': username,
                                  'email': email,
                                  'password': password,
                                  'nomor HP': phoneNumber,
                                  'jenis pengguna': title,
                                });

                                await firestore
                                    .collection('users')
                                    .doc(user.uid)
                                    .set({
                                  'userId': user.uid,
                                  'nama lengkap': fullname,
                                  'nama pengguna': username,
                                  'email': email,
                                  'password': password,
                                  'nomor HP': phoneNumber,
                                  'jenis pengguna': title,
                                });

                                successDialog();
                              });
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'week-password') {
                              print('The password provided is too week');
                            } else if (e.code == 'email-already-in-use') {
                              displaySnackbar();
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        color: AppColor().colorCreamy,
                        child: Center(
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                                color: AppColor().colorChocolate,
                                fontSize: 16.0),
                          ),
                        ),
                      )),
                ))
          ],
        )),
      ),
    );
  }

  displaySnackbar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Akun sudah terdaftar!")));
  }

  successDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColor().colorChocolate,
                  size: 60,
                ),
                SizedBox(
                  height: 8,
                ),
                Center(child: Text('Berhasil')),
              ],
            ),
            actions: [
              Center(
                  child: TextButton(
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, '/loginPetani'),
                      child: Text('OK')))
            ],
          );
        });
  }
}
