import 'package:careshareapp2/screens_irfan/profile_mentor.dart';
import 'package:flutter/material.dart';

class NavBarMentor extends StatefulWidget {
  NavBarMentor({Key? key}) : super(key: key);

  @override
  _NavBarMentorState createState() => _NavBarMentorState();
}

class _NavBarMentorState extends State<NavBarMentor> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [ProfileMentor()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 41, 83, 154),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Galeri',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
