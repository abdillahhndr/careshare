import 'dart:convert';

import 'package:careshareapp2/models/model_konten.dart';
import 'package:careshareapp2/screens/forum/listforum.dart';
import 'package:careshareapp2/screens_irfan/konten_detail_screen.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KontenScreen extends StatefulWidget {
  const KontenScreen({Key? key});

  @override
  State<KontenScreen> createState() => _KontenScreenState();
}

class _KontenScreenState extends State<KontenScreen> {
  TextEditingController txtcari = TextEditingController();
  late Future<List<Datum>?> _futureKonten;
  late List<Datum> _kontenList = [];
  late List<Datum> _originalKontenList = [];
  String? username, id;

  @override
  void initState() {
    super.initState();
    _futureKonten = getKonten();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username") ?? '';
      id = pref.getString("id") ?? '';
    });
  }

  Future<List<Datum>?> getKonten() async {
    try {
      http.Response res = await http.get(Uri.parse('$url/getKonten.php'));
      return modelKontenFromJson(res.body).data;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("belum ada data")));
      return null;
    }
  }

  Future<void> addToFavorite(String idKonten) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String idUser = pref.getString("id") ??
        ''; // Assuming you have id_user stored in SharedPreferences

    var url1 = Uri.parse('$url/addfav.php');
    var response = await http.post(url1, body: {
      'id_user': idUser,
      'id_konten': idKonten,
    });

    if (response.statusCode == 200) {
      try {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['value'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Konten berhasil ditambahkan ke favorit')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menambahkan konten ke favorit')));
        }
      } catch (e) {
        print('Error parsing JSON: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Terjadi kesalahan saat menambahkan favorit')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Terjadi kesalahan saat menambahkan favorit')));
    }
  }

  void _searchKonten(String query) {
    setState(() {
      if (_originalKontenList.isEmpty) {
        _originalKontenList.addAll(_kontenList);
      }

      if (query.isEmpty) {
        _kontenList.clear();
        _kontenList.addAll(_originalKontenList);
      } else {
        _kontenList.clear();
        _kontenList.addAll(_originalKontenList.where((konten) =>
            konten.judul!.toLowerCase().contains(query.toLowerCase())));
      }
    });
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForumListScreen(
                          userId: id ?? '',
                        )),
              );
            },
            icon: Icon(Icons.chat),
            color: Colors.black,
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/home.png', // Path to your image
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: TextField(
                    onChanged: _searchKonten,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: _futureKonten,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 41, 83, 154)));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  _kontenList = snapshot.data!;
                  return ListView.builder(
                    itemCount: _kontenList.length,
                    itemBuilder: (context, index) {
                      Datum konten = _kontenList[index];
                      String imageUrl =
                          '$url/gambar_konten/${konten.gambarKonten}';

                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      KontenDetailScreen(konten)),
                            );
                          },
                          child: Card(
                            color: Color(0xFFDDF5F6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(imageUrl),
                                onBackgroundImageError:
                                    (exception, stackTrace) {
                                  // Handle image loading error
                                },
                                radius: 30,
                              ),
                              title: Text(
                                '${konten.judul}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1E4F51),
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${konten.isiKonten}',
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.favorite),
                                onPressed: () {
                                  addToFavorite(konten.id);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Tidak ada data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
