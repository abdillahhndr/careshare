import 'package:careshareapp2/models/model_konten.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KontenDetailScreen extends StatelessWidget {
  final Datum? data;
  const KontenDetailScreen(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD4F3F4),
      ),
      backgroundColor: Color(0xFFD4F3F4), // Set background color here
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '$url/gambar_konten/${data?.gambarKonten}',
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            title: Text(
              data?.judul ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF1E4F51), // Title color
              ),
            ),
            subtitle: Text(
              DateFormat().format(data?.tglKonten ?? DateTime.now()),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              data?.isiKonten ?? "",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
