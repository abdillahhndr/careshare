import 'package:careshareapp2/screens_irfan/forgotpassword_screen.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyEmailRequest {
  final String email;

  VerifyEmailRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

Future<int?> verifyEmail(String email) async {
  try {
    final url1 = Uri.parse('$url/verifyEmail.php');
    final response = await http.post(
      url1,
      body: jsonEncode(VerifyEmailRequest(email: email).toJson()),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['user_id'] != null) {
        return responseData['user_id'];
      } else {
        print('Error: User ID not found in response data');
        return null;
      }
    } else {
      print('Failed to verify email. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error verifying email: $e');
    return null;
  }
}

class VerifyEmail extends StatefulWidget {
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final TextEditingController _emailController = TextEditingController();
  int? _userId;

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text;
    final userId = await verifyEmail(email);
    setState(() {
      _userId = userId;
    });
    if (_userId != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email verified. User ID: $_userId')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotPasswordScreen(userId: _userId)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email verification failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Enter Email to Verify',
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
                    child: Image.asset('assets/verif.png'),
                    height: 130,
                    width: 130,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Enter your email to verify',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                      onPressed: _handleForgotPassword,
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
                        'Verify Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
