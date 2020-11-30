import 'package:flutter/material.dart';
import 'package:flutter_db/utils/custom_color.dart';
import 'package:flutter_db/utils/utility.dart';

class FormUI extends StatefulWidget {
  @override
  _FormUIState createState() => _FormUIState();
}

class _FormUIState extends State<FormUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Container(
       color: CustomColor.PrimaryColor,
     ),
    );
  }
}
