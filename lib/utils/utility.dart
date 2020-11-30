import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/logo.jpg", height: 50),
  );
}

Widget appBarWithTitle(BuildContext context) {
  return AppBar(
    title: Icon(Icons.arrow_back, color: Colors.white,),
  );
}

InputDecoration textFieldInputDecoration(String hint) {
  return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
      enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)));
}

TextStyle simpleStyle() {
  return TextStyle(color: Colors.black, fontSize: 16);
}

TextStyle simpleButtonStyle() {
  return TextStyle(color: Colors.white, fontSize: 19);
}

TextStyle simpleButtonStyleOrange() {
  return TextStyle(color: Color(0xffFE8A37), fontSize: 19);
}

TextStyle mediumStyle() {
  return TextStyle(color: Colors.white, fontSize: 18);
}