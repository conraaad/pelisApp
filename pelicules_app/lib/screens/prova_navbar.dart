
import 'package:flutter/material.dart';

class ProvaNavBar extends StatefulWidget {
   
  const ProvaNavBar({Key? key}) : super(key: key);

  @override
  State<ProvaNavBar> createState() => _ProvaNavBarState();
}

class _ProvaNavBarState extends State<ProvaNavBar> {
  int _currentIndex = 0;
  final List<String> titles = ['Home', 'Saved'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prova Navbar'),
      ),
      body: Center(
         child: Text(titles[_currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_rounded, size: 35), label: 'Saved'),
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          setState(() {});
        },
      ),
    );
  }
}