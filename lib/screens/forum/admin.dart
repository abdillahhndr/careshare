import 'package:careshareapp2/screens/forum/detailforum.dart';
import 'package:careshareapp2/screens/loginscreen.dart';
import 'package:careshareapp2/screens/mentor/listmentor.dart';
import 'package:careshareapp2/screens/mentor/listpelangganadmin.dart';
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
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Color(0xff95D2E6),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIconColor: Color(0xff5B4E3B),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(Icons.search, size: 20),
                      ),
                      hintText: "Search",
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                )
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
                          MaterialPageRoute(builder: (context) => PageLogin()),
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
