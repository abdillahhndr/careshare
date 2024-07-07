import 'package:careshareapp2/screens_irfan/splash_screen.dart';
import 'package:flutter/material.dart';

class ButtonGlobal extends StatelessWidget {
  const ButtonGlobal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 365,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 41, 83, 154),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Text(
          'Masuk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
