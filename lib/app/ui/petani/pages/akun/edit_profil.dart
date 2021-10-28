import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class EditProfil extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String email;
  final String address;
  final String phoneNumber;
  final String fullName;
  final String password;
  const EditProfil(
      {Key? key,
      required this.isEdit,
      this.documentId = '',
      this.email = '',
      this.address = '',
      this.phoneNumber = '',
      this.fullName = '',
      required this.password})
      : super(key: key);

  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _fullName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _address = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    if (widget.isEdit) {
      _fullName.text = widget.fullName;
      _address.text = widget.address;
      _email.text = widget.email;
      _phoneNumber.text = widget.phoneNumber;
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

    return Container(
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
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: _email,
                onFieldSubmitted: (value) => node.unfocus(),
                decoration: InputDecoration(labelText: 'Email'),
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
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ));
  }

  updateData() async {
    setState(() {
      isLoading = true;
    });

    if (widget.isEdit) {
      DocumentReference docRef =
          firestore.collection('users').doc(auth.currentUser!.uid);

      firestore.runTransaction((transaction) async {
        DocumentSnapshot task = await transaction.get(docRef);
        if (task.exists) {
          // ignore: await_only_futures
          await transaction.update(
            docRef,
            <String, dynamic>{
              'nama lengkap': _fullName.text,
              'nomor HP': _phoneNumber.text,
              'alamat': _address.text,
              'email': _email.text
            },
          );
        }
        Navigator.pop(context);
      });
    }
  }
}
