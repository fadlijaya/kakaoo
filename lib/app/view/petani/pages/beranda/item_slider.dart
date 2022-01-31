import 'package:flutter/material.dart';
import 'package:kakaoo/app/utils/constants.dart';

class ItemSlider1 extends StatelessWidget {
  final String imageSlider = "assets/slider1.png";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailSliders1(image: imageSlider))),
      child: Container(
        child: Image.asset(imageSlider)
      ),
    );
  }
}

class DetailSliders1 extends StatelessWidget {
  final String image;
  const DetailSliders1({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TextDetailSliders1().title)),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(paddingDefault),
        child: Column(
          children: [
            Text(
                "Perkembangan Harga Kakao Tingkat Produsen di Pasar Domestik, 2010 - 2019", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            SizedBox(height: 16.0),
            DataTable(columns: [
              DataColumn(label: Text("Tahun")),
              DataColumn(label: Text("Harga\nProdusen\n(Rp/Kg)")),
              DataColumn(label: Text("Pertumbuhan\n (%)")),
            ], rows: [
              DataRow(cells: [
                DataCell(Text("2010")),
                DataCell(Text("18.557")),
                DataCell(Text("12,4"))
              ]),
              DataRow(cells: [
                DataCell(Text("2011")),
                DataCell(Text("19.259")),
                DataCell(Text("3,79"))
              ]),
              DataRow(cells: [
                DataCell(Text("2012")),
                DataCell(Text("18.297")),
                DataCell(Text("4,99"))
              ]),
              DataRow(cells: [
                DataCell(Text("2013")),
                DataCell(Text("19.067")),
                DataCell(Text("4,21"))
              ]),
              DataRow(cells: [
                DataCell(Text("2014")),
                DataCell(Text("23.336")),
                DataCell(Text("22,39"))
              ]),
              DataRow(cells: [
                DataCell(Text("2015")),
                DataCell(Text("23.335")),
                DataCell(Text("0,00"))
              ]),
              DataRow(cells: [
                DataCell(Text("2016")),
                DataCell(Text("24.871")),
                DataCell(Text("6.58"))
              ]),
              DataRow(cells: [
                DataCell(Text("2017")),
                DataCell(Text("21.475")),
                DataCell(Text("-7.97"))
              ]),
              DataRow(cells: [
                DataCell(Text("2018")),
                DataCell(Text("21.459")),
                DataCell(Text("-0,07"))
              ]),
              DataRow(cells: [
                DataCell(Text("2019")),
                DataCell(Text("21.621")),
                DataCell(Text("0,75"))
              ]),
            ]),
            DataTable(columns: [
              DataColumn(label: Text("Rata-rata Pertumbuhan (%)")),
              DataColumn(label: Text(""))
            ], rows: [
              DataRow(cells: [
                DataCell(Text("2010 - 2019")),
                DataCell(Text("3,71"))
              ])
            ]),
            SizedBox(height: 16.0),
            Text(
              "Sumber : Badan Pusat Statistik dan Direktorat Jenderal Perkebunan, diolah Pusdatin",
              style: TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
            
          ],
        ),
      )),
    );
  }
}

class ItemSliders2 extends StatelessWidget {
  final String imageSlider = "assets/slider2.png";

  const ItemSliders2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailSliders2(image: imageSlider))),
      child: Container(
        child: Image.asset(imageSlider),
      ),
    );
  }
}

class DetailSliders2 extends StatelessWidget {
  final String image;
  const DetailSliders2({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TextDetailSliders2().title)),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRUcGODsMm3aG3f1mSCzhy5IlSFTy_XRu-xQ&usqp=CAU", fit: BoxFit.cover,)),
                Container(
                    padding: EdgeInsets.all(paddingDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TextDetailSliders2().date,
                          style: TextStyle(color: Colors.black54, fontSize: 12.0),
                        ),
                        SizedBox(
                          height: paddingDefault,
                        ),
                        Text(
                          TextDetailSliders2().desc,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 16.0),
                         Text(
                          TextDetailSliders2().author,
                          style: TextStyle(color: Colors.black54, fontSize: 12.0),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
