import 'package:careshareapp2/screens_irfan/login_screen.dart';
import 'package:careshareapp2/screens_irfan/profile_screen.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController txtPassword = TextEditingController();
  String? id;

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
    });
  }

  Future<void> updatePassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res =
          await http.post(Uri.parse('$url/updatePassword.php'), body: {
        "id": '$id',
        "password": txtPassword.text,
      });
      if (res.statusCode == 200) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Password updated')));
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update password')));
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
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 214, 244, 245),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Form(
          key: keyForm,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                TextFormField(
                  controller: txtPassword,
                  obscureText: true,
                  validator: (val) {
                    return val!.isEmpty ? "Password cannot be empty" : null;
                  },
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    filled: true,
                    fillColor: Color.fromRGBO(
                        212, 243, 244, 0.5), // Warna D4F3F4 dengan opacity 50%
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Color(0xFFD4F3F4),
                          width: 2), // Menambah border
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Menambah border saat TextField mendapat fokus
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      // Menambah border saat terjadi error validasi
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 85, vertical: 10),
                      backgroundColor: Color(0xFFAAD7D9),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      minimumSize: Size(200, 40),
                    ),
                    onPressed: () {
                      if (keyForm.currentState?.validate() == true) {
                        updatePassword();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill in the password"),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
