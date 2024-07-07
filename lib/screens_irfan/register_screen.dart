import 'dart:convert';
import 'package:careshareapp2/models/otp_response.dart';
import 'package:careshareapp2/screens_irfan/login_screen.dart';
import 'package:careshareapp2/screens_irfan/otpverification_screen.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:careshareapp2/widget/text.form.global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> registerUser() async {
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String address = addressController.text;

    final registerUrl = Uri.parse('$url/register.php');
    final otpUrl = Uri.parse('$url/otp_send.php');

    try {
      final response = await http.post(
        registerUrl,
        body: {
          'username': username,
          'password': password,
          'email': email,
          'address': address,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['value'] == 1) {
          final otpResponse = await http.post(
            otpUrl,
            body: {'email': email},
          );

          if (otpResponse.statusCode == 200) {
            final otpData = OtpResponse.fromJson(json.decode(otpResponse.body));

            if (otpData.value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(email: email),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(otpData.message)),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Failed to send OTP: ${otpResponse.statusCode}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/logo.png'),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'CareShare',
                      style: TextStyle(
                        color: Color.fromARGB(255, 30, 79, 81),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const SizedBox(height: 15),
                  TextFormGlobal(
                    controller: usernameController,
                    text: 'Username',
                    obscure: false,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFormGlobal(
                    controller: emailController,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextFormGlobal(
                    controller: addressController,
                    text: 'Phone Number',
                    obscure: false,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFormGlobal(
                    controller: passwordController,
                    text: 'Password',
                    textInputType: TextInputType.text,
                    obscure: true,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      height: 49,
                      width: 283,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            registerUser();
                          }
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
                          'Sign Up',
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Already have an Account? SIGN IN',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
