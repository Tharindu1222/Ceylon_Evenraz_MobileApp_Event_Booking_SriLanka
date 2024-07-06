import 'dart:async';
import 'package:ceylon/constants/colors.dart';
import 'package:ceylon/constants/description.dart';
import 'package:ceylon/constants/styles.dart';
import 'package:ceylon/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Sign_In extends StatefulWidget {
  //function
  final Function toggle;
  const Sign_In({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Sign_In> createState() => _Sign_InState();
}

class _Sign_InState extends State<Sign_In> {
  //reference of auth service
  final AuthServices _auth = AuthServices();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //formkey
  final _formkey = GlobalKey<FormState>();

  //email password states
  String email = "";
  String password = "";
  String error = "";

  @override
  void initState() {
    super.initState();
    // Initialize Firebase Auth
    _auth.user.listen((user) {
      setState(() {});
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      setState(() {});
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        title: const Text("SIGN IN"),
        elevation: 0,
        backgroundColor: bgBlack,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 10),
          child: Column(
            children: [
              //description
              const Text(
                description,
                style: descriptionStyle,
              ),
              Center(
                child: Image.asset(
                  'assets/images/ceylon.png',
                  height: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  child: Column(
                    key: _formkey,
                    children: [
                      //email
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: textInputDecoration,
                        validator: (val) =>
                            val?.isEmpty == true ? "Enter a valid email" : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      //password
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration:
                            textInputDecoration.copyWith(hintText: "Password"),
                        validator: (val) =>
                            val!.length < 6 ? "enter a valid password" : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      Text(error, style: TextStyle(color: Colors.red)),
                      //google
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Sign with social Accounts",
                        style: descriptionStyle,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        //sign in with google
                        onTap: _signInWithGoogle,
                        child: Center(
                          child: Image.asset(
                            'assets/images/google.png',
                            height: 60,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      //registerpage
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Do not have an account?",
                            style: descriptionStyle,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            //go to the Sign in page
                            onTap: () {
                              widget.toggle();
                            },
                            child: const Text(
                              "REGISTER",
                              style: TextStyle(
                                  color: mainBlue, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      //button
                      GestureDetector(
                        //method for login users
                        onTap: () async {
                          dynamic result = await _auth
                              .signInUsingEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error =
                                  "Could not sign in with those credentials";
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            color: bgBlack,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 2, color: mainYellow),
                          ),
                          child: const Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      //anonymous
                      GestureDetector(
                        //method for login user as anonymous
                        onTap: () async {
                          await _auth.signInAnnonymously();
                        },
                        child: Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            color: bgBlack,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 2, color: mainYellow),
                          ),
                          child: const Center(
                            child: Text(
                              "LOGIN AS GUEST",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
