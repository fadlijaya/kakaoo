import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/tengkulak/home/rute.dart';

class Maps extends StatefulWidget {
  final String foto;
  final String lokasi;
  final String nama;
  final String nomorHP;
  final String deskripsi;
  final GeoPoint initialPosition;

  const Maps({
    Key? key,
    image,
    required this.foto,
    required this.lokasi,
    required this.nama,
    required this.nomorHP,
    required this.initialPosition,
    required this.deskripsi,
  }) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _mapController = Completer();

  void onMapCreated(GoogleMapController _controller) {
    _mapController.complete(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Container(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(widget.initialPosition.latitude,
                              widget.initialPosition.longitude),
                          zoom: 16.0),
                      onMapCreated: onMapCreated,
                      markers: createMarker()),
                ),
                Positioned(
                  bottom: 120.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: paddingDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(widget.foto),
                            ),
                            SizedBox(
                              width: 24.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Text('${widget.nama}',
                                        style: TextStyle(
                                          color: AppColor().colorChocolate,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Text('${widget.nomorHP}',
                                        style: TextStyle(
                                          color: AppColor().colorChocolate,
                                        ))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 24.0,),
                        Text('Deskripsi', style: TextStyle(color: AppColor().colorChocolate, fontWeight: FontWeight.w500 ),),
                        SizedBox(height: 8.0,),
                        Text(
                          '${widget.deskripsi}',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0),

                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColor().colorChocolate),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Rute(
                                        location: widget.lokasi,
                                        initialPosition:
                                            widget.initialPosition)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Text('Rute',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0))
                            ],
                          ))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Set<Marker> createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId(widget.initialPosition.toString()),
        position: LatLng(
            widget.initialPosition.latitude, widget.initialPosition.longitude),
        icon: BitmapDescriptor.defaultMarker,
      )
    ].toSet();
  }
}
