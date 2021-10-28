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
                    mainAxisAlignment: MainAxisAlignment.end,
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
            height: 16.0,
          ),
          Text('Produk Terbaru',
              style: TextStyle(
                color: AppColor().colorChocolate,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  widgetListData() {
    return Container(
      margin: EdgeInsets.only(top: 150.0),
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

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black12)),
                    height: 230.0,
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
                                    docIdProduct: document['docIdProduct'],
                                    typeUsers: document['jenis pengguna'],
                                    userName: document['nama lengkap'],
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
        _currentAddress = "${place.locality}, ${place.subAdministrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }
}