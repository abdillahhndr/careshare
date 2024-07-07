import 'dart:convert';
import 'package:careshareapp2/models/model_forget.dart';
import 'package:careshareapp2/screens_irfan/password_success.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  final int? userId;

  ForgotPasswordScreen({required this.userId});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  String _message = '';
  bool isLoading = false;

  Future<void> changePassword(String newPassword) async {
    final changePasswordUrl = '$url/resetPassword.php';

    final changePasswordResponse = await http.post(
      Uri.parse(changePasswordUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': widget.userId, 'new_password': newPassword}),
    );

    if (changePasswordResponse.statusCode == 200) {
      final changePasswordData = jsonDecode(changePasswordResponse.body);
      setState(() {
        _message = changePasswordData['message'];
      });
    } else {
      setState(() {
        _message = 'Failed to change password: ${changePasswordResponse.body}';
      });
    }
  }

  Future<ModelForgotPass?> registerAccount() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.post(
        Uri.parse('$url/resetPassword.php'),
        body: {
          "id": widget.userId.toString(),
          "password": _newPasswordController.text,
        },
      );
      ModelForgotPass data = modelForgotPassFromJson(res.body);
      if (data.value == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordSuccess()),
        );
      } else if (data.value == 2) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
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
  void initState() {
    print(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Enter New Password',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 214, 244, 245),
      ),
      backgroundColor: Color.fromARGB(255, 214, 244, 245),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/forgot.png'),
                    height: 130,
                    width: 130,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Enter your new password',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'new password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 30, 79, 81),
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    height: 49,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        registerAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 28.3, vertical: 4.9),
                        backgroundColor: Color(0xFFAAD7D9),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
