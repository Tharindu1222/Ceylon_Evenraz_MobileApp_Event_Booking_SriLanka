import 'package:ceylon/models/UserModel.dart';
import 'package:ceylon/screens/admin/adminpanel.dart';
import 'package:ceylon/screens/athentication/athenticate.dart';
import 'package:ceylon/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null) {
      return Authenticate();
    } else {
      if (user.email == "admin@gmail.com") {
        return AdminPanel();
      } else {
        return Home();
      }
    }
  }
}
