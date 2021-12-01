import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/petani/pages/beranda/detail_kakao.dart';
import 'package:kakaoo/app/ui/petani/pages/beranda/item_slider.dart';
import 'package:kakaoo/app/ui/petani/pages/jual.dart';

final List itemList = [ItemSlider1(), ItemSliders2()];

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

int _currentIndex = 0;

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final User? userAuth = auth.currentUser;
var typeUsers;
var fullname;
var username;
var phoneNumber;
String? userId;

class Kakao extends StatefulWidget {
  const Kakao({
    Key? key,
  }) : super(key: key);
  @override
  _KakaoState createState() => _KakaoState();
}

class _KakaoState extends State<Kakao> {
  Future getUser() async {
    await firestore.collection('petani').where('userId').get().then((result) { 
      if (result.docs.length > 0) {
        setState(() {
          userId = result.docs[0].data()['userId'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [widgetListData()],
      )),
    );
  }

  widgetListData() {
    return Container(
        padding: EdgeInsets.only(top: paddingDefault, bottom: paddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Kakaoo',
                style: TextStyle(
                    color: AppColor().colorChocolate,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24.0),
            CarouselSlider(
                items: itemList
                    .map((item) => Builder(builder: (context) {
                          return Container(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: item),
                          );
                        }))
                    .toList(),
                options: CarouselOptions(
                    viewportFraction: 0.8,
                    aspectRatio: 2,
                    autoPlay: true,
                    initialPage: 2,
                    pauseAutoPlayOnTouch: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    onPageChanged: (index, reason) {
                      _currentIndex = index;
                    })),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map(itemList, (index, url) {
                  return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? AppColor().colorChocolate
                            : Colors.grey,
                      ));
                })),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: paddingDefault),
              child: Text(
                'Produk Saya',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: paddingDefault, horizontal: paddingDefault),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection('petani')
                            .doc(userId)
                            .collection('penjualan')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error!'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                'Belum Ada Data!',
                                style: TextStyle(color: Colors.black54),
                              ),
                            );
                          } else {
                            return ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                final int harga = int.parse(document['harga']);

                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailKakao(
                                              userName:
                                                  document['nama lengkap'],
                                              phoneNumber: document['nomor HP'],
                                              location: document['alamat'],
                                              price: document['harga'],
                                              stock: document['stok'],
                                              unit: document['satuan'],
                                              title: document['judul'],
                                              desc: document['deskripsi'],
                                              coordinate:
                                                  document['posisi kordinat'],
                                              saleDate:
                                                  document['tanggal jual'],
                                              imageFile:
                                                  document['file foto']))),
                                  child: Container(
                                      margin: EdgeInsets.only(bottom: 12.0),
                                      height: 220.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              color: Colors.black12)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: document['file foto'] !=
                                                      null
                                                  ? Container(
                                                      width: double.infinity,
                                                      height: 120.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8.0)),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  "${document['file foto']}"))),
                                                    )
                                                  : Container(
                                                      height: 120,
                                                      child: Center(
                                                          child: Text(
                                                        'Tidak Dapat Memuat Gambar, Coba lagi',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      )),
                                                    )),
                                          ListTile(
                                            isThreeLine: false,
                                            title: Text(
                                              '${document['judul']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            subtitle: Text(
                                                NumberFormat.currency(
                                                        locale: 'id',
                                                        symbol: 'Rp ',
                                                        decimalDigits: 0)
                                                    .format(harga)),
                                            trailing: PopupMenuButton(
                                              itemBuilder: (_) {
                                                return <
                                                    PopupMenuEntry<String>>[]
                                                  ..add(PopupMenuItem<String>(
                                                      value: 'edit',
                                                      child: Text('Edit')))
                                                  ..add(PopupMenuItem<String>(
                                                      value: 'hapus',
                                                      child: Text('Hapus')));
                                              },
                                              onSelected: (String value) async {
                                                if (value == 'edit') {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => Jual(
                                                              isEdit: true,
                                                              documentId:
                                                                  document
                                                                      .reference
                                                                      .id,
                                                              location:
                                                                  document[
                                                                      'alamat'],
                                                              unit: document[
                                                                  'satuan'],
                                                              price: document[
                                                                  'harga'],
                                                              stock: document[
                                                                  'stok'],
                                                              title: document[
                                                                  'judul'],
                                                              desc: document[
                                                                  'deskripsi'],
                                                              saleDate: document[
                                                                  'tanggal jual'],
                                                              imageFile: document[
                                                                  'file foto'])));
                                                } else if (value == 'hapus') {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Konfirmasi'),
                                                          content: Text(
                                                              'Apa Kamu Ingin Menghapus Produk ${document['judul']} ?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: Text(
                                                                    'Tidak',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54))),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  document
                                                                      .reference
                                                                      .delete();
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'penjualan')
                                                                      .doc(document
                                                                          .id)
                                                                      .delete();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    'Hapus'))
                                                          ],
                                                        );
                                                      });
                                                }
                                              },
                                              child: Icon(Icons.more_vert),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: paddingDefault,
                                                right: paddingDefault),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${document['tanggal jual']}',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              }).toList(),
                            );
                          }
                        })))
          ],
        ));
  }
}
