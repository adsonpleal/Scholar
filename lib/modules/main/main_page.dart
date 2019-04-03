import 'package:app_tcc/modules/agenda/agenda_page.dart';
import 'package:app_tcc/modules/home/home_page.dart';
import 'package:app_tcc/modules/profile/profile_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range), title: Text('Agenda')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Perfil')),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  _currentPage() {
    switch (_selectedIndex) {
      case 0:
        return HomePage();
      case 1:
        return AgendaPage();
      case 2:
        return ProfilePage();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
