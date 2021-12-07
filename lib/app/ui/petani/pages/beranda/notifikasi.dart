import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/admin/pages/orders.dart';
import 'package:kakaoo/app/ui/constants.dart';

final Stream<QuerySnapshot> orders =
    FirebaseFirestore.instance.collection("pesanan").snapshots();
final FirebaseAuth auth = FirebaseAuth.instance;

class Notifikasi extends StatefulWidget {
  final String userId;
  const Notifikasi({Key? key, required this.userId}) : super(key: key);

  @override
  _NotifikasiState createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
        centerTitle: true,
        backgroundColor: AppColor().colorCreamy,
      ),
      body: listOrders(),
    );
  }

  listOrders() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: orders,
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
                  var harga = document['harga'];

                  if (widget.userId == document['userId']) {
                    return Card(
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
                                            "${document['file foto']}"))),
                              ),
                              title: Text('${document['judul']}'),
                              subtitle: Text(
                                  NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp ',
                                          decimalDigits: 0)
                                      .format(int.parse(harga)),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500)),
                              trailing: PopupMenuButton(
                                itemBuilder: (_) {
                                  return <PopupMenuEntry<String>>[]
                                    ..add(PopupMenuItem<String>(
                                        value: 'detail', child: Text('Detail')))
                                    ..add(PopupMenuItem<String>(
                                        value: 'hapus', child: Text('Hapus')));
                                },
                                onSelected: (String value) async {
                                  if (value == 'detail') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Detail(
                                                isChecked: isChecked,
                                                docIdProduct:
                                                    document['docIdProduct'],
                                                orderDate:
                                                    document['tanggal pesanan'],
                                                imageFile:
                                                    document['file foto'],
                                                title: document['judul'],
                                                price: document['harga'],
                                                itemCount: document['jumlah'],
                                                totalPay:
                                                    document['total bayar'],
                                                paymentFile:
                                                    document['bukti bayar'],
                                                ordersName:
                                                    document['nama lengkap'],
                                                ordersPhoneNumber:
                                                    document['nomor HP'],
                                                ordersUsername: document[
                                                    'nama pengguna'])));
                                  } else if (value == 'hapus') {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: Text('Konfirmasi'),
                                            content: Text(
                                                'Apa Kamu Ingin Menghapus Item Orders ${document['judul']} ?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Tidak')),
                                              TextButton(
                                                  onPressed: () async {
                                                    document.reference.delete();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Hapus'))
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Icon(Icons.more_vert),
                              )),
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
