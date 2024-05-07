import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelpioneer_cpplink/controller.dart';

// Import statements remain the same
class CustomerRegisterPage extends StatefulWidget {
  const CustomerRegisterPage({super.key});

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? emailUnique;
  bool? phoneUnique;
  bool? phoneValid;
  bool? nameValid;
  bool? emailValid;
  String? _email;
  String? _name;
  String? _phone;
  bool checked = false;
  bool isLoading = false;

  Future<void> _signUp(String _name, String _phone, String _email) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        if (RegisterUserType == 'rider') {
          //Set Rider details
          registerEmail = _email;
          registerPassword = _passwordController.text;
          registerName = _name;
          registerPhone = _phone;
          print('rider details saved');
          return;
        }

        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'user_id': userCredential.user!.uid,
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': registerEmail,
          'riderId': '',
        });
        Navigator.of(context).pushReplacementNamed('/login');
        print('User registered successfully');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register: ${e.message}')));
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<bool> _emailUnique() async {
    try {
      print(email);
      // Query Firestore for any documents that match the given email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users') 
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // If we find any documents, the email is not unique
      if (querySnapshot.docs.isNotEmpty) {
        return false;
      }
      // If no documents were found, the email is unique
      return true;
    } catch (e) {
      print('Error checking email uniqueness: $e');
      return false; // You might want to handle this differently
    }
  }

  Future<bool> _phoneUnique() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: _phone!)
          .limit(1)
          .get();

      // If we find any documents, the phone number is not unique
      if (querySnapshot.docs.isNotEmpty) {
        return false;
      }
      // If no documents were found, the phone number is unique
      return true;
    } catch (e) {
      print('Error checking phone uniqueness: $e');
      return false; // You might want to handle this differently based on your error handling policy
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(250, 195, 44, 1),
          centerTitle: true,
          title: const Text(
            'Register',
            style: TextStyle(
              fontFamily: 'roboto',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back, // You can replace this with your custom logo
              color: Colors.white, // Icon color
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/register_type');
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
                  const SizedBox(height: 30.0),
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
                              ///////////////////////////////////////////
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter Full Name';
                                        } else if (nameValid == false) {
                                          return 'Invalid Name';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: _nameController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      maxLines: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter,
                                      ],
                                      decoration: InputDecoration(
                                        hintText: "Enter full name",
                                        filled: true,
                                        fillColor: const Color.fromARGB(255,
                                            249, 249, 249), // Background color
                                        border: OutlineInputBorder(
                                          // Use OutlineInputBorder for rounded borders
                                          borderRadius: BorderRadius.circular(
                                              10), // This sets the rounded corners for the text field
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
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
                                          Icons.person,
                                          color: Color(0xFFFFD233),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              ///input mobile number
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter mobile number';
                                        } else if (phoneUnique == false) {
                                          return 'Mobile number already exist';
                                        } else if (phoneValid == false) {
                                          return "Enter Valid Phone Number";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: _phoneController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      maxLines: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter,
                                      ],
                                      decoration: InputDecoration(
                                        hintText: "Enter mobile number",
                                        filled: true,
                                        fillColor: const Color.fromARGB(255,
                                            249, 249, 249), // Background color
                                        border: OutlineInputBorder(
                                          // Use OutlineInputBorder for rounded borders
                                          borderRadius: BorderRadius.circular(
                                              10), // This sets the rounded corners for the text field
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
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
                                          Icons.call,
                                          color: Color(0xFFFFD233),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              /// input email
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
                                        fillColor: const Color.fromARGB(255,
                                            249, 249, 249), // Background color
                                        border: OutlineInputBorder(
                                          // Use OutlineInputBorder for rounded borders
                                          borderRadius: BorderRadius.circular(
                                              10), // This sets the rounded corners for the text field
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
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
                                          Icons.email,
                                          color: Color(0xFFFFD233),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter an email';
                                        } else if (emailUnique == false) {
                                          return 'Email Already Exist';
                                        } else if (emailValid == false) {
                                          return 'Invalid Email';
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
                                      obscureText: true,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      maxLines: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter,
                                      ],
                                      decoration: InputDecoration(
                                        hintText: "Enter password",
                                        filled: true,
                                        fillColor: const Color.fromARGB(255,
                                            249, 249, 249), // Background color
                                        border: OutlineInputBorder(
                                          // Use OutlineInputBorder for rounded borders
                                          borderRadius: BorderRadius.circular(
                                              10), // This sets the rounded corners for the text field
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
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
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a password';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),

                              ///input confirm password
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
                                      controller: _confirmPasswordController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      maxLines: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter,
                                      ],
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: "Enter confirm password",
                                        filled: true,
                                        fillColor: const Color.fromARGB(255,
                                            249, 249, 249), // Background color
                                        border: OutlineInputBorder(
                                          // Use OutlineInputBorder for rounded borders
                                          borderRadius: BorderRadius.circular(
                                              10), // This sets the rounded corners for the text field
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
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
                                          color:
                                              Color.fromARGB(255, 255, 210, 51),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a confirm password';
                                        } else if (_passwordController.text !=
                                            _confirmPasswordController.text) {
                                          _passwordController.clear();
                                          _confirmPasswordController.clear();
                                          return "Password does not match";
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

                                          _email = formatEmail(_emailController.text);
                                          _phone = formatPhone(_phoneController.text);
                                          _name = formatName(_nameController.text);
                                          emailUnique = await _emailUnique();
                                          phoneUnique = await _phoneUnique();
                                          phoneValid = phone_check(_phone!);
                                          nameValid = name_check(_name!);
                                          emailValid = email_check(_email!);

                                          print(RegisterUserType);
                                          if (_formKey.currentState!.validate()) {
                                            _signUp(_name!, _phone!, _email!);
                                            if (RegisterUserType == 'rider') {
                                              print('go to vehicle page');
                                              Navigator.pushNamed(context, '/rider_vehicle');
                                            } else {
                                              print('go to login page');
                                              Navigator.pushNamedAndRemoveUntil(context,'/login', (route) => false);
                                            }
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                  child: Text(
                                      isLoading == false
                                          ? 'Register'
                                          : 'Loading..',
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
                        'Already have an account?  ',
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
                                .pushReplacementNamed('/login');
                          },
                          child: const Text(
                            'Sign in now',
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
          // Loading indicator overlay
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
      ),
    );
  }
}
