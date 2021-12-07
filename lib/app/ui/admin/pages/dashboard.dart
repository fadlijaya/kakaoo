import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kakaoo/app/ui/admin/pages/transaksi.dart';
import 'package:kakaoo/app/ui/admin/pages/orders.dart';
import 'package:kakaoo/app/ui/admin/pages/product.dart';
import 'package:kakaoo/app/ui/admin/pages/profil.dart';
import 'package:kakaoo/app/ui/admin/pages/users.dart';
import 'package:kakaoo/app/ui/admin/utils/constant.dart';
import 'package:kakaoo/app/ui/constants.dart';

import '../../user_login.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

var userName;

final Stream<QuerySnapshot> product =
    FirebaseFirestore.instance.collection('penjualan').snapshots();
final Stream<QuerySnapshot> orders =
    FirebaseFirestore.instance.collection('pesanan').snapshots();
final Stream<QuerySnapshot> transaksi =
    FirebaseFirestore.instance.collection('pesanan').snapshots();
final Stream<QuerySnapshot> users = FirebaseFirestore.instance
    .collection('users')
    .snapshots();

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> with SingleTickerProviderStateMixin {
  String title = 'Dashboard';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    await firestore
          .collection('admin')
          .where('userId')
          .get()
          .then((result) {
        if (result.docs.length > 0) {
          setState(() {
            userName = result.docs[0].data()['nama lengkap'];
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          backgroundColor: AppColor().colorCreamy,
          actions: [
            PopupMenuButton(
              itemBuilder: (_) {
                return <PopupMenuEntry<String>>[]
                  ..add(PopupMenuItem<String>(
                      value: 'profil', child: Text('Profil')))
                  ..add(PopupMenuItem<String>(
                      value: 'log out', child: Text('Log out')));
              },
              onSelected: (String value) async {
                if (value == 'profil') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profil()));
                } else if (value == 'log out') {
                  logout();
                }
              },
            ),
          ],
        ),
        body: Container(
          child: Stack(
            children: [header(), gridData()],
          ),
        ));
  }

  logout() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text('Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Tidak',
                    style: TextStyle(color: Colors.black54),
                  )),
              TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => UserLogin()),
                        (route) => false);
                  },
                  child: Text('Ya'))
            ],
          );
        });
  }

  header() {
    return Container(
      padding: EdgeInsets.all(paddingDefault),
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24)),
          color: AppColor().colorCreamy),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Selamat Datang Admin",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          height: 4,
        ),
        Text("$userName",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white)),
      ]),
    );
  }

  gridData() {
    return Container(
        margin: EdgeInsets.only(top: 120),
        child: GridView.count(
          crossAxisCount: 2,
          children: [cardProduct(), cardOrders(), cardTransaksi(), cardUsers()],
        ));
  }

  cardProduct() {
    return StreamBuilder(
      stream: product,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error!');
        }

        var docProduct = snapshot.data!.docs.length;

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Product()));
          },
          child: Card(
            color: AppColorAdmin().card1,
            margin: EdgeInsets.only(
                left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: paddingDefault, left: paddingDefault),
                      child: Icon(Icons.sell, size: 40.0, color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  '${docProduct.toString()}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8,
                ),
                Text('Produk',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        );
      },
    );
  }

  cardOrders() {
    return StreamBuilder(
        stream: orders,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error!');
          }

          var docOrders = snapshot.data!.docs.length;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Orders()));
            },
            child: Card(
              color: AppColorAdmin().card2,
              margin: EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: paddingDefault, left: paddingDefault),
                        child: Icon(Icons.add_shopping_cart,
                            size: 40.0, color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    '${docOrders.toString()}', //dashboardModel.totalProduct.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Pesanan',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        });
  }

  cardTransaksi() {
    return StreamBuilder(
        stream: transaksi,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error!');
          }

          var docTransaksi = snapshot.data!.docs.length;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Transaksi()));
            },
            child: Card(
              color: AppColorAdmin().card3,
              margin: EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: paddingDefault, left: paddingDefault),
                        child:
                            Icon(Icons.check, size: 40.0, color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    '${docTransaksi.toString()}', //dashboardModel.totalProduct.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Transaksi',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        });
  }

  cardUsers() {
    return StreamBuilder(
      stream: users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error!');
        }

        var docUsers = snapshot.data!.docs.length;
        
        return GestureDetector(
          onTap: () {
             Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Users()));
          },
          child: Card(
            color: AppColorAdmin().card4,
            margin:
                EdgeInsets.only(left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
            elevation: 10.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: paddingDefault, left: paddingDefault),
                      child: Icon(Icons.people, size: 40.0, color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  '${docUsers.toString()}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8,
                ),
                Text('Pengguna',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        );
      },
    );
  }
}
