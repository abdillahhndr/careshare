import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Sesuaikan dengan import yang benar untuk halaman login jika diperlukan

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  String? id, username, email, address;

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      email = pref.getString("email") ?? '';
      address = pref.getString("address") ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getSession();
  }

  void clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear(); // Clear all shared preferences data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight - 8),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(255, 214, 244, 245),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen()), // Ganti dengan halaman login yang sesuai
                  (route) => false,
                );
              },
              color: Colors.black,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/vector.png",
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/account.png",
                        width: 146,
                        height: 146,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Hi ,${username ?? ''}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 45),
            _buildInfoItem("Name", username ?? ''),
            SizedBox(height: 5),
            _buildInfoItem("Email", email ?? ''),
            SizedBox(height: 5),
            _buildInfoItem("Phone Number", address ?? ''),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFD4F3F4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
