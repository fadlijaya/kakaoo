import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/tengkulak/home/akun.dart';
import 'package:kakaoo/app/ui/pages/tengkulak/home/maps.dart';

final Stream<QuerySnapshot> _listDataPetani =
    FirebaseFirestore.instance.collection('data jual').snapshots();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColor().colorChocolate)
                ),
                padding: EdgeInsets.only(left: paddingDefault),
                width: 260.0,
                height: 48.0,
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'Cari',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    )
                  ],
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
          Text('Lokasi Terbaru',
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
              child: StreamBuilder(
            stream: _listDataPetani,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Belum Ada Data!'),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong!'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text('Loading...'),
                );
              }

              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black12)
                  ),
                  height: 220.0,
                  child: GestureDetector(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          child: Container(
                            height: 120.0,
                            child: Image.network(
                              '${document['file foto']}',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
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
                                Text('Rp. ${document['harga']}/Liter'),
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
                                    Text(
                                      '${document['lokasi']}',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0),
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
                              builder: (context) => Maps(
                                  foto: document['file foto'],
                                  lokasi: document['lokasi'],
                                  nama: document['nama'],
                                  nomorHP: document['nomorHP'],
                                  deskripsi: document['deskripsi'],
                                  initialPosition:
                                      document['posisi kordinat'])));
                    },
                  ),
                );
              }).toList());
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
