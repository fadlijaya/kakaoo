import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/tengkulak/register.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class KodeOtp extends StatefulWidget {
  const KodeOtp({Key? key}) : super(key: key);

  @override
  _KodeOtpState createState() => _KodeOtpState();
}

class _KodeOtpState extends State<KodeOtp> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _kodeOtp = TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';

  @override
  void dispose() {
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOtpScreen() : registerScreen();
  }

  Widget registerScreen() {
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
                              fontSize: 20.0,
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
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              controller: _phoneNumber,
                              decoration: InputDecoration(
                                labelText: 'Nomor HP',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukkan Nomor HP';
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 8),
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
                          //await register()

                          if (!isLoading) {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                signUp();
                                isRegister = false;
                                isOTPScreen = true;
                              });
                            }
                          }
                        },
                        color: AppColor().colorCreamy,
                        child: Center(
                          child: Text(
                            'Lanjut',
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

  Widget returnOtpScreen() {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: ListView(
          children: [
            Form(
                key: _formKeyOTP,
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
                              controller: _kodeOtp,
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
                                  if (_formKeyOTP.currentState!.validate()) {
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
                                                      _kodeOtp.text.toString()))
                                          .then((user) async => {
                                                // ignore: unnecessary_null_comparison

                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Register(
                                                              phoneNumber: _phoneNumber.text
                                                            )),
                                                    (route) => false)
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
    var phoneNumber = '+62 ' + _phoneNumber.text.toString();
    debugPrint('Gideon test 2');
    // ignore: missing_required_param
    var verifyPhoneNumber = auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        debugPrint('Gideon test 3');
        //auto code complete (not manually)
        auth
            .signInWithCredential(phoneAuthCredential)
            .then((value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Register(
                      phoneNumber: _phoneNumber.text
                    ),
                  ),
                  (route) => false,
                ));
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
