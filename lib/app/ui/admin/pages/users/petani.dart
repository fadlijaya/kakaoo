import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/admin/pages/users/detail.dart';
import 'package:kakaoo/app/ui/petani/pages/akun/akun.dart';

final Stream<QuerySnapshot> petani =
    FirebaseFirestore.instance.collection('petani').snapshots();

class Petani extends StatefulWidget {
  const Petani(User? user, {Key? key}) : super(key: key);

  @override
  _PetaniState createState() => _PetaniState();
}

class _PetaniState extends State<Petani> {
  final String title = "Petani";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: usersPetani(),
    );
  }

  usersPetani() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: petani,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Card(
                  child: Container(
                    height: 90.0,
                    child: Center(
                      child: ListTile(
                          leading: Icon(
                            Icons.account_circle,
                            size: 60.0,
                          ),
                          title: Text('${document['nama lengkap']}'),
                          subtitle: Text(
                            '${document['email']}',
                            style: TextStyle(color: Colors.black54),
                          ),
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
                                        builder: (context) => DetailUsers(
                                          typeUser: document['jenis pengguna'],
                                          userName: document['nama lengkap'],
                                          email: document['email'],
                                          phoneNumber: document['nomor HP'],
                                          address: document['alamat'],
                                          password: document['kata sandi'],
                                        )));
                              } else if (value == 'hapus') {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text('Konfirmasi'),
                                        content: Text(
                                            'Apa Kamu Ingin Menghapus Akun ${document['nama lengkap']} ?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Tidak')),
                                          TextButton(
                                              onPressed: () async {
                                                document.reference.delete();
                                                await auth.currentUser!
                                                    .delete();
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
              }).toList(),
            );
          }),
    );
  }
}
