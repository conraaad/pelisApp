
import 'package:flutter/material.dart';
import 'package:pelicules_app/screens/screens.dart';
import 'package:pelicules_app/themes/app_theme.dart';

class ProvaNavBar extends StatefulWidget {
   
  const ProvaNavBar({Key? key}) : super(key: key);

  @override
  State<ProvaNavBar> createState() => _ProvaNavBarState();
}

class _ProvaNavBarState extends State<ProvaNavBar> {
  int _currentIndex = 0;
  final List<dynamic> navScreens = [const HomeScreen(), const WatchListScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navScreens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppTheme.mainColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: 'Home', ),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_rounded, size: 35), label: 'Saved'),
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          setState(() {});
        },
        elevation: 30,
      ),
    );
  }
}