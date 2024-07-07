import 'dart:convert';

import 'package:careshareapp2/models/model_add.dart';
import 'package:careshareapp2/screens/forum/chatforum.dart';
import 'package:careshareapp2/utils/apiservice.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ForumDetailScreen extends StatefulWidget {
  final int forumId;
  final String userId;

  ForumDetailScreen({required this.forumId, required this.userId});

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  String id = "", username = "", address = "";
  bool isLoading = false;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
    });
  }

  Future<void> showDeleteConfirmationDialog(Function deleteFunction) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Anda yakin ingin keluar dari forum ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya, Keluar'),
              onPressed: () {
                deleteFunction();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> delete(int idf, String idu) async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res =
          await http.post(Uri.parse('$url/keluarforum.php'), body: {
        "forum_id": idf.toString(),
        "user_id": idu,
      });
      //cek kondisi (ini berdasarkan value respon api
      //value 2 (email sudah terdaftar),1 (berhasil),dan 0 (gagal)
      if (res.statusCode == 200) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Anda Telah Keluar')));
          setState(() {});
        });
      } else {}
    } catch (e) {
      //munculkan error
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Future<ModelAdd?> joinforum(int idf, String idu) async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res =
          await http.post(Uri.parse('$url/joinforum.php'), body: {
        "forum_id": idf.toString(),
        "user_id": idu,
      });
      ModelAdd data = modelAddFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value 2 (email sudah terdaftar),1 (berhasil),dan 0 (gagal)
      if (data.isSuccess == true) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
          setState(() {});
        });
      } else if (data.isSuccess == false) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
          setState(() {
            // serverMessage = data.message;
          });
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
          setState(() {
            // serverMessage = data.message;
          });
        });
      }
    } catch (e) {
      //munculkan error
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // getProduct();
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          ),
          child: AppBar(
            backgroundColor: Color(0xffAAD7D9),
            leading: Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back))),
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Detail Forum',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),

      // AppBar(
      //   title: Text('Detail Forum'),
      //   backgroundColor: Color(0xff95D2E6),
      // ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Provider.of<ApiService>(context, listen: false)
            .getForumDetail(widget.forumId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final forum = snapshot.data;
            final users = forum?['users'] ?? [];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Image.network("$url/images/${forum?['image_forum']}"),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('${forum?['description']}'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Daftar Nama: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          color: Color(0xffD4F3F4),
                          child: ListTile(
                            title: Text(user['username']),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (users.any((user) => user['username'] == username))
                      Container(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumChatScreen(
                                  forumId: widget.forumId,
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color(0xFF92C7CF), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            elevation: 0, // Shadow depth
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                          icon: Icon(
                            Icons.message,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            'Go to Chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // ElevatedButton(
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ForumChatScreen(
                    //         forumId: widget.forumId,
                    //         userId: widget.userId,
                    //       ),
                    //     ),
                    //   );
                    // },
                    //   child: Text('Go to Chat'),
                    // ),
                    if (users.any((user) => user['username'] == username))
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          showDeleteConfirmationDialog(() {
                            delete(widget.forumId, widget.userId);
                          });
                        },
                        child: Text(
                          'Keluar dari forum',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (users.every((user) => user['username'] != username))
                      Container(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            joinforum(widget.forumId, widget.userId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color(0xFF92C7CF), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            elevation: 0, // Shadow depth
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                          icon: Icon(
                            Icons.message,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            'Join Chat Group',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
