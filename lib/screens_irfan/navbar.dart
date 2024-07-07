import 'package:careshareapp2/screens/mentor/listmentor.dart';
import 'package:careshareapp2/screens/transactions/transactionlist.dart';
import 'package:careshareapp2/screens_irfan/favorite_screen.dart';
import 'package:careshareapp2/screens_irfan/konten_screen.dart';
import 'package:careshareapp2/screens_irfan/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navbar extends StatefulWidget {
  final int index;
  const Navbar({
    this.index = 0,
    super.key,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    KontenScreen(),
    MentorListScreen(),
    FavoriteScreen(),
    ListHistory(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedIndex = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: Container(
          color: Color(0xFFAAD7D9), // Ubah warna latar belakang
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: GNav(
              gap: 8,
              selectedIndex: _selectedIndex,
              onTabChange: _navigateBottomBar,
              padding: EdgeInsets.all(7),
              backgroundColor:
                  Color(0xFFAAD7D9), // Sesuaikan dengan warna latar belakang
              color: Colors.black, // Warna ikon
              activeColor: Colors.black, // Warna ikon aktif
              tabBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: '', // Hapus teks dengan mengatur nilai string kosong
                ),
                GButton(
                  icon: Icons.group,
                  text: '', // Hapus teks dengan mengatur nilai string kosong
                ),
                GButton(
                  icon: Icons.favorite,
                  text: '', // Hapus teks dengan mengatur nilai string kosong
                ),
                GButton(
                  icon: Icons.monetization_on,
                  text: '', // Hapus teks dengan mengatur nilai string kosong
                ),
                GButton(
                  icon: Icons.person_2_rounded,
                  text: '', // Hapus teks dengan mengatur nilai string kosong
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
