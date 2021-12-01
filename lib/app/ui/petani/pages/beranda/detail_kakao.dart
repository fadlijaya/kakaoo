import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/constants.dart';

class DetailKakao extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final String location;
  final String price;
  final int stock;
  final String unit;
  final String title;
  final String desc;
  final GeoPoint coordinate;
  final String saleDate;
  final String? imageFile;

  const DetailKakao({
    Key? key,
    required this.userName,
    required this.phoneNumber,
    required this.location,
    required this.price,
    required this.stock,
    required this.unit,
    required this.title,
    required this.desc,
    required this.coordinate,
    required this.saleDate,
    required this.imageFile,
  }) : super(key: key);

  @override
  _DetailKakaoState createState() => _DetailKakaoState();
}

class _DetailKakaoState extends State<DetailKakao> {
  Completer<GoogleMapController> _mapController = Completer();

  void onMapCreated(GoogleMapController _controller) {
    _mapController.complete(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final int harga = int.parse(widget.price);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        widget.imageFile == null
                            ? Container(
                              width: double.infinity,
                                height: 200,
                                child: ClipRRect(
                                  child: Center(
                                      child: Text(
                                    'Tidak Dapat Memuat Gambar, Coba lagi',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                height: 200,
                                child: ClipRRect(
                                  child: Image.network(
                                    "${widget.imageFile}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        Positioned(
                            top: 9,
                            left: 9,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.black.withOpacity(0.3)),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                            )),
                        Positioned(
                            top: 9,
                            right: 9,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(paddingDefault),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp ',
                                        decimalDigits: 0)
                                    .format(harga),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${widget.saleDate}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 12.0),
                          Text(widget.title)
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: paddingDefault),
                      child: Text(
                        'Detail',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(paddingDefault),
                      child: Row(
                        children: [
                          Text(
                            'STOK : ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 40.0,
                          ),
                          Text(widget.stock.toString())
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: paddingDefault,
                          top: 4.0,
                          bottom: paddingDefault),
                      child: Row(
                        children: [
                          Text(
                            'SATUAN : ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 24.0,
                          ),
                          Text(widget.unit)
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: paddingDefault),
                      child: Text(
                        'Deskripsi',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(paddingDefault),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.desc,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(paddingDefault),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Produk',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 4,
                            child: GoogleMap(
                                onMapCreated: onMapCreated,
                                markers: createMarker(),
                                initialCameraPosition: CameraPosition(
                                    zoom: 16.0,
                                    target: LatLng(widget.coordinate.latitude,
                                        widget.coordinate.longitude))),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId(widget.coordinate.toString()),
        position:
            LatLng(widget.coordinate.latitude, widget.coordinate.longitude),
        icon: BitmapDescriptor.defaultMarker,
      )
    ].toSet();
  }
}
