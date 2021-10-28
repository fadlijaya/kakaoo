import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/akun.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');

final Stream<QuerySnapshot> tengkulak =
    FirebaseFirestore.instance.collection('tengkulak').snapshots();

class Tengkulak extends StatefulWidget {
  const Tengkulak({Key? key}) : super(key: key);

  @override
  _TengkulakState createState() => _TengkulakState();
}

class _TengkulakState extends State<Tengkulak> {
  final String title = "Tengkulak";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: usersTengkulak(),
    );
  }

  usersTengkulak() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: tengkulak,
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
                  child: ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        size: 60.0,
                      ),
                      title: Text('${document['nama lengkap']}'),
                      subtitle: Text('${document['email']}',
                          style: TextStyle(color: Colors.black54)),
                      trailing: PopupMenuButton(
                        itemBuilder: (_) {
                          return <PopupMenuEntry<String>>[]
                            /*..add(PopupMenuItem<String>(
                                value: 'detail', child: Text('Detail')))*/
                            ..add(PopupMenuItem<String>(
                                value: 'hapus', child: Text('Hapus')));
                        },
                        onSelected: (String value) async {
                          if (value == 'detail') {
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
                                            await deleteUser();
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
                );
              }).toList(),
            );
          }),
    );
  }

  Future<void> deleteUser() {
    return users
        .doc(auth.currentUser!.uid)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
