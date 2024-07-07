// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
// import 'dart:ffi';

import 'package:careshareapp2/models/model_checkout.dart';
import 'package:careshareapp2/models/model_mentor.dart';
import 'package:careshareapp2/screens/mentor/paymentdetail.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  // final Datum? data;
  final String? mentorId;
  final String price;
  final String? namamentor;
  final String? descmentor;
  const CheckoutPage(
      this.mentorId, this.price, this.namamentor, this.descmentor,
      {super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isLoading = false;
  String? id, username, address;
  String? snap;
  final priceFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');
  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      // print(json.encode(widget.items.map((item) => item.toJson()).toList()));
      // print(id);
      // print(widget.total.toString());
      // print(address);
    });
  }

  Future<void> createSubscription(String? userId, String? mentorId,
      String? price, Map<String, dynamic> item) async {
    final url1 = Uri.parse('$url/payment.php'); // Replace with your actual URL

    // Construct the request body
    final body = jsonEncode({
      'user_id': userId,
      'item': item,
      'mentor_id': mentorId,
      'price': price
    });

    try {
      // Send the POST request
      final response = await http.post(
        url1,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Parse the response body
        final responseData = jsonDecode(response.body);

        // Handle the response data as needed
        final snapToken = responseData['snap_token'];
        final orderId = responseData['order_id'];

        print('Snap Token: $snapToken');
        print('Order ID: $orderId');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentDetail(
                      snapToken: snapToken,
                      orderId: orderId,
                    )));
      } else {
        // Handle errors
        print('Failed to create subscription: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error: $error');
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                'Checkout',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              widget.namamentor ?? "",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Container(
              child: Column(
                children: [
                  Text(widget.descmentor ?? ""),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'payment details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(priceFormatter.format(int.parse(widget.price))),
              ],
            ),
            Spacer(),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Define the item details
                  final item = {
                    'id': 1,
                    'name': 'Monthly Subscription',
                    'price': widget.price
                  };

                  // Call the createSubscription function
                  createSubscription(id, widget.mentorId, widget.price, item);
                },
                child: Text(
                  'Bayar',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffAAD7D9),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
