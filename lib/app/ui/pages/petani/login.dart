// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/petani/home/home.dart';
import 'package:kakaoo/app/ui/pages/petani/user.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final formKeyOTP = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nomorHp = TextEditingController();
  TextEditingController kodeOtp = TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';

  @override
  void initState() {
    if (auth.currentUser != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
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
  void dispose() {
    nomorHp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : returnLoginScreen();
  }

  Widget returnLoginScreen() {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => UserPetani()));
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
                  style: TextStyle(
                      fontSize: 18.0,
                      color: AppColor().colorChocolate,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'Silahkan masuk dengan nomor HP-mu\nyang terdaftar',
                  style: TextStyle(color: AppColor().colorChocolate),
                )
              ],
            ),
            SizedBox(
              height: 44.0,
            ),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nomor HP',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColor().colorChocolate,
                      )),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    enabled: !isLoading,
                    controller: nomorHp,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: '123456789'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Masukkan Nomor HP';
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (!isLoading) {
              if (formKey.currentState!.validate()) {
                displaySnackBar('Mohon Tunggu...');
                await login();
              }
            }
          },
          backgroundColor: AppColor().colorCreamy,
          child: !isLoading
              ? Icon(Icons.arrow_forward, color: Colors.white)
              : CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )),
    );
  }

  Widget returnOTPScreen() {
    return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: ListView(children: [
            Form(
              key: formKeyOTP,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: Text(
                              !isLoading
                                  ? "Masukkan Kode OTP dari SMS"
                                  : "Mengirim Kode OTP ",
                              textAlign: TextAlign.center))),
                  !isLoading
                      ? Container(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: TextFormField(
                            enabled: !isLoading,
                            controller: kodeOtp,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            initialValue: null,
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: 'OTP',
                                labelStyle: TextStyle(color: Colors.black)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Mohon Masukkan Kode OTP';
                              }
                            },
                          ),
                        ))
                      : Container(),
                  !isLoading
                      ? Container(
                          margin: EdgeInsets.only(top: 40, bottom: 5),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: new ElevatedButton(
                                onPressed: () async {
                                  if (formKeyOTP.currentState!.validate()) {
                                    // If the form is valid, we want to show a loading Snackbar
                                    // If the form is valid, we want to do firebase signup...
                                    setState(() {
                                      isResend = false;
                                      isLoading = true;
                                    });
                                    try {
                                      await auth
                                          .signInWithCredential(
                                              PhoneAuthProvider.credential(
                                                  verificationId:
                                                      verificationCode,
                                                  smsCode:
                                                      kodeOtp.text.toString()))
                                          .then((user) async => {
                                                //sign in was success
                                                // ignore: unnecessary_null_comparison
                                                if (user != null)
                                                  {
                                                    //store registration details in firestore database
                                                    setState(() {
                                                      isLoading = false;
                                                      isResend = false;
                                                    }),
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Home(),
                                                      ),
                                                      (route) => false,
                                                    )
                                                  }
                                              })
                                          // ignore: invalid_return_type_for_catch_error
                                          .catchError((error) => {
                                                setState(() {
                                                  isLoading = false;
                                                  isResend = true;
                                                }),
                                              });
                                      setState(() {
                                        isLoading = true;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                                child: new Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 15.0,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Text(
                                          "Kirim",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator()
                                  // ignore: unnecessary_null_comparison
                                ].where((c) => c != null).toList(),
                              )
                            ]),
                  isResend
                      ? Container(
                          margin: EdgeInsets.only(top: 40, bottom: 5),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: new ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isResend = false;
                                    isLoading = true;
                                  });
                                  await login();
                                },
                                child: new Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 15.0,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Text(
                                          "Kirim ulang Kode",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )))
                      : Column()
                ],
              ),
            )
          ]),
        ));
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    // ignore: deprecated_member_use
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  Future login() async {
    setState(() {
      isLoading = true;
    });

    var phoneNumber = '+62 ' + nomorHp.text.trim();

    //first we will check if a user with this cell number exists
    var isValidUser = false;
    var number = nomorHp.text.trim();

    await firestore
        .collection('petani')
        .where('nomorHP', isEqualTo: number)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        isValidUser = true;
      }
    });

    if (isValidUser) {
      //ok, we have a valid user, now lets do otp verification
      var verifyPhoneNumber = auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          //auto code complete (not manually)
          auth.signInWithCredential(phoneAuthCredential).then((user) async => {
                // ignore: unnecessary_null_comparison
                if (user != null)
                  {
                    //redirect
                    setState(() {
                      isLoading = false;
                      isOTPScreen = false;
                    }),
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Home(),
                      ),
                      (route) => false,
                    )
                  }
              });
        },
        verificationFailed: (FirebaseAuthException error) {
          displaySnackBar('Kesalahan validasi, coba lagi nanti');
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (verificationId, [int? forceResendingToken]) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
            isOTPScreen = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 60),
      );
      await verifyPhoneNumber;
    } else {
      //non valid user
      setState(() {
        isLoading = false;
      });
      displaySnackBar('Nomor tidak ditemukan, silakan daftar dulu');
    }
  }
}
