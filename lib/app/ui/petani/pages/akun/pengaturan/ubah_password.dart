import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class UbahPassword extends StatefulWidget {
  const UbahPassword({Key? key}) : super(key: key);

  @override
  _UbahPasswordState createState() => _UbahPasswordState();
}

class _UbahPasswordState extends State<UbahPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _password = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmNewpassword = TextEditingController();

  bool _isHidePassword = true;
  bool isLoading = false;

  void togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = "Ganti Kata Sandi";

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: AppColor().colorChocolate),),
        backgroundColor: AppColor().colorCreamy,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: AppColor().colorChocolate)),
      ),
      body: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: Stack(
          children: [formPassword(), buttonSave()],
        ),
      ),
    );
  }

  formPassword() {
    final node = FocusScope.of(context);
    return Container(
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Silahkan masukkan kata sandi baru Anda'),
              SizedBox(
                height: 12.0,
              ),
              TextFormField(
                obscureText: _isHidePassword,
                controller: _password,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                decoration: InputDecoration(
                    labelText: 'Kata sandi saat ini',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        togglePasswordVisibility();
                      },
                      child: Icon(
                          _isHidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: _isHidePassword
                              ? Colors.grey
                              : AppColor().colorChocolate),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan Kata sandi saat ini';
                  }
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                obscureText: _isHidePassword,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                controller: _newPassword,
                decoration: InputDecoration(
                    labelText: 'Kata sandi baru',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        togglePasswordVisibility();
                      },
                      child: Icon(
                          _isHidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: _isHidePassword
                              ? Colors.grey
                              : AppColor().colorChocolate),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan Kata sandi baru';
                  }
                },
              ),
              TextFormField(
                obscureText: _isHidePassword,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) => node.unfocus(),
                controller: _confirmNewpassword,
                decoration: InputDecoration(
                    labelText: 'Konfirmasi kata sandi baru',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        togglePasswordVisibility();
                      },
                      child: Icon(
                          _isHidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: _isHidePassword
                              ? Colors.grey
                              : AppColor().colorChocolate),
                    )),
                validator: (value) {
                  if (value!.isEmpty || value != _newPassword.text) {
                    return 'Konfirmasi kata sandi baru';
                  }
                },
              ),
            ],
          )),
    );
  }

  buttonSave() {
    return Container(
      child: Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppColor().colorCreamy),
            child: TextButton(
                onPressed: (){},
                child: Text(
                  "Simpan",
                  style: TextStyle(color: AppColor().colorChocolate, fontWeight: FontWeight.w500, fontSize: 16.0),
                )),
          )),
    );
  }

  /*changePassword() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String password = _password.text;
    String newPassword = _newPassword.text;

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      user!.updatePassword(newPassword).then((_) {
        print("Successfully changed password");
        Navigator.pop(context);
      }).catchError((error) {
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }*/
}
