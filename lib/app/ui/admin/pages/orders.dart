import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/constants.dart';

final Stream<QuerySnapshot> orders =
    FirebaseFirestore.instance.collection("pesanan").snapshots();

final FirebaseAuth auth = FirebaseAuth.instance;

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final String title = "Pesanan";
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                                              imageFile: document['file foto'],
                                              title: document['judul'],
                                              price: document['harga'],
                                              itemCount: document['jumlah'],
                                              totalPay: document['total bayar'],
                                              paymentFile:
                                                  document['bukti bayar'],
                                              ordersName:
                                                  document['nama lengkap'],
                                              ordersPhoneNumber:
                                                  document['nomor HP'],
                                              ordersUsername: document['nama pengguna']
                                              )));
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
                }).toList(),
              );
            }
          }),
    );
  }
}

class Detail extends StatefulWidget {
  final bool isChecked;
  final String imageFile;
  final String title;
  final String price;
  final int itemCount;
  final String totalPay;
  final String? paymentFile;
  final String ordersName;
  final String ordersPhoneNumber;
  final String ordersUsername;

  const Detail(
      {Key? key,
      required this.isChecked,
      required this.imageFile,
      required this.title,
      required this.price,
      required this.itemCount,
      required this.totalPay,
      required this.paymentFile,
      required this.ordersName,
      required this.ordersPhoneNumber,
      required this.ordersUsername})
      : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final String title = "Detail Pesanan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColor().colorCreamy,
      ),
      body: Container(
          padding: EdgeInsets.all(paddingDefault), child: detailOrders()),
    );
  }

  detailOrders() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pemesan",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nama", style: TextStyle(color: Colors.black54)),
              Text(widget.ordersName)
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nomor HP", style: TextStyle(color: Colors.black54)),
              Text(widget.ordersPhoneNumber)
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Username", style: TextStyle(color: Colors.black54)),
              Text(widget.ordersUsername)
            ],
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'Barang yang dibeli',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            height: 90.0,
            child: ListTile(
                // ignore: unnecessary_null_comparison
                leading: widget.imageFile == null
                    ? Text("")
                    : Container(
                        width: 90.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.imageFile))),
                      ),
                title: Text(widget.title,
                    style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(int.parse(widget.price)),
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500))),
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Ringkasan Belanja',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jumlah",
                style: TextStyle(color: Colors.black54),
              ),
              Text(widget.itemCount.toString(),
                  style: TextStyle(color: Colors.black54))
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Harga Pesanan", style: TextStyle(color: Colors.black54)),
              Text(
                  NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(int.parse(widget.price)),
                  style: TextStyle(color: Colors.black54))
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Text(
                  NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(int.parse(widget.totalPay)),
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Bukti Pembayaran", style: TextStyle(color: Colors.black54)),
              TextButton(onPressed: () => paymentImage(), child: Text("Lihat"))
            ],
          ),
        ],
      ),
    );
  }

  paymentImage() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ignore: unnecessary_null_comparison
                widget.paymentFile == null
                    ? Text('')
                    : Container(
                        height: 180.0,
                        width: 180.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("${widget.paymentFile}"))),
                      ),
                SizedBox(
                  height: 8.0,
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.black54,
                    ))
              ],
            ),
          );
        });
  }
}
