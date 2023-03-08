import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_web_project/Data/constants.dart';
import 'package:flutter_web_project/Pages/home_screen.dart';
import 'package:flutter_web_project/Providers/controller.dart';
import 'package:flutter_web_project/Utils/util.dart';
import 'package:flutter_web_project/Data/user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _email = TextEditingController();

  TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool? isManager = false;

  Future createUser(bool? isManager, WebUser user) async {
    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(_email.text.trim());

    final json = {
      'Email': _email.text.trim(),
      'Password': _password.text.trim(),
      'isManager': isManager,
    };

    await docUser.set(json);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, controller, child) {
        return Form(
          key: _formKey,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign Up",
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
                  validator: (email) =>
                      email != null || !EmailValidator.validate(email)
                          ? "Enter a valid email"
                          : null,
                  controller: _email,
                  label: "Email",
                ),
                SizedBox(
                  height: 20.0,
                ),
                CustomTextField(
                  validator: (value) => value != null && value.length < 8
                      ? "Password should be atleast 8 characters."
                      : null,
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
                      "Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      controller.user.email = _email.text.trim();
                      controller.user.password = _password.text.trim();

                      controller.signUp(context, _email.text.trim(),
                          _password.text.trim(), _formKey);
                      createUser(controller.user.isManager, controller.user);
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.only(left: 13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Is this a manager account ? ",
                        style: TextStyle(
                          shadows: [kBoxShadow],
                        ),
                      ),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.all(kBeigeColor),
                        value: controller.user.isManager,
                        onChanged: (value) {
                          isManager = value;
                          controller.isManagerToggle(value);
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an accout ? ",
                      style: TextStyle(
                        shadows: [kBoxShadow],
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.toggle(),
                      child: Text(
                        "Log in",
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
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {required TextEditingController controller,
      required String label,
      required validator})
      : _controller = controller,
        _label = label,
        _validator = validator;

  final TextEditingController _controller;
  final String _label;
  final String? Function(String?)? _validator;

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
        child: TextFormField(
          autovalidateMode: AutovalidateMode.disabled,
          validator: null,
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
