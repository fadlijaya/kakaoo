import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class EditProfil extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String phoneNumber;
  final String fullName;
  final String username;
  final String email;

  const EditProfil({
    Key? key,
    required this.isEdit,
    this.documentId = '',
    this.phoneNumber = '',
    this.fullName = '',
    this.username = '',
    this.email = '',
  }) : super(key: key);

  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _fullName = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _email = TextEditingController();

  bool isLoading = false;
  bool isHidePassword = true;

  void togglePasswordVisibility() {
    setState(() {
      isHidePassword = !isHidePassword;
    });
  }

  @override
  void initState() {
    if (widget.isEdit) {
      setState(() {
        _fullName.text = widget.fullName;
        _username.text = widget.username;
        _phoneNumber.text = widget.phoneNumber;
        _email.text = widget.email;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String title = "Edit Profil";

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor().colorCreamy,
          title: Text(
            title,
            style: TextStyle(color: AppColor().colorChocolate),
          ),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: AppColor().colorChocolate,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: paddingDefault),
              child: GestureDetector(
                  onTap: () => updateData(),
                  child: Icon(
                    Icons.check,
                    color: AppColor().colorChocolate,
                  )),
            )
          ],
        ),
        body: formProfil());
  }

  formProfil() {
    final node = FocusScope.of(context);

    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(paddingDefault),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Dasar',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _fullName,
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
                  controller: _username,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Username';
                    }
                  },
                ),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Email';
                    }
                  },
                ),
                SizedBox(
                  height: 32.0,
                ),
                Text(
                  'Informasi Kontak',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 12.0,
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
              ],
            ),
          )),
    );
  }

  updateData() async {
    setState(() {
      isLoading = true;
    });

    if (widget.isEdit) {
      DocumentReference docRefUsers =
          firestore.collection('users').doc(widget.documentId);

      firestore.runTransaction((transaction) async {
        DocumentSnapshot task = await transaction.get(docRefUsers);
        if (task.exists) {
          // ignore: await_only_futures
          await transaction.update(
            docRefUsers,
            <String, dynamic>{
              'nama lengkap': _fullName.text,
              'nama pengguna': _username.text,
              'nomor HP': _phoneNumber.text,
              'email': _email.text
            },
          );
        }
      });

      DocumentReference docRefPetani =
          firestore.collection('petani').doc(widget.documentId);

      firestore.runTransaction((transaction) async {
        DocumentSnapshot task = await transaction.get(docRefPetani);
        if (task.exists) {
          // ignore: await_only_futures
          await transaction.update(
            docRefPetani,
            <String, dynamic>{
              'nama lengkap': _fullName.text,
              'nama pengguna': _username.text,
              'nomor HP': _phoneNumber.text,
              'email': _email.text
            },
          );
        }
      });

      Navigator.pop(context);
    }
  }
}
