import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/constants.dart';

final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

var userName;

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Pengguna'),
            centerTitle: true,
            backgroundColor: AppColor().colorCreamy),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: users,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error!');
                } else {
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return Card(
                      child: ExpansionTile(
                        leading: Icon(Icons.account_circle, color: Colors.grey, size: 36,),
                        title: Text("${data['nama lengkap']}"),
                        children: [
                          ListTile(
                            title: Text("${data['jenis pengguna']}", style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Column(
                              children: [
                                SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Nomor HP"),
                                    Text("${data['nomor HP']}", style: TextStyle(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Username"),
                                    Text("${data['nama pengguna']}",  style: TextStyle(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Password"),
                                    Text("${data['password']}",  style: TextStyle(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList());
                }
              }),
        ));
  }
}
