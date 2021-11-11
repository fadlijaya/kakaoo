import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/constants.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
var fullname;
var email;
var phoneNumber;

class Pesanan extends StatefulWidget {
  final String docIdProduct;
  final String imageFile;
  final String title;
  final String price;
  final int itemCount;

  const Pesanan(
      {Key? key,
      required this.docIdProduct,
      required this.imageFile,
      required this.title,
      required this.price,
      required this.itemCount})
      : super(key: key);

  @override
  _PesananState createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  final String title = "Checkout";

  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    await firestore
        .collection('tengkulak')
        .where('userId')
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        setState(() {
          fullname = result.docs[0].data()['nama lengkap'];
          email = result.docs[0].data()['email'];
          phoneNumber = result.docs[0].data()['nomor HP'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var totalPay = int.parse(widget.price) * widget.itemCount;

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
              Icons.arrow_back,
              color: AppColor().colorChocolate,
            )),
      ),
      body: Container(
          padding: EdgeInsets.all(paddingDefault),
          child: Stack(
            children: [
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Barang yang dibeli',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        height: 90.0,
                        child: ListTile(
                            // ignore: unnecessary_null_comparison
                            leading: widget.imageFile == null
                                ? Text("")
                                : Container(
                                    width: 90.0,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                widget.imageFile))),
                                  ),
                            title: Text(widget.title,
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp ',
                                        decimalDigits: 0)
                                    .format(int.parse(widget.price)),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500))),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Ringkasan Belanja',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Jumlah",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 16.0),
                          ),
                          Text(widget.itemCount.toString(),
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16.0))
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Harga Pesanan",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16.0)),
                          Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0)
                                  .format(int.parse(widget.price)),
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16.0))
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Pembayaran",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0)),
                          Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0)
                                  .format(totalPay),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0))
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Text(
                        "Jika sudah melakukan transaksi pembayaran, silahkan centang",
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              }),
                          Text("Sudah Bayar")
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      isChecked == false
                          ? Text("")
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Masukkan Bukti Pembayaran",
                                    style: TextStyle(color: Colors.black54)),
                                SizedBox(
                                  height: 16.0,
                                ),
                                _paymentFile != null
                                    ? Container(
                                        width: double.infinity,
                                        height: 120.0,
                                        child: Image.file(_paymentFile))
                                    : GestureDetector(
                                        onTap: () => pickImage(),
                                        child: Container(
                                          width: 90.0,
                                          height: 24.0,
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          child: Center(child: Text("Upload")),
                                        ),
                                      )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColor().colorCreamy,
                        borderRadius: BorderRadius.circular(8.0)),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await firestore.collection('pesanan').add({
                              'docIdProduct': widget.docIdProduct,
                              'nama lengkap': fullname,
                              'nomor HP': phoneNumber,
                              'email': email,
                              'file foto': widget.imageFile,
                              'judul': widget.title,
                              'harga': widget.price,
                              'jumlah': widget.itemCount,
                              'total bayar': totalPay.toString(),
                              'bukti bayar': _imageUrl
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotifSuccess()));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: AppColor().colorChocolate,
                              size: 16.0,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "Buat Pesanan",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            )
                          ],
                        )),
                  ))
            ],
          )),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return AppColor().colorChocolate;
  }

  var _paymentFile;

  Future pickImage() async {
    final pickedFile =
        // ignore: deprecated_member_use
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _paymentFile = File(pickedFile!.path);
      uploadImageToFirebase();
    });
  }

  String? _imageUrl;

  Future uploadImageToFirebase() async {
    File file = File(_paymentFile.path);

    if (_paymentFile != null) {
      firebase_storage.TaskSnapshot snapshot = await firebase_storage
          .FirebaseStorage.instance
          .ref('$_paymentFile')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    } else {
      print('Tidak dapat ditampilkan');
    }
  }
}

class NotifSuccess extends StatefulWidget {
  const NotifSuccess({Key? key}) : super(key: key);

  @override
  _NotifSuccessState createState() => _NotifSuccessState();
}

class _NotifSuccessState extends State<NotifSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor().colorCreamy,
          title: Text(
            'Transaksi',
            style: TextStyle(color: AppColor().colorChocolate),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: AppColor().colorChocolate,
              ))),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/success.svg',
              width: 240,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Pembayaran Berhasil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
