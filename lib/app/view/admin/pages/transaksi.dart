import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants.dart';

final Stream<QuerySnapshot> transaksi =
    FirebaseFirestore.instance.collection("transaksi").snapshots();
final FirebaseAuth auth = FirebaseAuth.instance;

class Transaksi extends StatefulWidget {
  const Transaksi({Key? key}) : super(key: key);

  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  final String title = "Transaksi";
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColor().colorCreamy,
      ),
      body: listTransaksi(),
    );
  }

  listTransaksi() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: transaksi,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error!'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('Belum Ada Data!'),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  var harga = document['price'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detail(
                                  isChecked: isChecked,
                                  userIdPetani: document['userIdPetani'],
                                  usernamePetani: document['usernamePetani'],
                                  namaLengkapPetani: document['namaLengkapPetani'],
                                  nomorHpPetani: document['nomorHpPetani'],
                                  emailPetani: document['emailPetani'],
                                  docIdProduct: document['docIdProduct'],
                                  orderDate: document['orderDate'],
                                  imageFile: document['imageFile'],
                                  title: document['title'],
                                  price: document['price'],
                                  itemCount: document['itemCount'],
                                  totalPay: document['totalPay'],
                                  paymentFile: document['paymentFile'],
                                  ordersName: document['ordersName'],
                                  ordersPhoneNumber: document['ordersPhoneNumber'],
                                  ordersUsername: document['ordersUsername'])));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Container(
                        height: 100.0,
                        child: Center(
                          child: ListTile(
                            leading: Container(
                              width: 90.0,
                              height: 90.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "${document['imageFile']}"))),
                            ),
                            title: Text('${document['title']}'),
                            subtitle: Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp ',
                                        decimalDigits: 0)
                                    .format(int.parse(harga)),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}

class Detail extends StatefulWidget {
  final bool isChecked;
  final String userIdPetani;
  final String usernamePetani;
  final String namaLengkapPetani;
  final String nomorHpPetani;
  final String emailPetani;
  final String docIdProduct;
  final String orderDate;
  final String imageFile;
  final String title;
  final String price;
  final int itemCount;
  final String totalPay;
  final String? paymentFile;
  final String ordersName;
  final String ordersPhoneNumber;
  final String ordersUsername;

  const Detail(
      {Key? key,
      required this.isChecked,
      required this.docIdProduct,
      required this.orderDate,
      required this.imageFile,
      required this.title,
      required this.price,
      required this.itemCount,
      required this.totalPay,
      required this.paymentFile,
      required this.ordersName,
      required this.ordersPhoneNumber,
      required this.ordersUsername, 
      required this.userIdPetani, 
      required this.usernamePetani, 
      required this.namaLengkapPetani, 
      required this.nomorHpPetani, 
      required this.emailPetani})
      : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final String title = "Detail Transaksi";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColor().colorCreamy,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(paddingDefault), child: detailTransaksi()),
      ),
    );
  }

  detailTransaksi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('${widget.orderDate}'),
          ]),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Telah Diterima', style: TextStyle(color: Colors.black54),),
              Text('Pesanan K-${widget.docIdProduct}')],
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
             Icon(Icons.account_circle_rounded, size: 48, color: Colors.black54,),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.namaLengkapPetani, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(widget.nomorHpPetani)
                ],
              )
            ],  
          ),
          Divider(thickness: 1,),
          SizedBox(height: 8,),
          Text("Pemesan",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nama", style: TextStyle(color: Colors.black54)),
              Text(widget.ordersName)
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nomor HP", style: TextStyle(color: Colors.black54)),
              Text(widget.ordersPhoneNumber)
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Username", style: TextStyle(color: Colors.black54)),
              Text(widget.ordersUsername)
            ],
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'Barang yang dibeli',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            height: 90.0,
            child: ListTile(
                // ignore: unnecessary_null_comparison
                leading: widget.imageFile == null
                    ? Text("")
                    : Container(
                        width: 90.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.imageFile))),
                      ),
                title: Text(widget.title,
                    style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(int.parse(widget.price)),
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500))),
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Ringkasan Belanja',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jumlah",
                style: TextStyle(color: Colors.black54),
              ),
              Text(widget.itemCount.toString(),
                  style: TextStyle(color: Colors.black54))
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Harga Pesanan", style: TextStyle(color: Colors.black54)),
              Text(
                  NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(int.parse(widget.price)),
                  style: TextStyle(color: Colors.black54))
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Text(
                  NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(int.parse(widget.totalPay)),
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Bukti Pembayaran", style: TextStyle(color: Colors.black54)),
              TextButton(onPressed: () => paymentImage(), child: Text("Lihat"))
            ],
          ),
        ],
      ),
    );
  }

  paymentImage() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ignore: unnecessary_null_comparison
                widget.paymentFile == null
                    ? Text('')
                    : Container(
                        height: 180.0,
                        width: 180.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("${widget.paymentFile}"))),
                      ),
                SizedBox(
                  height: 8.0,
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.black54,
                    ))
              ],
            ),
          );
        });
  }
}
