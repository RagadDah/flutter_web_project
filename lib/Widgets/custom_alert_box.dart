import 'package:flutter/material.dart';
import 'package:flutter_web_project/Data/constants.dart';

class CustomAlertBox extends StatelessWidget {
  String _text = "";
  CustomAlertBox(String text) {
    _text = text;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "OK",
            style: TextStyle(
              color: kBeigeColor,
            ),
          ),
        ),
      ],
    );
  }
}
