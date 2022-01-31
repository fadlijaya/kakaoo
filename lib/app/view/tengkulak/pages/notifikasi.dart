import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/view/admin/pages/transaksi.dart';

final Stream<QuerySnapshot> transaksi = FirebaseFirestore.instance.collection("transaksi").snapshots();
final FirebaseAuth auth = FirebaseAuth.instance;

class Notifikasi extends StatefulWidget {
  final String username;
  const Notifikasi({Key? key, required this.username}) : super(key: key);

  @override
  _NotifikasiState createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Pesanan'),
        centerTitle: true,
      ),
      body: listOrders(),
    );
  }

  listOrders() {
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
                  String userIdPetani = document['userIdPetani'];
                  String usernamePetani = document['usernamePetani'];
                  String namaLengkapPetani = document['namaLengkapPetani'];
                  String nomorHpPetani = document['nomorHpPetani'];
                  String emailPetani = document['emailPetani'];
                  String docIdProduct = document['docIdProduct'];
                  String orderDate = document['orderDate'];
                  String imageFile = document['imageFile'];
                  String title = document['title'];
                  String price = document['price'];
                  int itemCount = document['itemCount'];
                  String totalPay = document['totalPay'];
                  String? paymentFile = document['paymentFile'];
                  String ordersName = document['ordersName'];
                  String ordersPhoneNumber = document['ordersPhoneNumber'];
                  String ordersUsername = document['ordersUsername'];

                  if (widget.username == ordersUsername) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detail(
                                    isChecked: isChecked,
                                    userIdPetani: userIdPetani,
                                    usernamePetani: usernamePetani,
                                    namaLengkapPetani: namaLengkapPetani,
                                    nomorHpPetani: nomorHpPetani,
                                    emailPetani: emailPetani,
                                    docIdProduct: docIdProduct,
                                    orderDate: orderDate,
                                    imageFile: imageFile,
                                    title: title,
                                    price: price,
                                    itemCount: itemCount,
                                    totalPay: totalPay,
                                    paymentFile: paymentFile,
                                    ordersName: ordersName,
                                    ordersPhoneNumber: ordersPhoneNumber,
                                    ordersUsername: ordersUsername)));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Container(
                          height: 100.0,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 90.0,
                                    height: 90.0,
                                    margin: EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage("$imageFile"))),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pesanan Dikonfirmasi',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text('Pesanan K-$docIdProduct', style: TextStyle(color: Colors.black54, fontSize: 12))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return Container();
                }).toList(),
              );
            }
          }),
    );
  }
}