import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/constants.dart';
import 'package:kakaoo/app/ui/petani/pages/akun/akun.dart';
import 'package:kakaoo/app/ui/petani/pages/beranda/kakao.dart';
import 'package:kakaoo/app/ui/petani/pages/jual.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Categories(),
    );
  }
}

class Categories extends StatefulWidget {
  const Categories({
    Key? key,
  }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int _currentIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    _children.add(Kakao());
    _children.add(Akun());
    super.initState();
  }

  void _onItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTap,
          selectedItemColor: AppColor().colorChocolate,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: 'Akun Saya'),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => bottomSheetJual(),
        backgroundColor: AppColor().colorCreamy,
        child: Icon(
          Icons.sell,
          color: AppColor().colorChocolate,
        ),
      ),
    );
  }

  bottomSheetJual() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 120,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Jual(
                                isEdit: false,
                                coordinate: GeoPoint(0, 0),
                              ))),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        color: AppColor().colorCreamy,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                        child: Text(
                      'Jual',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    )),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Center(
                      child: Text(
                    'Batal',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  )),
                ),
              ],
            ),
          );
        });
  }
}
