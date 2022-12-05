import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:restorant/home/explore.dart';
import 'package:restorant/provider/jalan.dart';
import 'package:restorant/saved_page.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  List<Widget> tabItems = [
    const ExplorePage(),
    const jalankan(),
    const SavedScreen(),
    // SettingScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: tabItems[_selectedIndex],
      ),
      bottomNavigationBar: FlashyTabBar(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        height: 55,
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        iconSize: 20,
        showElevation: false, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            inactiveColor: Colors.blue,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.checklist),
            title: const Text('List'),
            inactiveColor: Colors.blue,
          ),

          FlashyTabBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text('Favorite'),
            inactiveColor: Colors.blue,
          ),
          // FlashyTabBarItem(
          //   icon: Icon(Icons.settings),
          //   title: Text('Settings'),
          // ),
        ],
      ),
    );
  }
}
