import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/petani/home/akun.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final Stream<QuerySnapshot> _jual = FirebaseFirestore.instance
      .collection('petani')
      .doc(auth.currentUser!.uid)
      .collection('jual')
      .snapshots();

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
        padding: EdgeInsets.all(paddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beranda',
              style: TextStyle(
                  color: AppColor().colorChocolate,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 24.0,
            ),
            Text(
              'Iklan Saya',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 12.0,
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _jual,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text('Belum Ada Data!'),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Ada yang salah!'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text('Loading...'));
                      }

                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          return Container(
                              margin: EdgeInsets.only(bottom: 12.0),
                              height: 200.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.black12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 40.0,
                                    padding:
                                        EdgeInsets.only(left: paddingDefault),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0)),
                                      color: AppColor().colorCreamy,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Mulai : ${document['tanggal jual']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 12.0, left: 12.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 90.0,
                                          height: 90.0,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              '${document['file foto']}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12.0,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${document['judul']}',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    'Rp. ${document['harga']}/Liter'),
                                                SizedBox(
                                                  height: 32.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      size: 16.0,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        child: Text(
                                                          'Dilihat :',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: paddingDefault),
                                      // ignore: deprecated_member_use
                                      child: TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Hapus Iklan'),
                                                    content: Text(
                                                        'Anda akan menghapus iklan Anda'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Batal')),
                                                      TextButton(
                                                          onPressed: () {
                                                            document.reference
                                                                .delete();
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                          child: Text('Hapus')),
                                                    ],
                                                  );
                                                });
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.black12)))),
                                          child: Text(
                                            'Hapus',
                                            style: TextStyle(
                                                color:
                                                    AppColor().colorChocolate),
                                          ))),
                                ],
                              ));
                        }).toList(),
                      );
                    }))
          ],
        ));
  }
}
