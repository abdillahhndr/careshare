import 'package:careshareapp2/models/model_mentor.dart';
import 'package:careshareapp2/screens/mentor/detailmentor.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MentorListScreen extends StatefulWidget {
  const MentorListScreen({super.key});

  @override
  State<MentorListScreen> createState() => _MentorListScreenState();
}

class _MentorListScreenState extends State<MentorListScreen> {
  bool isLoading = false;
  TextEditingController txtcari = TextEditingController();

  late List<Datum> _allMentor = [];
  late List<Datum> _searchResult = [];
  String? id, username, email;
  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
    });
  }

  Future<List<Datum>?> getProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.get(Uri.parse('$url/getmentor.php'));
      List<Datum> data = modelListMentorFromJson(res.body).data ?? [];
      setState(() {
        _allMentor = data;
        _searchResult = data;
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('data belum ada')));
      });
    }
  }

  void _filterProduct(String query) {
    List<Datum> filteredBerita = _allMentor
        .where((product) =>
            product.nama!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _searchResult = filteredBerita;
    });
  }

  @override
  void initState() {
    super.initState();
    getProduct(); // Memuat daftar produk saat widget pertama kali dibuat
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
            height: 195,
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
                      controller: txtcari,
                      onChanged: _filterProduct,
                      decoration: InputDecoration(
                        hintText: 'Cari Artikel',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Color(0xffF6FDFD),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        // Adjust the height
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   height: 120,
          //   decoration: BoxDecoration(
          //       color: Color(0xff95D2E6),
          //       borderRadius: BorderRadius.only(
          //           bottomLeft: Radius.circular(25),
          //           bottomRight: Radius.circular(25))),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 10),
          //         child: TextFormField(
          //           onChanged: _filterProduct,
          //           controller: txtcari,
          //           decoration: InputDecoration(
          //             prefixIconColor: Color(0x95D2E6),
          //             contentPadding: EdgeInsets.symmetric(vertical: 0),
          //             prefixIcon: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 5),
          //               child: Icon(Icons.search, size: 20),
          //             ),
          //             hintText: "Search",
          //             hintStyle:
          //                 TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          //             border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(30),
          //                 borderSide: BorderSide.none),
          //             filled: true,
          //             fillColor: Colors.blue.shade100,
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 20,
          //       )
          //     ],
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text('All Mentors',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResult.length,
                      itemBuilder: (context, index) {
                        Datum data = _searchResult[index];

                        return Card(
                          color: Color(0xffDDF5F6),
                          child: ListTile(
                            title: Text(
                              data.nama,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            subtitle: Text(
                              data.keterangan,
                              maxLines: 2,
                            ),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MentorDetailScreen(
                                    data,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
