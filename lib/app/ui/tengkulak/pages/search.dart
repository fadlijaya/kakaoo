import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/tengkulak/pages/detail.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child:
                Text("Istilah penelusuran harus lebih panjang dari dua huruf."),
          )
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('penjualan')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: CircularProgressIndicator())],
                  );
                } else if (snapshot.data!.docs.length == 0) {
                  return Column(
                    children: [Text("Tidak ada hasil yang ditemukan.")],
                  );
                } else {
                  return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                    var title = doc['judul'];

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detail(
                                    tengkulakAddress: '',
                                    docIdProduct: doc['docIdProduct'],
                                    userIdPetani: doc['userId'],
                                    typeUsers: doc['jenis pengguna'],
                                    fullname: doc['nama lengkap'],
                                    phoneNumber: doc['nomor HP'],
                                    location: doc['alamat'],
                                    unit: doc['satuan'],
                                    price: doc['harga'],
                                    stock: doc['stok'],
                                    title: doc['judul'],
                                    desc: doc['deskripsi'],
                                    coordinate: doc['posisi kordinat'],
                                    saleDate: doc['tanggal jual'],
                                    imageFile: doc['file foto'])));
                      },
                      title: Text("$title"),
                    );
                  }).toList());
                }
              }),
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
