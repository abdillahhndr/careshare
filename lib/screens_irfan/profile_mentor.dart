import 'package:careshareapp2/screens_irfan/editprofile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileMentor extends StatefulWidget {
  const ProfileMentor({Key? key}) : super(key: key);

  @override
  State<ProfileMentor> createState() => _ProfileMentorState();
}

class _ProfileMentorState extends State<ProfileMentor> {
  String? id, username, email, address, mentor;

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      email = pref.getString("email") ?? '';
      address = pref.getString("address") ?? '';
      mentor = pref.getString("mentor") ??
          'Mentor'; // Assuming mentor data is saved in shared preferences
    });
  }

  @override
  void initState() {
    super.initState();
    getSession();
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
              onPressed: () {},
              icon: Icon(Icons.settings),
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
                      'Hi, ${username ?? ''}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        mentor ?? 'Mentor',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 1,
                        ),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 85, vertical: 10),
                backgroundColor: Color(0xFFAAD7D9),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                minimumSize: Size(200, 40),
              ),
            ),
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
