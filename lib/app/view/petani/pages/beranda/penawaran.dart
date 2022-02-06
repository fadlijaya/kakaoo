import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/utils/constants.dart';

final Stream<QuerySnapshot> offer = FirebaseFirestore.instance.collection("penawaran").snapshots();
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class Penawaran extends StatefulWidget {
  final String userId;
  const Penawaran({Key? key, required this.userId}) : super(key: key);

  @override
  _PenawaranState createState() => _PenawaranState();
}

class _PenawaranState extends State<Penawaran> {
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
        title: Text('Penawaran'),
        centerTitle: true,
        backgroundColor: AppColor().colorCreamy,
      ),
      body: listOffer(),
    );
  }

  listOffer() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: offer,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error!'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('Belum Ada Data'),
              );
            } else {
              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                //String docIdProduct = document['docIdProduct'];
                String price = document['harga'];
                String priceOffer = document['penawaran harga'];
                String imageFile = document['imageFile'];

                if (widget.userId == document['userId']) {
                  return Card(
                  child: ListTile(
                    leading: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                          image:
                              DecorationImage(image: NetworkImage(imageFile))),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                            .format(int.parse(priceOffer)),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20.0)),
                      ],
                    ),
                    subtitle:  Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                            .format(int.parse(price)),),
                  ),
                );
                }

                return Container();
              }).toList());
            }
          }),
    );
  }
}
