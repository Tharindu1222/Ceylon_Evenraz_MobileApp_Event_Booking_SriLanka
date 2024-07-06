import 'package:ceylon/screens/athentication/register.dart';
import 'package:ceylon/screens/athentication/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool signinpage = true;
  //toglle pages
  void switchPages() {
    setState(() {
      signinpage = !signinpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signinpage == true) {
      return Sign_In(toggle: switchPages);
    } else {
      return Register(toggle: switchPages);
    }
  }
}
