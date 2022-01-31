import 'package:flutter/material.dart';
import 'package:kakaoo/app/utils/constants.dart';

class Lokasi extends StatefulWidget {
  final String phoneNumber;
  const Lokasi({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _LokasiState createState() => _LokasiState();
}

class _LokasiState extends State<Lokasi> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<ScaffoldState>();

  var _selectedKabupaten;
  var _selectedKecamatan;
  var _selected1;

  List<String> _listKecamatan = [
    'Kecamatan Bonto Bahari',
    'Kecamatan Bontotiro',
    'Kecamatan Bulukumpa',
    'Kecamatan Gantarang',
    'Kecamatan Herlang',
    'Kecamatan Kindang',
    'Kecamatan Kajang',
    'Kecamatan Rilau Ale',
    'Kecamatan Ujungloe',
    'Kecamatan Ujungbulu'
  ];

  List<String> _kecamatan1 = [
    'Desa Ara',
    'Kelurahan Benjala',
    'Desa Bira',
    'Desa Darubiah',
    'Desa Lembanna',
    'Kelurahan Sapolohe',
    'Kelurahan Tanah Beru',
    'Kelurahan Tanah Lemo',
  ];

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
                          Text('Isi kolom alamat lengkap di bawah ini')
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
                              DropdownButton(
                                items: ['Kabupaten Bulukumba'].map((value) {
                                  return DropdownMenuItem(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: (selected) {
                                  setState(() {
                                    _selectedKabupaten = selected;
                                  });
                                },
                                isExpanded: true,
                                value: _selectedKabupaten,
                                hint: Text('Pilih Kabupaten'),
                              ),
                              DropdownButton(
                                items: _listKecamatan.map((value) {
                                  return DropdownMenuItem(
                                      value: value, 
                                      child: Text(value));
                                }).toList(),
                                onChanged: (selected) {
                                  setState(() {
                                    _selectedKecamatan = selected;
                                  });
                                },
                                isExpanded: true,
                                value: _selectedKecamatan,
                                hint: Text('Pilih Kecamatan'),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
