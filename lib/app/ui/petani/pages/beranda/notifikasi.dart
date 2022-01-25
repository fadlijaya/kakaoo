import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/admin/pages/orders.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/tengkulak/register.dart';

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
  bool isVisibleDone = false;
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
                          height: 150.0,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$title',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text('x$itemCount'),
                                              ]),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  NumberFormat.currency(
                                                          locale: 'id',
                                                          symbol: 'Rp ',
                                                          decimalDigits: 0)
                                                      .format(
                                                          int.parse(totalPay)),
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                      visible: isVisibleDone,
                                      child: TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                          label: Text(
                                            'Selesai',
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
                                            'ordersPhoneNumber': ordersPhoneNumber,
                                            'ordersUsername': ordersUsername,
                                          });
                                           displaySuccess(_docIdProduct);
                                        },
                                        child: Center(
                                            child: Text('Konfirmasi')),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(AppColor()
                                                        .colorChocolate))),
                                  ),
                                  SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: () async {
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
                                            'ordersPhoneNumber': ordersPhoneNumber,
                                            'ordersUsername': ordersUsername,
                                          });
                                    }, 
                                    child: Center(child: Text('Tolak'),), 
                                    style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)
                                  ),)
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

  displaySuccess(String _docIdProduct) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/success.svg', width: 120),
                SizedBox(
                  height: 12,
                ),
                Text('Konfirmasi Berhasil')
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      isVisibleDone = !isVisibleDone;
                      isVisibleConfirm = !isVisibleConfirm;
                    });
                    Navigator.pop(context);
                  },
                  child: Center(child: Text('OK')))
            ],
          );
        });
  }
}
