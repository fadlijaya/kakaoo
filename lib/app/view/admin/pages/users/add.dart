import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/utils/constants.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  String title = 'Add Users';
  bool isLoading = false;
  var _selectedTypeUsers;
  List<String> typeUsers = ['Petani', 'Tengkulak'];

  final _formKey = GlobalKey<FormState>();

  TextEditingController _userName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: formUsers(),
    );
  }

  formUsers() {
    final node = FocusScope.of(context);

    return Container(
      padding: EdgeInsets.all(paddingDefault),
      child: Stack(
        children: [
          Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    hint: Text('Jenis User'),
                    isExpanded: true,
                    items: typeUsers
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    value: _selectedTypeUsers,
                    onChanged: (selected) {
                      setState(() {
                        _selectedTypeUsers = selected;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _userName,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Masukkan Nama Lengkap';
                      }
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Masukkan Email';
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    controller: _phoneNumber,
                    decoration: InputDecoration(labelText: 'Nomor HP'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Masukkan Nomor HP';
                      }
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    controller: _address,
                    decoration: InputDecoration(labelText: 'Alamat'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Masukkan Alamat';
                      }
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => node.nextFocus(),
                    controller: _password,
                    decoration: InputDecoration(labelText: 'Kata Sandi'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Masukkan Kata Sandi';
                      }
                    },
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    'Minimal 7 Karakter',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          addUsersButton()
        ],
      ),
    );
  }

  addUsersButton() {
    return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: Container(
          width: double.infinity,
          height: 48.0,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              color: AppColor().colorCreamy,
              borderRadius: BorderRadius.circular(8.0)),
          child: TextButton(
              onPressed: () async => {
                if (_formKey.currentState!.validate()) {
                  await addUsers()
                }
              },
              child: Text(
                'Tambah Users',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              )),
        ));
  }

  Future addUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      await auth
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .then((users) async => {
                // ignore: unnecessary_null_comparison
                if (users != null)
                  {
                    firestore
                        .collection('users')
                        .doc(auth.currentUser!.uid)
                        .set({
                          'jenis pengguna': _selectedTypeUsers,
                          'nama lengkap': _userName.text.trim(),
                          'email': _email.text.trim(),
                          'nomor HP': _phoneNumber.text.trim(),
                          'alamat': _address.text.trim(),
                          'kata sandi': _password.text.trim()
                        })
                        .then((value) => setState(() => isLoading = true))
                        .then((value) => setState(() {
                              isLoading = false;
                              Navigator.pop(context);
                            }))
                  }
              })
          .catchError((error) {
        setState(() {
          isLoading = false;
        });
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
}
