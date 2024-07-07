import 'package:careshareapp2/screens_irfan/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterSuccess extends StatefulWidget {
  @override
  _RegisterSuccessState createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/rs.png',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Text(
                  'Your Account has been Verified Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(250, 50),
                    backgroundColor: Color(0xFFAAD7D9),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ],
      ),
    );
  }
}
