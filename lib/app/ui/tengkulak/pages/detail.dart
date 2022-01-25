import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/lihat_profil.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/pesanan.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/rute.dart';

class Detail extends StatefulWidget {
  final String tengkulakAddress;
  final String docIdProduct;
  final String userIdPetani;
  final String typeUsers;
  final String fullname;
  final String phoneNumber;
  final String location;
  final String unit;
  final String price;
  final int stock;
  final String title;
  final String desc;
  final GeoPoint coordinate;
  final String saleDate;
  final String imageFile;

  const Detail({
    Key? key,
    required this.tengkulakAddress,
    required this.docIdProduct,
    required this.userIdPetani,
    required this.typeUsers,
    required this.fullname,
    required this.phoneNumber,
    required this.location,
    required this.unit,
    required this.price,
    required this.stock,
    required this.title,
    required this.desc,
    required this.coordinate,
    required this.saleDate,
    required this.imageFile,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String get imageFile => widget.imageFile;
  Completer<GoogleMapController> _mapController = Completer();
  PersistentBottomSheetController? _sheetController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void onMapCreated(GoogleMapController _controller) {
    _mapController.complete(_controller);
  }

  final TextEditingController _controllerPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int harga = int.parse(widget.price);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Container(
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
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: ClipRRect(
                                    child: Image.network(
                                      '$imageFile',
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.black.withOpacity(0.3)),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      ),
                                    )),
                                Positioned(
                                    top: 9,
                                    right: 9,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                  Text(
                                    NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 0)
                                        .format(harga),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(widget.title),
                                  SizedBox(height: 12.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16.0,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.location,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              widget.saleDate,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: paddingDefault),
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
                                  bottom: paddingDefault,
                                  top: 4.0),
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
                              padding:
                                  const EdgeInsets.only(left: paddingDefault),
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
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LihatProfil(
                                            fullname: widget.fullname,
                                            location: widget.location,
                                            coordinate: widget.coordinate,
                                            phoneNumber: widget.phoneNumber,
                                          ))),
                              child: Container(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.account_circle,
                                    size: 48.0,
                                    color: Colors.grey,
                                  ),
                                  title: Text(
                                    widget.fullname,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  subtitle: Text('LIHAT PROFIL',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500)),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.0,
                                  ),
                                ),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: GoogleMap(
                                        onMapCreated: onMapCreated,
                                        markers: createMarker(),
                                        initialCameraPosition: CameraPosition(
                                            zoom: 16.0,
                                            target: LatLng(
                                                widget.coordinate.latitude,
                                                widget.coordinate.longitude))),
                                  ),
                                  SizedBox(height: 60.0)
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
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    color: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: bottomSheetBuy,
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(paddingDefault),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColor().colorChocolate),
                            child: Center(
                                child: Text('BELI',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white))),
                          ),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: bottomSheetOffer,
                            child: Container(
                              padding: EdgeInsets.all(paddingDefault),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: AppColor().colorCreamy),
                              child: Center(
                                  child: Text('BUAT PENAWARAN',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Rute(
                                      tengkulakAddress: widget.tengkulakAddress,
                                      location: widget.location,
                                      coordinate: widget.coordinate))),
                          child: Container(
                            width: 70,
                            padding: EdgeInsets.all(paddingDefault),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.blue),
                            child: Center(
                              child: Text('RUTE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
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

  int _itemCount = 5;

  void incrementBottomSheet() {
    _sheetController!.setState!(() {
      _itemCount++;
    });
  }

  void decrementBottomSheet() {
    _sheetController!.setState!(() {
      _itemCount--;
    });
  }

  bottomSheetBuy() async {
    _sheetController = _scaffoldKey.currentState!.showBottomSheet(
      (context) => Container(
        padding: EdgeInsets.all(paddingDefault),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 8,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(4)),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  child: Container(
                      height: 110.0,
                      width: 110.0,
                      child: Image.network(
                        widget.imageFile,
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(width: 36.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                            .format(int.parse(widget.price)),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18.0)),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Stok : ${widget.stock}'.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey)),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.unit,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: _itemCount > 5
                      ? IconButton(
                          constraints:
                              BoxConstraints(minHeight: 24.0, minWidth: 24.0),
                          onPressed: decrementBottomSheet,
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
                      onPressed: () => {
                            if (_itemCount < widget.stock)
                              {
                                incrementBottomSheet(),
                              }
                          },
                      icon: Icon(Icons.add, color: Colors.black54)),
                )
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Minimum Pembelian 5 Kilogram/Liter', style: TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
            SizedBox(
              height: 24.0,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColor().colorChocolate),
              child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Pesanan(
                                docIdProduct: widget.docIdProduct,
                                userIdPetani: widget.userIdPetani,
                                imageFile: widget.imageFile,
                                title: widget.title,
                                price: widget.price,
                                stock: widget.stock,
                                itemCount: _itemCount,
                              ))),
                  child: Text(
                    'BELI SEKARANG',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  bottomSheetOffer() {
    _controllerPrice.text = widget.price;

    _sheetController =
        _scaffoldKey.currentState!.showBottomSheet((context) => Container(
              padding: EdgeInsets.all(paddingDefault), 
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 48,
                  height: 8,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4)),
                ),
                SizedBox(height: paddingDefault),
                Row(
                  children: [
                    Text('Buat Penawaran',
                        style: TextStyle(fontSize: 20, color: Colors.black54)),
                  ],
                ),
                SizedBox(
                  height: paddingDefault,
                ),
                Row(
                  children: [
                    Text('Rp ', style: TextStyle(fontSize: 40)),
                    Container(
                      width: 200,
                      height: 48,
                      child: TextFormField(
                        controller: _controllerPrice,
                        decoration: InputDecoration(labelText: ''),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: Text('Kirim'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all( 
                                AppColor().colorChocolate))),
                  ],
                )
              ]),
            ));
  }
}
