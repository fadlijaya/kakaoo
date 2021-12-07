import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kakaoo/app/ui/constants.dart';

final Stream<QuerySnapshot> product =
    FirebaseFirestore.instance.collection('penjualan').snapshots();

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  String title = 'Produk';

  Widget itemProduct = new StreamBuilder<QuerySnapshot>(
      stream: product,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return new Text('Error in receiving item product: ${snapshot.error}');
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Not connected to the Stream or null');

          case ConnectionState.waiting:
            return new Text('Awaiting for interaction');

          case ConnectionState.active:
            print("Stream has started but not finished");

            var totalProductCount = 0;
            List<DocumentSnapshot> itemProduct;

            if (snapshot.hasData) {
              itemProduct = snapshot.data!.docs;
              totalProductCount = itemProduct.length;

              if (totalProductCount > 0) {
                return new GridView.builder(
                    itemCount: totalProductCount,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: paddingDefault / 4,
                        crossAxisSpacing: paddingDefault / 4,
                        childAspectRatio: 0.75),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(itemProduct[index]
                                              ['file foto']))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(itemProduct[index]['judul'],
                                    style: TextStyle(color: Colors.black54)),
                              )
                            ],
                          ),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detail(
                                    docId: itemProduct[index].id,
                                    typeUsers: itemProduct[index]
                                        ['jenis pengguna'],
                                    userName: itemProduct[index]
                                        ['nama lengkap'],
                                    phoneNumber: itemProduct[index]['nomor HP'],
                                    location: itemProduct[index]['alamat'],
                                    title: itemProduct[index]['judul'],
                                    desc: itemProduct[index]['deskripsi'],
                                    price: itemProduct[index]['harga'],
                                    stock: itemProduct[index]['stok'],
                                    saleDate: itemProduct[index]
                                        ['tanggal jual'],
                                    coordinate: itemProduct[index]
                                        ['posisi kordinat'],
                                    imageFile: itemProduct[index]
                                        ['file foto']))),
                      );
                    });
              }
            }

            return new Center(
                child: Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                ),
                new Text(
                  "No Item product found.",
                )
              ],
            ));

          case ConnectionState.done:
            return new Text('Streaming is done');
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColor().colorCreamy,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [itemProduct],
          ),
        ),
      ),
    );
  }
}

class Detail extends StatefulWidget {
  final String docId;
  final String typeUsers;
  final String userName;
  final String phoneNumber;
  final String location;
  final String title;
  final String desc;
  final String price;
  final int stock;
  final String saleDate;
  final GeoPoint coordinate;
  final String imageFile;

  const Detail(
      {Key? key,
      required this.docId,
      required this.typeUsers,
      required this.userName,
      required this.phoneNumber,
      required this.location,
      required this.title,
      required this.desc,
      required this.price,
      required this.stock,
      required this.saleDate,
      required this.coordinate,
      required this.imageFile})
      : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail Produk"),
          centerTitle: true,
          backgroundColor: AppColor().colorCreamy,
        ),
        body: Container(
          child: detailProduct(),
        ));
  }

  detailProduct() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                child: Image.network(
                  widget.imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(paddingDefault),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Nama Produk"),
                        Text(
                          "${widget.title}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ]),
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Harga"),
                      Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                            .format(int.parse(widget.price)),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Stok"),
                      Text(
                        "${widget.stock.toString()}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Divider(thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Lokasi Produk"),
                      SizedBox(width: 54,),
                      Flexible(
                        child: Text(
                          "${widget.location}",
                          maxLines: 5,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  Divider(thickness: 1),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tanggal Jual"),
                        Text("${widget.saleDate}", style: TextStyle(fontWeight: FontWeight.w500))
                      ]),
                  Divider(thickness: 1),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Deskripsi"), 
                        SizedBox(width: 80,),
                        Flexible(child:  Text("${widget.desc}", 
                        maxLines: 8,
                        style: TextStyle(fontWeight: FontWeight.w500)))])
                        
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
