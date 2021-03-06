import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:kakaoo/app/utils/constants.dart';
import 'package:kakaoo/app/view/petani/pages/beranda/home.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var typeUsers;
var fullname;
var username;
var phoneNumber;
var userId;
var location;
GeoPoint? coordinate;

var _saleDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

class Jual extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String unit;
  final String price;
  final int stock;
  final String title;
  final String desc;
  final String saleDate;
  final String? imageFile;

  const Jual({
    Key? key,
    required this.isEdit,
    this.documentId = '',
    this.unit = '',
    this.price = '',
    this.stock = 0,
    this.title = '',
    this.desc = '',
    this.saleDate = '',
    this.imageFile = '',
  }) : super(key: key);

  @override
  _JualState createState() => _JualState();
}

class _JualState extends State<Jual> {
  bool isLoading = false;
  var _imageFile;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _price = TextEditingController();

  Future pickImage() async {
    final pickedFile =
        // ignore: deprecated_member_use
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
      uploadImageToFirebase();
    });
  }

  String? _imageUrl;

  Future uploadImageToFirebase() async {
    File file = File(_imageFile.path);

    if (_imageFile != null) {
      firebase_storage.TaskSnapshot snapshot = await firebase_storage
          .FirebaseStorage.instance
          .ref('$_imageFile')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    } else {
      print('Tidak dapat ditampilkan');
    }
  }

  var _satuan;
  List<String> _listSatuan = ['Kilogram', 'Liter'];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _title.text = widget.title;
      _desc.text = widget.desc;
      _price.text = widget.price;
      _saleDate = _saleDate;
      _itemCount = widget.stock;
      _satuan = widget.unit;
      _imageUrl = widget.imageFile;
    }
    getUser();
  }

  Future getUser() async {
    await firestore
        .collection('petani')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        setState(() {
          typeUsers = result.docs[0].data()['jenis pengguna'];
          fullname = result.docs[0].data()['nama lengkap'];
          username = result.docs[0].data()['nama pengguna'];
          phoneNumber = result.docs[0].data()['nomor HP'];
          userId = result.docs[0].data()['userId'];
          location = result.docs[0].data()['lokasi'];
          coordinate = result.docs[0].data()['koordinat'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: Stack(
          children: [
            widgetHeader(),
            widgetFile(),
            uploadButton(),
          ],
        ),
      )),
    );
  }

  widgetHeader() {
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () => exitDialog(),
              icon: Icon(
                Icons.close,
                color: AppColor().colorChocolate,
              )),
          SizedBox(
            width: 16.0,
          ),
          Text(
            'Masukkan Informasi Produk',
            style: TextStyle(
                color: AppColor().colorChocolate,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  exitDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Hapus perubahan ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Tidak',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              TextButton(
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home())),
                  child: Text('Hapus')),
            ],
          );
        });
  }

  int _itemCount = 0;
  int _itemCount2 = 0;

  widgetFile() {
    return Container(
      margin: EdgeInsets.only(
        top: 60.0,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _title,
              decoration: InputDecoration(labelText: 'Nama Produk*'),
              validator: (_) {
                if (_!.isEmpty) {
                  return 'Nama Kakao tidak boleh kosong';
                }
              },
              maxLength: 50,
            ),
            TextFormField(
              controller: _desc,
              decoration: InputDecoration(
                labelText: 'Deskripsikan Kakao yang anda Jual*',
              ),
              validator: (_) {
                if (_!.isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
              },
              maxLines: 3,
              maxLength: 500,
            ),
            DropdownButton(
              items: _listSatuan
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (selected) {
                setState(() {
                  _satuan = selected;
                });
              },
              isExpanded: true,
              value: _satuan,
              hint: Text('Satuan'),
            ),
            TextFormField(
              controller: _price,
              decoration: InputDecoration(labelText: 'Harga*'),
              keyboardType: TextInputType.number,
              validator: (_) {
                if (_!.isEmpty) {
                  return 'Harga tidak boleh kosong!';
                }
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stok', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: _itemCount > 0
                      ? IconButton(
                          constraints:
                              BoxConstraints(minHeight: 24.0, minWidth: 24.0),
                          onPressed: () => setState(() => _itemCount--),
                          icon: Icon(
                            Icons.remove,
                            color: Colors.black54,
                          ))
                      : Container(),
                ),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)),
                    child: Text(_itemCount.toString(),
                        style: TextStyle(fontWeight: FontWeight.w500))),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: IconButton(
                      constraints:
                          BoxConstraints(minHeight: 24.0, minWidth: 24.0),
                      onPressed: () => setState(() => _itemCount++),
                      icon: Icon(Icons.add, color: Colors.black54)),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Minimum Pembelian',
                          style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: _itemCount2 < _itemCount
                      ? IconButton(
                          constraints:
                              BoxConstraints(minHeight: 24.0, minWidth: 24.0),
                          onPressed: () => setState(() => _itemCount2++),
                          icon: Icon(
                            Icons.add,
                            color: Colors.black54,
                          ))
                      : Container(),
                ),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)),
                    child: Text(_itemCount2.toString(),
                        style: TextStyle(fontWeight: FontWeight.w500))),
                _itemCount2 > _itemCount
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12)),
                        child: IconButton(
                            constraints:
                                BoxConstraints(minHeight: 24.0, minWidth: 24.0),
                            onPressed: () => setState(() => _itemCount2--),
                            icon: Icon(Icons.remove, color: Colors.black54)),
                      )
                    : Container()
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Tambahkan Foto Kakao',
              style: TextStyle(fontSize: 16.0),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 30.0, bottom: 40.0),
              child: ClipRRect(
                child: Center(
                  child: _imageFile != null
                      ? Image.file(_imageFile)
                      // ignore: deprecated_member_use
                      : FlatButton(
                          onPressed: () {
                            pickImage();
                          },
                          child: Icon(
                            Icons.add_a_photo,
                            size: 40.0,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  uploadButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColor().colorCreamy),
          // ignore: deprecated_member_use
          child: FlatButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (widget.isEdit) {
                DocumentReference docRef = firestore
                    .collection('petani')
                    .doc(userId)
                    .collection('penjualan')
                    .doc(widget.documentId);
                firestore.runTransaction((transaction) async {
                  DocumentSnapshot task = await transaction.get(docRef);
                  if (task.exists) {
                    // ignore: await_only_futures
                    await transaction.update(
                      docRef,
                      <String, dynamic>{
                        'jenis pengguna': typeUsers,
                        'nama lengkap': fullname,
                        'nomor HP': phoneNumber,
                        'stok': _itemCount,
                        'minimum pembelian': _itemCount2,
                        'satuan': _satuan.toString(),
                        'harga': _price.text,
                        'judul': _title.text,
                        'deskripsi': _desc.text,
                        'tanggal jual': _saleDate.toString(),
                        'file foto': _imageUrl
                      },
                    );
                  }
                });

                DocumentReference documentReference =
                    firestore.doc('penjualan/${widget.documentId}');
                firestore.runTransaction((transaction) async {
                  DocumentSnapshot task =
                      await transaction.get(documentReference);
                  if (task.exists) {
                    // ignore: await_only_futures
                    await transaction.update(
                      documentReference,
                      <String, dynamic>{
                        'jenis pengguna': typeUsers,
                        'nama lengkap': fullname,
                        'nomor HP': phoneNumber,
                        'stok': _itemCount,
                        'minimum pembelian': _itemCount2,
                        'satuan': _satuan.toString(),
                        'harga': _price.text,
                        'judul': _title.text,
                        'deskripsi': _desc.text,
                        'tanggal jual': _saleDate.toString(),
                        'file foto': _imageUrl
                      },
                    );
                    Navigator.pop(context, true);
                  }
                });
              } else {
                if (_formKey.currentState!.validate()) {
                  Future.delayed(Duration(seconds: 3), () async {
                    final docIdProduct = await firestore
                        .collection('petani')
                        .doc(userId)
                        .collection('penjualan')
                        .add({
                      'jenis pengguna': typeUsers,
                      'nama lengkap': fullname,
                      'nomor HP': phoneNumber,
                      'alamat': location,
                      'stok': _itemCount,
                      'minimum pembelian': _itemCount2,
                      'satuan': _satuan.toString(),
                      'harga': _price.text,
                      'judul': _title.text,
                      'deskripsi': _desc.text,
                      'posisi kordinat': coordinate,
                      'tanggal jual': _saleDate.toString(),
                      'file foto': _imageUrl
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));

                    firestore.collection('penjualan').doc(docIdProduct.id).set({
                      'docIdProduct': docIdProduct.id,
                      'userId': userId,
                      'jenis pengguna': typeUsers,
                      'nama lengkap': fullname,
                      'nomor HP': phoneNumber,
                      'alamat': location,
                      'stok': _itemCount,
                      'minimum pembelian': _itemCount2,
                      'satuan': _satuan.toString(),
                      'harga': _price.text,
                      'judul': _title.text,
                      'deskripsi': _desc.text,
                      'posisi kordinat': coordinate,
                      'tanggal jual': _saleDate.toString(),
                      'file foto': _imageUrl
                    }).then((value) => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()))
                        });
                  });
                }
              }
            },
            child: Text(widget.isEdit ? 'Update' : 'Upload',
                style: TextStyle(
                    color: AppColor().colorChocolate,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
          )),
    );
  }
}
