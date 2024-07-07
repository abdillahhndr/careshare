import 'dart:convert';

import 'package:careshareapp2/models/model_konten.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Datum>?> _futureFavoriteKonten;
  List<Datum> _favoriteKontenList = [];
  String? username, id;

  @override
  void initState() {
    super.initState();
    _futureFavoriteKonten = getSession().then((value) => getFavoriteKonten());
    // getSession().then((value) => getFavoriteKonten());
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username") ??
          ''; // Mengatasi nilai null dengan nilai default
      id = pref.getString("id") ??
          ''; // Mengatasi nilai null dengan nilai default
    });
  }

  Future<List<Datum>?> getFavoriteKonten() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? idUser =
          pref.getString("id"); // Mengizinkan idUser untuk bisa null

      if (idUser == null) {
        throw Exception(
            'User ID is null'); // Menangani kasus dimana idUser adalah null
      }

      var url1 = Uri.parse('$url/getfav.php?id_user=$id');
      http.Response res = await http.get(url1);

      if (res.statusCode == 200) {
        var jsonResponse = json.decode(res.body);

        if (jsonResponse['isSuccess']) {
          List<Datum> favoriteKonten = [];

          for (var item in jsonResponse['data']) {
            Datum konten = Datum.fromJson(item);
            favoriteKonten.add(konten);
          }

          return favoriteKonten;
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Failed to load favorite contents');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Favorite Konten',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFAAD7D9),
      ),
      body: FutureBuilder(
        future: _futureFavoriteKonten,
        builder: (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            _favoriteKontenList = snapshot.data!;
            return ListView.builder(
              itemCount: _favoriteKontenList.length,
              itemBuilder: (context, index) {
                Datum konten = _favoriteKontenList[index];
                String imageUrl =
                    '$url/gambar_konten/${konten.gambarKonten ?? ''}'; // Mengatasi kasus null untuk gambarKonten

                return Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    child: Card(
                      color: Color(0xFFDDF5F6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          onBackgroundImageError: (exception, stackTrace) {
                            // Menangani kesalahan saat memuat gambar
                          },
                          radius: 30,
                        ),
                        title: Text(
                          konten.judul,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1E4F51),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          konten.isiKonten,
                          maxLines: 2,
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Tidak ada konten favorit.'));
          }
        },
      ),
    );
  }
}
