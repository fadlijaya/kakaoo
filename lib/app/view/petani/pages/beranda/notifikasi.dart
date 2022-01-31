import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/view/admin/pages/orders.dart';
import 'package:kakaoo/app/utils/constants.dart';
import 'package:kakaoo/app/view/tengkulak/pages/register/register.dart';

final Stream<QuerySnapshot> orders = FirebaseFirestore.instance.collection("pesanan").snapshots();
final FirebaseAuth auth = FirebaseAuth.instance;

class Notifikasi extends StatefulWidget {
  final String userId;
  const Notifikasi({Key? key, required this.userId}) : super(key: key);

  @override
  _NotifikasiState createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  bool isChecked = false;
  bool isVisibleCheck = false;
  bool isVisibleUncheck = false;
  bool isVisibleConfirm = true;
  String? fullname;
  String? username;
  String? phoneNumber;
  String? email;

  Future<void> getUser() async {
    await firestore
        .collection('petani')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        setState(() {
          fullname = result.docs[0].data()['nama lengkap'];
          username = result.docs[0].data()['nama pengguna'];
          phoneNumber = result.docs[0].data()['nomor HP'];
          email = result.docs[0].data()['email'];
        });
      }
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

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
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error!'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('Belum Ada Data!'),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  String docIdProduct = document['docIdProduct'];
                  String orderDate = document['tanggal pesanan'];
                  String imageFile = document['file foto'];
                  String title = document['judul'];
                  String price = document['harga'];
                  int itemCount = document['jumlah'];
                  String totalPay = document['total bayar'];
                  String? paymentFile = document['bukti bayar'];
                  String ordersName = document['nama lengkap'];
                  String ordersPhoneNumber = document['nomor HP'];
                  String ordersUsername = document['nama pengguna'];

                  if (widget.userId == document['userId']) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detail(
                                    isChecked: isChecked,
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
                          height: 160.0,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Konfirmasi Pesanan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text('Pesanan',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      )),
                                  Text(
                                    ' $title',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Text('Dari pesanan ',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      )),
                                  Text(
                                    '$docIdProduct',
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer_sharp,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '$orderDate',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                      visible: isVisibleCheck,
                                      child: TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                          label: Text(
                                            'Diterima',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ))),
                                  Visibility(
                                    visible: isVisibleConfirm,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          String _docIdProduct = docIdProduct;
                                          await firestore
                                              .collection('transaksi')
                                              .add({
                                            'userIdPetani': widget.userId,
                                            'usernamePetani': username,
                                            'namaLengkapPetani': fullname,
                                            'nomorHpPetani': phoneNumber,
                                            'emailPetani': email,
                                            'docIdProduct': docIdProduct,
                                            'orderDate': orderDate,
                                            'imageFile': imageFile,
                                            'title': title,
                                            'price': price,
                                            'itemCount': itemCount,
                                            'totalPay': totalPay,
                                            'paymentFile': paymentFile,
                                            'ordersName': ordersName,
                                            'ordersPhoneNumber':
                                                ordersPhoneNumber,
                                            'ordersUsername': ordersUsername,
                                          });
                                          displayConfirm(_docIdProduct);
                                        },
                                        child:
                                            Center(child: Text('Konfirmasi')),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(AppColor()
                                                        .colorChocolate))),
                                  ),
                                  SizedBox(width: 12),
                                  Visibility(
                                      visible: isVisibleUncheck,
                                      child: TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          label: Text(
                                            'Ditolak',
                                            style: TextStyle(color: Colors.red),
                                          ))),
                                  Visibility(
                                    visible: isVisibleConfirm,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        String _docIdProduct = docIdProduct;
                                        await firestore
                                            .collection('penolakan')
                                            .add({
                                          'userIdPetani': widget.userId,
                                          'usernamePetani': username,
                                          'namaLengkapPetani': fullname,
                                          'nomorHpPetani': phoneNumber,
                                          'emailPetani': email,
                                          'docIdProduct': docIdProduct,
                                          'orderDate': orderDate,
                                          'imageFile': imageFile,
                                          'title': title,
                                          'price': price,
                                          'itemCount': itemCount,
                                          'totalPay': totalPay,
                                          'paymentFile': paymentFile,
                                          'ordersName': ordersName,
                                          'ordersPhoneNumber':
                                              ordersPhoneNumber,
                                          'ordersUsername': ordersUsername,
                                        });
                                        displayReject(_docIdProduct);
                                      },
                                      child: Center(
                                        child: Text('Tolak'),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey)),
                                    ),
                                  )
                                ],
                              )
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

  displayConfirm(String _docIdProduct) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text('Konfirmasi Berhasil'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      isVisibleCheck = !isVisibleCheck;
                      isVisibleConfirm = !isVisibleConfirm;
                    });
                    Navigator.pop(context);
                  },
                  child: Center(child: Text('OK')))
            ],
          );
        });
  }

  displayReject(String _docIdProduct) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text('Yakin ingin menolak pesanan ?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Batal')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isVisibleUncheck = !isVisibleUncheck;
                      isVisibleConfirm = !isVisibleConfirm;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Iya'))
            ],
          );
        });
  }
}
