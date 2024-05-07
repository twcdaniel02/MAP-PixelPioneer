import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixelpioneer_cpplink/controller.dart';
import 'main.dart'; // Ensure this is set up for navigation

class RegisterTypePage extends StatefulWidget {
  const RegisterTypePage({super.key});

  @override
  State<RegisterTypePage> createState() => _RegisterTypePageState();
}

class _RegisterTypePageState extends State<RegisterTypePage> {
  bool isLoading = false;
  String? userType;
  double iconSize1 = 120;
  double iconSize2 = 120;
  var containerColor1 = Colors.white;
  var containerColor2 = Colors.white;

  void setUser(int y) {
    if (y == 1) {
      setState(() {
        containerColor1 = const Color.fromRGBO(250, 195, 44, 1);
        containerColor2 = Colors.white;
        iconSize1 = 130;
        iconSize2 = 120;
        userType = 'rider';
      });
    } else if (y == 2) {
      setState(() {
        containerColor2 = const Color.fromRGBO(250, 195, 44, 1);
        containerColor1 = Colors.white;
        iconSize1 = 120;
        iconSize2 = 130;
        userType = 'user';
      });
    }
  }

  void nextPage() async {
    if (userType == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select type of user')));
      return;
    } else if (userType == 'user') {
      RegisterUserType = 'user';
      print('user register');
    } else if (userType == 'rider') {
      RegisterUserType = 'rider';
      print('rider register');
    }

    setState(() {
      isLoading = true;
    });

    // Assume user is already logged in and we are just updating the userType
    // var uid = FirebaseAuth.instance.currentUser?.uid;
    // if (uid != null) {
    //   await FirebaseFirestore.instance.collection('users').doc(uid).set({
    //     'userType': userType,
    //   }, SetOptions(merge: true));
    // }

    print('go to register form');
    Navigator.of(context).pushReplacementNamed('/customer_registration');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 195, 44, 1),
        centerTitle: true,
        title: const Text('Register',
            style: TextStyle(
                fontFamily: 'roboto',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ),
      body: Stack(children: [
        ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 42.0,
                  width: 235.0,
                  child: Container(
                      child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Register to',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Montagu Slab',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  )),
                ),
                Column(
                  children: [
                    Container(
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.,
                        children: [
                          Text(
                            'CPP',
                            style: TextStyle(
                              color: Color.fromRGBO(250, 195, 44, 1),
                              fontSize: 48,
                              fontFamily: 'Montagu Slab',
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 145, 145, 145),
                                  offset: Offset(0, 3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Link',
                            style: TextStyle(
                              color: Color.fromARGB(255, 7, 7, 131),
                              fontSize: 32,
                              fontFamily: 'Montagu Slab',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                ///Input Column
                Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(180, 221, 221,
                        221), // Semi-transparent black background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        ///////////////
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'I am:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Select your type of user',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setUser(1);
                                },
                                child: Container(
                                  decoration: ShapeDecoration(
                                    color: containerColor1,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 0.50,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        color: Color(0x38949494),
                                      ),
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
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // InkWell(
                                          //   onTap: () {
                                          //     Navigator.of(context)
                                          //         .pushReplacementNamed(
                                          //             '/rider_register');
                                          //   },
                                          //   child:
                                          Column(children: [
                                            Icon(
                                              Icons.delivery_dining_outlined,
                                              size: iconSize1,
                                            ),
                                            Text(
                                              'rider',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black.withOpacity(
                                                    0.3400000035762787),
                                                fontSize: 18,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ]),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),

                              /////////////
////////////////////////////////////
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  setUser(2);
                                },
                                child: Container(
                                  decoration: ShapeDecoration(
                                    color: containerColor2,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 0.50,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        color: Color(0x38949494),
                                      ),
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
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // InkWell(
                                          //   onTap: () {
                                          //     Navigator.of(context)
                                          //         .pushReplacementNamed(
                                          //             '/customer_register');
                                          //   },
                                          //   child:
                                          Column(children: [
                                            Icon(
                                              Icons.emoji_people,
                                              size: iconSize2,
                                            ),
                                            Text(
                                              'user',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black.withOpacity(
                                                    0.3400000035762787),
                                                fontSize: 18,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ]),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              /////////////
                            ]),
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
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              nextPage();
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Text(
                                isLoading == false ? 'Continue' : 'Loading..',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                )),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFFFFD233)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Note :',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 1),
                                    fontSize: 15,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w700,
                                  )),
                              Text('A User:',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 1),
                                    fontSize: 13,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  )),
                              Text('1. Can request for parcel delivery service',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 1),
                                    fontSize: 13,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  )),
                              Text('2. Can manage parcel',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 1),
                                    fontSize: 13,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(height: 10),
                              Text('A Rider:',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 1),
                                    fontSize: 13,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  )),
                              Text(
                                  '1. Can turn on delivery mode to provide a delivery service for customers',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 1),
                                    fontSize: 13,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  )),
                              Text('2. Can access normal users\' features',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 1, 1),
                                    fontSize: 13,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ]),
                      ])),
                ),
              ],
            ),
          ],
        ),
        if (isLoading)
          Container(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
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
      ]),
    );
  }
}
