import 'package:careshareapp2/models/model_login.dart';
import 'package:careshareapp2/screens/forum/admin.dart';
import 'package:careshareapp2/screens/forum/listforum.dart';
import 'package:careshareapp2/utils/cek_session.dart';
import 'package:careshareapp2/utils/url.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  //key untuk form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;
  Future<ModelLogin?> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.post(Uri.parse('$url/login.php'), body: {
        "username": txtUsername.text,
        "password": txtPassword.text,
      });
      ModelLogin data = modelLoginFromJson(res.body);
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
        // session.saveSession(
        //     data.value ?? 0, data.id ?? "", data.username ?? "");

        isLoading = false;
        if (data.level == "0") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => ForumListScreen(
                        userId: data.id,
                      )),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => ForumListScreenadmin(
                        userId: data.id,
                      )),
              (route) => false);
        }
      } else {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Login Form'),
      ),
      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: txtUsername,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: txtPassword,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  obscureText: true,
                ),
                SizedBox(
                  height: 50,
                ),
                MaterialButton(
                  onPressed: () {
                    loginAccount();
                  },
                  color: Colors.orange,
                  textColor: Colors.white,
                  height: 45,
                  child: Text('Submit'),
                ),
                SizedBox(
                  height: 320,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
