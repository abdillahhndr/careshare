// ignore_for_file: prefer_const_constructors

import 'package:careshareapp2/models/model_historypayment.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListHistory extends StatefulWidget {
  const ListHistory({super.key});

  @override
  State<ListHistory> createState() => _ListHistoryState();
}

class _ListHistoryState extends State<ListHistory> {
  // TextEditingController txtcari = TextEditingController();
  bool isLoading = false;
  late List<Datum> _allProducts = [];
  // late List<Datum> _searchResult = [];
  String? id, username;
  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      print('id $id');
    });
  }

  Future<List<Datum>?> getProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res =
          await http.post(Uri.parse('$url/paymenthistory.php'), body: {
        "id_user": id,
      });
      List<Datum> data = modelListHistoryPaymentFromJson(res.body).data;
      setState(() {
        _allProducts = data;
        // _searchResult = data;
      });
    } catch (e) {
      setState(() {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Anda belum melakukan transaksi apapun')));
      });
    }
  }

  @override
  void initState() {
    // getProduct();
    getSession().then((value) => getProduct());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xff95D2E6),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text('History',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _allProducts.length,
                      itemBuilder: (context, index) {
                        Datum? data = _allProducts[index];

                        return ProductItem(
                          data: data,
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

class ProductItem extends StatelessWidget {
  final Datum data;

  final priceFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');
  ProductItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(width: 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(data!.createdAt),
                      // data!.createdAt.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Order ID: ${data!.id}',
                      // data!.createdAt.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      priceFormatter.format(double.parse(data!.price)),

                      // priceFormatter.format(double.parse(data!.amount)),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              if (data!.status == "pending")
                Text(
                  'Pending',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              if (data!.status == "success")
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Success',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
