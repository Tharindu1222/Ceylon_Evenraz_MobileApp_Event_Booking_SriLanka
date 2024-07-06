import 'package:ceylon/models/UserModel.dart';
import 'package:ceylon/screens/admin/adminpanel.dart';
import 'package:ceylon/screens/home/home.dart';
import 'package:ceylon/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: UserModel(uid: ""),
      value: AuthServices().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        routes: {
          '/home': (context) => Home(),
          '/admin': (context) => AdminPanel(),
        },
      ),
    );
  }
}
