import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/akun.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/detail.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/search.dart';

final Stream<QuerySnapshot> listProduct =
    FirebaseFirestore.instance.collection('penjualan').snapshots();

class HomeTengkulak extends StatefulWidget {
  const HomeTengkulak({
    Key? key,
  }) : super(key: key);

  @override
  _HomeTengkulakState createState() => _HomeTengkulakState();
}

class _HomeTengkulakState extends State<HomeTengkulak> {
  var _currentPosition;
  var _currentAddress;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: Stack(
          children: [widgetHeader(), widgetListData()],
        ),
      )),
    );
  }

  widgetHeader() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: _currentAddress != null
                ? Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColor().colorChocolate,
                      ),
                      Text(
                        _currentAddress,
                        style: TextStyle(
                            color: AppColor().colorChocolate,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () => getCurrentLocation(), child: Text('')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey)),
                  padding: EdgeInsets.only(left: paddingDefault),
                  width: 260.0,
                  height: 48.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Cari',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Akun()));
                },
                child: Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                  size: 48.0,
                ),
              )
            ],
          ),
          SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daftar Produk',
                  style: TextStyle(
                    color: AppColor().colorChocolate,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  )),
              IconButton(
                  onPressed: () {
                    filterBottomSheet();
                  },
                  icon: Icon(Icons.tune,
                      size: 30, color: AppColor().colorChocolate))
            ],
          ),
        ],
      ),
    );
  }

  filterBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(paddingDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.filter_alt),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Urut Berdasarkan Jarak Terdekat',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  String? _calculateDistance;

  double _coordinateDistance(lat2, lon2) {
    double d = 111.322;
    return sqrt(pow(lat2 - _currentPosition.latitude, 2) +
            pow(lon2 - _currentPosition.longitude, 2)) * d;
  }

  widgetListData() {
    return Container(
      margin: EdgeInsets.only(top: 160.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: listProduct,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error!'),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'Belum Ada Data!',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              } else {
                return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                  final int harga = int.parse(document['harga']);
                  final GeoPoint destLatLong = document['posisi kordinat'];

                  _calculateDistance = _coordinateDistance(
                          destLatLong.latitude, destLatLong.longitude)
                      .toStringAsFixed(2);

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black12)),
                    height: 250.0,
                    child: GestureDetector(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            child: Container(
                              height: 120.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "${document['file foto']}"))),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(paddingDefault),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '$_calculateDistance km ',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${document['judul']}',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp ',
                                          decimalDigits: 0)
                                      .format(harga)),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.black54,
                                        size: 16.0,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${document['alamat']}',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detail(
                                    tengkulakAddress: _currentAddress.toString(),
                                    docIdProduct: document['docIdProduct'],
                                    typeUsers: document['jenis pengguna'],
                                    fullname: document['nama lengkap'],
                                    phoneNumber: document['nomor HP'],
                                    location: document['alamat'],
                                    unit: document['satuan'],
                                    price: document['harga'],
                                    stock: document['stok'],
                                    title: document['judul'],
                                    desc: document['deskripsi'],
                                    coordinate: document['posisi kordinat'],
                                    saleDate: document['tanggal jual'],
                                    imageFile: document['file foto'])));
                      },
                    ),
                  );
                }).toList());
              }
            },
          )),
        ],
      ),
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
        _currentAddress = "${place.street}, ${place.subLocality}";
      });
    } catch (e) {
      print(e);
    }
  }
}
