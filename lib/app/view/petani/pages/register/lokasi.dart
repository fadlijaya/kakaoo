import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kakaoo/app/services/api_services.dart';
import 'package:kakaoo/app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:kakaoo/app/view/petani/pages/jual/map_pick.dart';
import 'package:kakaoo/app/view/petani/pages/register/register.dart';

class Lokasi extends StatefulWidget {
  final String phoneNumber;
  final GeoPoint coordinate;
  final String location;
  final String currentArea;

  const Lokasi({
    Key? key,
    required this.phoneNumber,
    required this.coordinate,
    required this.location,
    required this.currentArea,
  }) : super(key: key);

  @override
  _LokasiState createState() => _LokasiState();
}

class _LokasiState extends State<Lokasi> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<ScaffoldState>();

  final TextEditingController _controllerAlamat = TextEditingController();

  Completer<GoogleMapController> _mapController = Completer();

  void onMapCreated(GoogleMapController _controller) {
    _mapController.complete(_controller);
  }

  String? _valueKabupaten;
  String? _valueKecamatan;
  String? _valueKelurahan;

  List<dynamic> listKecamatan = [], listKelurahan = [];

  Future<String> getKecamatan() async {
    var response = await http.get(
        Uri.parse("${ApiService().baseURL}/kecamatan?id_kota=7302"),
        headers: {"Accept": "application/json"});
    Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      listKecamatan = data["kecamatan"];
    });

    print(listKecamatan[0]['nama']);
    return "Sukses";
  }

  Future<String> getKelurahan(String idKecamatan) async {
    var response = await http.get(
        Uri.parse(
            "${ApiService().baseURL}/kelurahan?id_kecamatan=$idKecamatan"),
        headers: {"Accept": "application/json"});
    Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      listKelurahan = data['kelurahan'];
    });

    print(listKelurahan[0]['nama']);
    return "Sukses";
  }

  @override
  void initState() {
    getKecamatan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
            child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(paddingDefault),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: AppColor().colorChocolate,
                          ),
                          SizedBox(
                            height: 44,
                          ),
                          Text(
                            'Daftar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text('Dimana Anda Berada?'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(paddingDefault),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapPick(
                                            phoneNumber: widget.phoneNumber)),
                                    (route) => false),
                                child: Row(
                                  children: [
                                    Image.asset('assets/google-maps.png'),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    widget.location == ''
                                        ? Text(
                                            'Lokasi Anda',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black54),
                                          )
                                        : Flexible(
                                            child: Text(widget.location)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),
                              widget.coordinate.latitude == 0.0 &&
                                      widget.coordinate.longitude == 0.0
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: GoogleMap(
                                          onMapCreated: onMapCreated,
                                          initialCameraPosition: CameraPosition(
                                              zoom: 16.0,
                                              target: LatLng(0.0, 0.0))),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: GoogleMap(
                                          onMapCreated: onMapCreated,
                                          markers: createMarker(),
                                          initialCameraPosition: CameraPosition(
                                              zoom: 16.0,
                                              target: LatLng(
                                                  widget.coordinate.latitude,
                                                  widget
                                                      .coordinate.longitude)))),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  'Pastikan lokasi yang anda tandai di peta sama dengan alamat yang anda isi di bawah',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 16,
                              ),
                              DropdownButton(
                                items: ['Bulukumba'].map((item) {
                                  return DropdownMenuItem(
                                      value: item, child: Text(item));
                                }).toList(),
                                onChanged: (selected) {
                                  setState(() {
                                    _valueKabupaten = selected.toString();
                                  });
                                },
                                isExpanded: true,
                                value: _valueKabupaten,
                                hint: Text('Pilih Kabupaten'),
                              ),
                              _valueKabupaten != null
                                  ? DropdownButton(
                                      items: listKecamatan.map((item) {
                                        String id = item['id'].toString();
                                        String nama = item['nama'];

                                        return DropdownMenuItem(
                                            value: id, child: Text(nama));
                                      }).toList(),
                                      onChanged: (selected) {
                                        setState(() {
                                          _valueKecamatan = selected.toString();
                                          _valueKelurahan = null;
                                        });
                                        getKelurahan(selected.toString());
                                      },
                                      isExpanded: true,
                                      value: _valueKecamatan,
                                      hint: Text('Pilih Kecamatan'),
                                    )
                                  : Text(''),
                              _valueKecamatan != null
                                  ? DropdownButton(
                                      items: listKelurahan.map((item) {
                                        return DropdownMenuItem(
                                            value: item['nama'].toString(),
                                            child: Text('${item['nama']}'));
                                      }).toList(),
                                      onChanged: (selected) {
                                        setState(() {
                                          _valueKelurahan = selected.toString();
                                        });
                                      },
                                      isExpanded: true,
                                      value: _valueKelurahan,
                                      hint: Text('Pilih Kelurahan'),
                                    )
                                  : Text(''),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Alamat',
                                  style: TextStyle(color: Colors.black54)),
                              TextFormField(
                                controller: _controllerAlamat,
                                decoration: InputDecoration(
                                    hintText:
                                        'Cth: Nama Jalan, Lorong, Setapak atau Nomor Rumah'),
                                maxLines: 2,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Alamat Tidak Boleh Kosong!';
                                  }
                                },
                                textInputAction: TextInputAction.done,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: paddingDefault,
                left: paddingDefault,
                right: paddingDefault,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 48.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: widget.currentArea ==
                              "Kabupaten ${_valueKabupaten.toString()}"
                          // ignore: deprecated_member_use
                          ? RaisedButton(
                              onPressed: buttonNext,
                              color: AppColor().colorCreamy,
                              child: Center(
                                child: Text(
                                  'Lanjut',
                                  style: TextStyle(
                                      color: AppColor().colorChocolate,
                                      fontSize: 16.0),
                                ),
                              ),
                            )
                          // ignore: deprecated_member_use
                          : RaisedButton(
                              onPressed: () {},
                              color: Colors.white24,
                              child: Center(
                                child: Text(
                                  'Lanjut',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            )),
                ))
          ],
        )),
      ),
    );
  }

  buttonNext() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => Register(
                phoneNumber: widget.phoneNumber,
                location: widget.location,
                coordinate: widget.coordinate,
                kabupaten: _valueKabupaten.toString(),
                kecamatan: _valueKecamatan.toString(),
                kelurahan: _valueKelurahan.toString(),
                address: _controllerAlamat.text)),
        (route) => false);
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
