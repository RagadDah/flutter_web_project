import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_web_project/Pages/login.dart';
import 'package:flutter_web_project/Pages/signup.dart';
import 'package:flutter_web_project/Providers/controller.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, controller, child) {
        return controller.isLogin ? LogIn() : SignUp();
      },
    );
  }
}
