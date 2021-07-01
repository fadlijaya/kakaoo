import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:kakaoo/app/ui/pages/petani/home/akun.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
var userName;
var phoneNumber;

class Jual extends StatefulWidget {
  @override
  _JualState createState() => _JualState();
}

class _JualState extends State<Jual> {
  var _currentPosition;
  var _currentAddress;
  var _imageFile;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _harga = TextEditingController();
  TextEditingController _judul = TextEditingController();
  TextEditingController _deskripsi = TextEditingController();
  TextEditingController _tglJual = TextEditingController();

  DateTime date = DateTime.now();

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
      uploadImageToFirebase();
    });
  }

  late String _imageUrl;

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

    /*try {
      firebase_storage.TaskSnapshot snapshot = await firebase_storage
          .FirebaseStorage.instance
          .ref('$_imageFile')
          .putFile(file);
      if (snapshot.state == firebase_storage.TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl;
        });
      }
    } on firebase_storage.FirebaseStorage catch (e) {
      print(e);
    }*/
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    if (auth.currentUser != null) {
      await firestore.collection('petani').get().then((result) {
        if (result.docs.length > 0) {
          setState(() {
            userName = result.docs[0].data()['nama'];
            phoneNumber = result.docs[0].data()['nomorHP'];
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: Text(
        'Masukkan Detail Informasi',
        style: TextStyle(
            color: AppColor().colorChocolate,
            fontWeight: FontWeight.bold,
            fontSize: 18.0),
      ),
    );
  }

  widgetFile() {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lokasi',
              style: TextStyle(fontSize: 16.0),
            ),
            // ignore: deprecated_member_use
            FlatButton.icon(
                onPressed: () {
                  getCurrentLocation();
                },
                icon: Icon(
                  Icons.gps_fixed,
                  color: AppColor().colorCreamy,
                ),
                label: Text(
                  'Gunakan lokasi saat ini',
                  style: TextStyle(
                    color: AppColor().colorCreamy,
                  ),
                )),
            // ignore: unnecessary_null_comparison
            if (_currentAddress != null)
              Padding(
                padding: const EdgeInsets.only(left: 48.0),
                child: Text(_currentAddress),
              ),
            SizedBox(
              height: 16.0,
            ),
            Divider(
              height: 1.0,
            ),
            TextFormField(
              controller: _harga,
              decoration: InputDecoration(labelText: 'Harga / Liter *'),
              keyboardType: TextInputType.number,
              validator: (_) {
                if (_!.isEmpty) {
                  return 'Harga tidak boleh kosong!';
                }
              },
            ),
            TextFormField(
              controller: _judul,
              decoration: InputDecoration(labelText: 'Jenis Kakao *'),
              validator: (_) {
                if (_!.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
              },
              maxLength: 50,
            ),
            TextFormField(
              controller: _deskripsi,
              decoration:
                  InputDecoration(labelText: 'Jelaskan Kakao yang anda Jual *',),
              validator: (_) {
                if (_!.isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
              },
              maxLines: 3,
              maxLength: 500,
            ),
            TextFormField(
              controller: _tglJual,
              decoration: InputDecoration(
                  labelText: 'Tanggal Jual',
                  suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[Icon(Icons.today)])),
              readOnly: true,
              onTap: () async {
                DateTime today = DateTime.now();
                DateTime? datePicker = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: today,
                  lastDate: today,
                );
                if (datePicker != null) {
                  date = datePicker;
                  _tglJual.text = DateFormat('dd MMMM yyyy').format(date);
                }
              },
            ),
            SizedBox(
              height: 12.0,
            ),
            Expanded(
              child: Stack(
                children: [
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
                ],
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
             // final String _url = _imageUrl;

              if (_formKey.currentState!.validate()) {
                final docRef = await firestore
                    .collection('petani')
                    .doc(auth.currentUser!.uid)
                    .collection('jual')
                    .add({
                  'nama': userName,
                  'nomorHP': phoneNumber,
                  'lokasi': _currentAddress,
                  'harga': _harga.text,
                  'judul': _judul.text,
                  'deskripsi': _deskripsi.text,
                  'posisi kordinat': GeoPoint(
                      _currentPosition.latitude, _currentPosition.longitude),
                  'tanggal jual': _tglJual.text,
                  'file foto': _imageUrl
                });

                firestore.collection('data jual').doc(docRef.id).set({
                  'nama': userName,
                  'nomorHP': phoneNumber,
                  'lokasi': _currentAddress,
                  'harga': _harga.text,
                  'judul': _judul.text,
                  'deskripsi': _deskripsi.text,
                  'posisi kordinat': GeoPoint(
                      _currentPosition.latitude, _currentPosition.longitude),
                  'tanggal jual': _tglJual.text,
                  'file foto': _imageUrl
                }).then(
                    (value) => {Navigator.popAndPushNamed(context, '/home')});
              }
            },
            child: Text('Upload File',
                style: TextStyle(
                  color: Colors.white,
                )),
          )),
    );
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) => {
              setState(() {
                _currentPosition = position;
                getAddressFromLatLong();
              })
            })
        .catchError((e) {
      print(e);
    });
  }

  getAddressFromLatLong() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.subLocality}, ${place.locality}";
      });
    } catch (e) {
      print(e);
    }
  }
}
