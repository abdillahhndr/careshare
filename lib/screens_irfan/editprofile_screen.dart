import 'package:careshareapp2/models/model_edituser.dart';
import 'package:careshareapp2/screens_irfan/navbar.dart';
import 'package:careshareapp2/utils/cek_session.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  String? id, username, email, address;

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      email = pref.getString("email") ?? '';
      address = pref.getString("address") ?? '';
    });
  }

  Future<ModelEditUser?> registerAccount() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res =
          await http.post(Uri.parse('$url/updateUser.php'), body: {
        "id": '$id',
        "username": txtUsername.text,
        "email": txtEmail.text,
        "address": txtAddress.text,
      });
      ModelEditUser data = modelEditUserFromJson(res.body);
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          session.saveSession(data.value ?? 0, data.id ?? "",
              data.username ?? "", data.email ?? "", data.address ?? "");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Navbar(
                      index: 4,
                    )));
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
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 214, 244, 245),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Edit profile',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 214, 244, 245),
      ),
      body: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: keyForm,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                TextFormField(
                  controller: txtUsername,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  decoration: InputDecoration(
                    labelText: 'username',
                    hintText: username,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color:
                              Color(0xFFD4F3F4)), // Color and width of border
                    ),
                    filled: true,
                    fillColor:
                        Color.fromRGBO(212, 243, 244, 0.5), // Background color
                    hintStyle:
                        TextStyle(color: Color.fromARGB(221, 116, 114, 114)),
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: txtEmail,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  decoration: InputDecoration(
                    labelText: 'email',
                    hintText: email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color:
                              Color(0xFFD4F3F4)), // Color and width of border
                    ),
                    filled: true,
                    fillColor:
                        Color.fromRGBO(212, 243, 244, 0.5), // Background color
                    hintStyle:
                        TextStyle(color: Color.fromARGB(221, 116, 114, 114)),
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: txtAddress,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  decoration: InputDecoration(
                    labelText: 'phone number',
                    hintText: address,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color:
                              Color(0xFFD4F3F4)), // Color and width of border
                    ),
                    filled: true,
                    fillColor:
                        Color.fromRGBO(212, 243, 244, 0.5), // Background color
                    hintStyle:
                        TextStyle(color: Color.fromARGB(221, 116, 114, 114)),
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 40),
                Center(
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
                      if (keyForm.currentState!.validate()) {
                        registerAccount();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Silakan isi data")),
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
