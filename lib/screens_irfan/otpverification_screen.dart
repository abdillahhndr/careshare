import 'package:careshareapp2/models/otp_response.dart';
import 'package:careshareapp2/screens_irfan/register_success.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> verifyOtp() async {
    final String email = widget.email;
    final String otp = otpController.text;

    final url1 = Uri.parse('$url/otp_verify.php');

    try {
      final response = await http.post(
        url1,
        body: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        try {
          OtpResponse data = otpResponseFromJson(response.body);

          if (data.value == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data.message)),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterSuccess()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data.message)),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid response format: ${response.body}'),
            ),
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Enter Verification Code',
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/otp.png'),
                      height: 130,
                      width: 130,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'We Have Sent OTP on Your Number',
                      style: TextStyle(
                        color: Color.fromARGB(255, 30, 79, 81),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'OTP',
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
                        vertical: 14,
                        horizontal: 18,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      height: 49,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            verifyOtp();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 28.3, vertical: 4.9),
                          backgroundColor: Color(0xFFAAD7D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Verify OTP',
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
      ),
    );
  }
}
