import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool? emailInvalid;
  bool? passwordInvalid;
  bool? workornot;

  Future<bool> _emailError() async {
    final email = _emailController.text.trim(); 
    print(email);

    // Reference to Firestore
    var firestore = FirebaseFirestore.instance;

    // Check if email exists in 'admin' collection
    var adminSnapshot = await firestore
        .collection('admin')
        .where('email', isEqualTo: email)
        .get();

    // Check if email exists in 'users' collection with 'rider_id'
    var riderSnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .where('rider_id', isNotEqualTo: null) // Assumes 'rider_id' exists and is not null for riders
        .get();

    // Check if email exists in 'users' collection for customers
    var customerSnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (adminSnapshot.docs.isNotEmpty ||
        riderSnapshot.docs.isNotEmpty ||
        customerSnapshot.docs.isNotEmpty) {
      print("Email already exists");
      return false; // Email exists, return false
    } else {
      print("Email is unique");
      return true; // Email is unique, return true
    }
  }

  Future<bool> _passwordError() async {
  try {
    // Attempt to sign in with email and password
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    print("Password okay");
    return false; // The password is correct, return false (no error)
  } catch (e) {
    // If sign-in fails, it will throw an exception
    print("Error with password: $e");
    return true; // There is an error with the password, return true
  }
}


  Future<bool> emailValidation() async {
    // In Firebase, you typically validate the email by attempting a sign-in or by ensuring the email format is correct
    String email = _emailController.text.trim();
    return email.isNotEmpty && email.contains('@');
  }

  Future<bool> passwordValidation() async {
    // Password validation can be simple or complex depending on your requirements
    String password = _passwordController.text;
    return password.isNotEmpty &&
        password.length >= 6; // Example: Check for minimum length
  }

  Future<void> userLogin() async {
    if (!await emailValidation()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid Email Address'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (!await passwordValidation()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password too short'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      // Attempt to sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to next page if login is successful
      Navigator.of(context).pushReplacementNamed('/');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.message}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 120.0,
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              child: Image(image:AssetImage('assets/images/cpp_logo.png'), ),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 20),
                    /////Input Column
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(180, 221, 221,
                            221), // Semi-transparent black background
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 263,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 0.5,
                                          color: const Color.fromARGB(
                                              56, 25, 25, 25),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                164, 117, 117, 117),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller: _emailController,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        maxLines: 1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .singleLineFormatter,
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "Enter email",
                                          filled: true,
                                          fillColor: const Color.fromARGB(
                                              255, 249, 249, 249),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 1.50,
                                              color: Color(0xFFFFD233),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal:
                                                      10), // Adjust padding
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: Color(0xFFFFD233),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter an email';
                                          } else if (emailInvalid == true) {
                                            return 'Email does not exist';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),

                                ///input password
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    Container(
                                      width: 263,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 0.5,
                                          color: const Color.fromARGB(
                                              56, 25, 25, 25),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                164, 117, 117, 117),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        maxLines: 1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .singleLineFormatter,
                                        ],
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: "Enter password",
                                          filled: true,

                                          fillColor: const Color.fromARGB(
                                              255,
                                              249,
                                              249,
                                              249), // Background color
                                          border: OutlineInputBorder(
                                            // Use OutlineInputBorder for rounded borders
                                            borderRadius: BorderRadius.circular(
                                                10), // This sets the rounded corners for the text field
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 1.50,
                                              color: Color(0xFFFFD233),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 10),
                                          prefixIcon: const Icon(
                                            Icons.password,
                                            color: Color(0xFFFFD233),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter a password';
                                          } else if (passwordInvalid == true &&
                                              emailInvalid == false) {
                                            return 'Wrong Password';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 40),
                                Container(
                                  width: 263,
                                  height: 37,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFFFD233),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: isLoading == true
                                        ? null
                                        : () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            //!!!!
                                            emailInvalid = await _emailError();
                                            passwordInvalid = await _passwordError();
                                            if (_formKey.currentState!
                                                .validate()) {
                                              await userLogin();
                                            }
                                            ;
                                            setState(() {
                                              isLoading = false;
                                            });
                                          },
                                    child: Text(
                                        isLoading == false
                                            ? 'Sign In'
                                            : 'Loading..',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w700,
                                        )),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xFFFFD233)),
                                    ),
                                  ),
                                ),
                                //////////////////////////////////////////
                              ],
                            ),
                          )),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Do not have an account?  ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed('/register_type');
                            },
                            child: const Text(
                              'Register now',
                              style: TextStyle(
                                color: Color(0xFFFFD233),
                                fontSize: 12,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Forgot your password ? ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/forgotPassword');
                            },
                            child: const Text(
                              'Reset password now',
                              style: TextStyle(
                                color: Color(0xFFFFD233),
                                fontSize: 12,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )),
                      ],
                    ),

                    ///end
                  ],
                ),
              ],
            ),
            if (isLoading)
              Container(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LottieBuilder.asset('assets/yellow_loading.json'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
