import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_web_project/Data/constants.dart';
import 'package:flutter_web_project/Data/user.dart';
import 'package:flutter_web_project/Pages/signup.dart';
import 'package:flutter_web_project/Providers/controller.dart';
import 'package:flutter_web_project/Utils/util.dart';
import 'package:provider/provider.dart';

class LogIn extends StatelessWidget {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, controller, child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Log In",
                style: TextStyle(
                    shadows: [kBoxShadow],
                    color: kBeigeColor,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.0,
              ),
              CustomTextField(
                controller: _email,
                label: "Email",
              ),
              SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: _password,
                label: "Password",
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: 200.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: kBeigeColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  boxShadow: [kBoxShadow],
                ),
                child: TextButton(
                  child: Text(
                    "Log In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    await controller.logIn(controller.user, _email.text.trim(),
                        _password.text.trim());
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an accout ? ",
                    style: TextStyle(
                      shadows: [kBoxShadow],
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.toggle(),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        shadows: [kBoxShadow],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required TextEditingController controller,
    required String label,
  })  : _controller = controller,
        _label = label;

  final TextEditingController _controller;
  final String _label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500.0,
      decoration: BoxDecoration(
        boxShadow: [
          kBoxShadow,
        ],
        color: kBeigeColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: TextField(
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              label: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "${_label}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          )),
          controller: _controller,
        ),
      ),
    );
  }
}
