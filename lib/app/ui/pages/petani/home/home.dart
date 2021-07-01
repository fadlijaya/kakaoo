import 'package:flutter/material.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';
import 'package:kakaoo/app/ui/pages/petani/home/akun.dart';
import 'package:kakaoo/app/ui/pages/petani/home/beranda.dart';
import 'package:kakaoo/app/ui/pages/petani/home/jual.dart';

class Home extends StatefulWidget {
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
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int _currentIndex = 0;
  List<Widget> _children = [Beranda(), Jual(), Akun()];

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
                icon: Icon(Icons.add_circle_rounded), label: 'Jual'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: 'Akun Saya'),
          ]),
    );
  }
}
