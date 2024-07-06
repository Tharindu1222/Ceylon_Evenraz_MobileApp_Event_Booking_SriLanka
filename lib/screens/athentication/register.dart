import 'package:ceylon/constants/colors.dart';
import 'package:ceylon/constants/description.dart';
import 'package:ceylon/constants/styles.dart';
import 'package:ceylon/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggle;
  const Register({super.key, required this.toggle});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServices _auth = AuthServices();

  //formkey
  final _formkey = GlobalKey<FormState>();

  //email password states
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgBlack,
        appBar: AppBar(
          title: const Text("REGISTER"),
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
                    height: 200,
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
                          validator: (val) => val?.isEmpty == true
                              ? "Enter a valid email"
                              : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        //password
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              hintText: "Password"),
                          validator: (val) => val!.length < 6
                              ? "Password must be at least 6 characters"
                              : null,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),

                        //google
                        const SizedBox(
                          height: 5,
                        ),
                        //error text
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                        const Text(
                          "Sign with social Accounts",
                          style: descriptionStyle,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          //sign in with google
                          onTap: () {},
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
                              //go to the register page
                              onTap: () {
                                widget.toggle();
                              },
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: mainBlue,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        //button
                        GestureDetector(
                          onTap: () async {
                            dynamic result = await _auth
                                .registerWithEmailandPassword(email, password);

                            if (result == null) {
                              //error
                              setState(() {
                                error =
                                    "Password must be at least 6 characters";
                              });
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                              color: bgBlack,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 2, color: mainYellow),
                            ),
                            child: const Center(
                              child: Text(
                                "REGISTER",
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
        ));
  }
}
