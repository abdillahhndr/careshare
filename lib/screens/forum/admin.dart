import 'package:careshareapp2/screens/forum/detailforum.dart';
import 'package:careshareapp2/screens/loginscreen.dart';
import 'package:careshareapp2/screens/mentor/listmentor.dart';
import 'package:careshareapp2/screens/mentor/listpelangganadmin.dart';
import 'package:careshareapp2/screens_irfan/login_screen.dart';
import 'package:careshareapp2/utils/apiservice.dart';
import 'package:careshareapp2/utils/cek_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForumListScreenadmin extends StatefulWidget {
  final String userId;

  ForumListScreenadmin({required this.userId});

  @override
  State<ForumListScreenadmin> createState() => _ForumListScreenadminState();
}

class _ForumListScreenadminState extends State<ForumListScreenadmin> {
  late TextEditingController _searchController;
  late String searchQuery = '';
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 185,
            child: Stack(
              children: [
                Image.asset(
                  'assets/forum.png', // Path to your image
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: -0, // Adjust this value to change the overlap
                  left: 10,
                  right: 10,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari Forum',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Color(0xffF6FDFD),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10), // Adjust the height
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      session.clearSession();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false);
                    });
                  },
                  child: Text("logout")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PelangganListScreen()));
                  },
                  child: Text("list pelanggan")),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future:
                  Provider.of<ApiService>(context, listen: false).getForums(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final forums = snapshot.data;
                  return ListView.builder(
                    itemCount: forums?.length ?? 0,
                    itemBuilder: (context, index) {
                      final forum = forums![index];
                      // Filter forum berdasarkan nama atau deskripsi
                      if (searchQuery.isEmpty ||
                          forum['name']
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          forum['description']
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase())) {
                        return Card(
                          child: ListTile(
                            title: Text(forum['name']),
                            subtitle: Text(forum['description']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForumDetailScreen(
                                    forumId: forum['id'],
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
