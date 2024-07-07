import 'package:careshareapp2/screens/forum/detailforum.dart';
import 'package:careshareapp2/screens/loginscreen.dart';
import 'package:careshareapp2/screens/mentor/listmentor.dart';
import 'package:careshareapp2/screens/transactions/transactionlist.dart';
import 'package:careshareapp2/screens_irfan/login_screen.dart';
import 'package:careshareapp2/utils/apiservice.dart';
import 'package:careshareapp2/utils/cek_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumListScreen extends StatefulWidget {
  final String userId;

  ForumListScreen({required this.userId});

  @override
  State<ForumListScreen> createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  late TextEditingController _searchController;
  late String searchQuery = '';
  String? id, username, email;
  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Hi, ${username ?? ''}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFAAD7D9),
      ),
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
                        hintText: 'Cari Artikel',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
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
                    child: Icon(
                      Icons.logout,
                      color: Colors.red,
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MentorListScreen()));
                    },
                    child: Icon(Icons.people_sharp)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListHistory()));
                    },
                    child: Icon(Icons.payment)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            color: Color.fromARGB(255, 203, 242, 242),
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                forum['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
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
          ),
        ],
      ),
    );
  }
}
