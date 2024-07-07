import 'package:flutter/material.dart';

class TextFormGlobal extends StatelessWidget {
  const TextFormGlobal(
      {Key? key,
      required this.controller,
      required this.text,
      required this.textInputType,
      required this.obscure})
      : super(key: key);
  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 52,
        width: 309,
        padding: const EdgeInsets.only(top: 2, left: 15),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
            ),
          ],
          border: Border.all(
            color: Color.fromARGB(255, 30, 79, 81),
            width: 1.0,
          ),
        ),
        child: TextFormField(
          controller: controller,
          validator: (val) {
            return val!.isEmpty ? "Tidak boleh kosong" : null;
          },
          keyboardType: textInputType,
          obscureText: obscure,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: text,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(0),
            hintStyle: const TextStyle(
              height: 1,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
    );
  }
}
