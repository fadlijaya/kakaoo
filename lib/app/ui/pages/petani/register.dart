// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/petani/login.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final formKeyOTP = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<FormState>();

  TextEditingController namaLengkap = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController nomorHp = TextEditingController();
  TextEditingController kodeOtp = TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    namaLengkap.dispose();
    nomorHp.dispose();
    kodeOtp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : registerScreen();
  }

  Widget registerScreen() {
    final node = FocusScope.of(context);

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: ListView(
          children: [
            Column(
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
                      fontSize: 18.0,
                      color: AppColor().colorChocolate),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text('Lengkapi data dirimu di bawah ini, ya')
              ],
            ),
            SizedBox(
              height: 44.0,
            ),
            Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Lengkap',
                        style: TextStyle(
                            fontSize: 12.0, color: AppColor().colorChocolate),
                      ),
                      TextFormField(
                        enabled: !isLoading,
                        controller: namaLengkap,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          hintText: 'Cth: Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukkan Nama Lengkap Anda';
                          }
                        },
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 12.0, color: AppColor().colorChocolate),
                      ),
                      TextFormField(
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller: email,
                        onEditingComplete: () => node.nextFocus(),
                        decoration:
                            InputDecoration(hintText: 'Cth: name@email.com'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukkan Email Anda';
                          }
                        },
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Nomor HP',
                        style: TextStyle(
                            fontSize: 12.0, color: AppColor().colorChocolate),
                      ),
                      TextFormField(
                        enabled: !isLoading,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) => node.unfocus(),
                        controller: nomorHp,
                        decoration: InputDecoration(hintText: '123456789'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukkan Nomor HP Anda';
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isLoading) {
            if (formKey.currentState!.validate()) {
              setState(() {
                signUp();
                isRegister = false;
                isOTPScreen = true;
              });
            }
          }
        },
        backgroundColor: AppColor().colorCreamy,
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget returnOTPScreen() {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: ListView(
          children: [
            Form(
              key: formKeyOTP,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    !isLoading
                        ? "Masukkan Kode OTP dari SMS"
                        : "Mengirim Kode OTP",
                    textAlign: TextAlign.center,
                  ),
                ),
                !isLoading
                    ? Container(
                        child: TextFormField(
                          enabled: !isLoading,
                          controller: kodeOtp,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialValue: null,
                          autofocus: true,
                          decoration: InputDecoration(labelText: 'OTP'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Masukkan OTP';
                            }
                          },
                        ),
                      )
                    : Container(),
                !isLoading
                    ? Container(
                        margin: EdgeInsets.only(top: 40.0, bottom: 8),
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              if (formKeyOTP.currentState!.validate()) {
                                setState(() {
                                  isResend = false;
                                  isLoading = true;
                                });

                                try {
                                  await auth
                                      .signInWithCredential(
                                          PhoneAuthProvider.credential(
                                              verificationId: verificationCode,
                                              smsCode: kodeOtp.text.toString()))
                                      .then((user) async => {
                                            // ignore: unnecessary_null_comparison
                                            if (user != null)
                                              {
                                                await firestore
                                                    .collection('petani')
                                                    .doc(auth.currentUser!.uid)
                                                    .set(
                                                        {
                                                      'nama': namaLengkap.text
                                                          .trim(),
                                                      'email':
                                                          email.text.trim(),
                                                      'nomorHP':
                                                          nomorHp.text.trim()
                                                    },
                                                        SetOptions(
                                                            merge: true)).then(
                                                        (value) => {
                                                              setState(() {
                                                                isResend =
                                                                    false;
                                                                isLoading =
                                                                    true;
                                                              })
                                                            }),
                                                setState(() {
                                                  isLoading = false;
                                                  isResend = false;
                                                }),
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Login()),
                                                    (route) => false)
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
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Kirim',
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                              ),
                            )),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator()
                              // ignore: unnecessary_null_comparison
                            ].where((c) => c != null).toList(),
                          )
                        ],
                      ),
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
                                await signUp();
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
            ))
          ],
        ),
      )),
    );
  }

  Future signUp() async {
    setState(() {
      isLoading = true;
    });
    debugPrint('Gideon test 1');
    var phoneNumber = '+62 ' + nomorHp.text.toString();
    debugPrint('Gideon test 2');
    // ignore: missing_required_param
    var verifyPhoneNumber = auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        debugPrint('Gideon test 3');
        //auto code complete (not manually)
        auth.signInWithCredential(phoneAuthCredential).then((user) async => {
              // ignore: unnecessary_null_comparison
              if (user != null)
                {
                  //store registration details in firestore database
                  await firestore
                      .collection('petani')
                      .doc(auth.currentUser!.uid)
                      .set({
                        'nama': namaLengkap.text.trim(),
                        'email': email.text.trim(),
                        'nomorHP': nomorHp.text.trim()
                      }, SetOptions(merge: true))
                      .then((value) => {
                            //then move to authorised area
                            setState(() {
                              isLoading = false;
                              isRegister = false;
                              isOTPScreen = false;

                              //navigate to is
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Login(),
                                ),
                                (route) => false,
                              );
                            })
                          })
                      .catchError((onError) => {
                            debugPrint(
                                'Error saving user to db.' + onError.toString())
                          })
                }
            });
        debugPrint('Gideon test 4');
      },
      verificationFailed: (FirebaseAuthException error) {
        debugPrint('Gideon test 5' + error.message!);
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (verificationId, [int? forceResendingToken]) {
        debugPrint('Gideon test 6');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('Gideon test 7');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
    debugPrint('Gideon test 7');
    await verifyPhoneNumber;
    debugPrint('Gideon test 8');
  }
}
