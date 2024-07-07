import 'dart:async';
import 'dart:convert';

import 'package:careshareapp2/models/model_add.dart';
import 'package:careshareapp2/screens/mentor/listmentor.dart';
import 'package:careshareapp2/screens/mentor/noti.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// int id = 0;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
// final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
//     StreamController<ReceivedNotification>.broadcast();

class SuccessPage extends StatefulWidget {
  final int? orderId;
  const SuccessPage(this.orderId, {super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  bool isLoading = false;
  String? id, username;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      // print('id $id');
    });
  }

  String baseUrl = '$url';
  Future<void> deleteData(String? id, int? orderid) async {
    final url = Uri.parse('$baseUrl/success.php');
    final Map<String, dynamic> data = {'id_user': id, 'order_id': orderid};

    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'success') {
          print('Data deleted successfully!');
        } else {
          print('Failed to delete data: ${decodedResponse['message']}');
        }
      } else {
        print('Error deleting data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'ecommerce1', 'channel_name',
        icon: '@mipmap/ic_launcher',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Title',
      'Notification Body',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<ModelAdd?> update() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/success.php'),
          body: {"order_id": widget.orderId.toString(), "id_user": id});
      ModelAdd data = modelAddFromJson(res.body);
      if (data.isSuccess == true) {
        setState(() {
          isLoading = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MentorListScreen()));
        });
      } else if (data.isSuccess == false) {
        setState(() {
          isLoading = false;
          setState(() {});
        });
      } else {
        setState(() {
          isLoading = false;
          setState(() {});
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
    // update();
    Noti.init();
    super.initState();
    // Noti.initialize(flutterLocalNotificationsPlugin);
  }

  Noti noti = Noti();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset("assets/success.png"),
          Text("Success",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // _showNotificationWithTextAction();
                        // showNotification();
                        // noti.pushNotification
                        Noti.pushNotification(
                            title: '$username ', body: 'pembayaran berhasil');
                        // Noti.showBigTextNotification(
                        //     title: 'Payments',
                        //     body: 'Prosespembayaran berhasil',
                        //     fln: flutterLocalNotificationsPlugin);
                        update();
                      },
                      child: Text('Back to Home')),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
