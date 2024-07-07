import 'dart:convert';

import 'package:careshareapp2/models/model_add.dart';
import 'package:careshareapp2/models/model_mentor.dart';
import 'package:careshareapp2/screens/mentor/checkoutmentor.dart';
import 'package:careshareapp2/screens/mentor/listmentor.dart';
import 'package:careshareapp2/screens/mentor/videocallscreen.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MentorDetailScreen extends StatefulWidget {
  final Datum? data;
  MentorDetailScreen(this.data, {super.key});

  @override
  State<MentorDetailScreen> createState() => _MentorDetailScreenState();
}

class _MentorDetailScreenState extends State<MentorDetailScreen> {
  bool isLoading = false;
  bool isSubscribed = false;
  bool hasRated = false;
  TextEditingController txtRate = TextEditingController();
  String? id, username, email;

  double? averageRating;

  @override
  void initState() {
    super.initState();
    getSession().then((_) {
      checkSubscription();
      checkRating();
    });
    getAverageRating();
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
    });
  }

  Future<void> checkRating() async {
    final url1 = Uri.parse('$url/checkrating.php');

    final body = jsonEncode({
      'user_id': id,
      'mentor_id': widget.data!.id,
    });

    try {
      final response = await http.post(
        url1,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          hasRated = responseData['isRated'];
        });
      } else {
        print('Failed to check rating: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate Mentor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              TextField(
                controller: txtRate,
                decoration: InputDecoration(
                  hintText: 'Enter your rating (1-5)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                rating();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getAverageRating() async {
    final url1 = Uri.parse('$url/getrating.php?mentor_id=${widget.data!.id}');

    try {
      final response = await http.get(url1);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          averageRating = responseData['average_rating'] != null
              ? double.parse(responseData['average_rating'])
              : null;
        });
      } else {
        print('Failed to get average rating: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> checkSubscription() async {
    final url1 = Uri.parse('$url/checksubs.php');

    final body = jsonEncode({
      'user_id': id,
      'mentor_id': widget.data!.id,
    });

    try {
      final response = await http.post(
        url1,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          isSubscribed = responseData['is_subscribed'];
        });
      } else {
        print('Failed to check subscription: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<ModelAdd?> rating() async {
    setState(() {
      isLoading = true;
    });

    try {
      http.Response res = await http.post(Uri.parse('$url/rating.php'), body: {
        "user_id": id,
        "mentor_id": widget.data!.id,
        "rating": txtRate.text,
      });
      ModelAdd data = modelAddFromJson(res.body);

      if (data.isSuccess == true) {
        setState(() {
          isLoading = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MentorListScreen()));
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data.message)));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
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
                'Detail Mentor',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color(0xffAAD7D9),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            widget.data!.keterangan,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (!isSubscribed)
                        if (averageRating != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                    '  🌟  ${averageRating!.toStringAsFixed(1)}'),
                              ),
                            ],
                          ),
                      if (!isSubscribed)
                        if (averageRating == null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('  🌟  Belum Ada'),
                              ),
                            ],
                          ),
                      if (isSubscribed)
                        if (averageRating != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Spacer(),
                              ElevatedButton(
                                onPressed: hasRated ? null : _showRatingDialog,
                                child: Text(
                                    '  🌟  ${averageRating!.toStringAsFixed(1)}'),
                              ),
                            ],
                          ),
                      if (isSubscribed)
                        if (averageRating == null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Spacer(),
                              ElevatedButton(
                                onPressed: hasRated ? null : _showRatingDialog,
                                child: Text('🌟 Belum Ada'),
                              ),
                            ],
                          ),
                      if (!isSubscribed)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffAAD7D9),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(
                                    widget.data!.id,
                                    widget.data!.price,
                                    widget.data!.nama,
                                    widget.data!.keterangan,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.payment,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Subscribe',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: isSubscribed
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallPageScreen(
                      callID: widget.data!.link,
                      uName: widget.data!.nama,
                    ),
                  ),
                );
              },
              child: Icon(Icons.call),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }
}
