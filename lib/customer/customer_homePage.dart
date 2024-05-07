import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerHomepage extends StatefulWidget {
  const CustomerHomepage({super.key});

  @override
  State<CustomerHomepage> createState() => _CustomerHomepageState();
}

class _CustomerHomepageState extends State<CustomerHomepage> {
  bool shouldShowRow = false; // Placeholder for a condition
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  String userName = "Guest";

    Future<void> fetchUserData() async { //! Change1: add this method
    if (userId != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if document exists and contains name field
      if (userData.exists && userData.data() != null) {
        setState(() {
          userName = userData.get('name') ?? "Guest";
        });
      }

      // Listen to booking collection changes
      FirebaseFirestore.instance
          .collection('booking')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            shouldShowRow = true;
          });
        }
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchUserData(); //! change2 here
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
            'Customer Homepage',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20.0),
            // Display user name and welcome message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFD233),
                        width: 1.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        FirebaseAuth.instance.currentUser?.photoURL ??'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    // 'Welcome back, ${FirebaseAuth.instance.currentUser?.displayName ?? "Guest"}',
                    'Welcome back, $userName', //!! change3 here to print the name
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            if (shouldShowRow)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/customer_myRider');
                  },
                  child: const Text('My Booking'),
                ),
              ),
            const SizedBox(height: 70),
            const Center(
              child: Text(
                'What would you want to do for Today?',
                style: TextStyle(
                  color: Color(0xFF9B9B9B),
                  fontSize: 17,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, //book and check parcel button
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/customer_booking');
                        },
                        child: Container(
                          width: 155,
                          height: 129,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFD233),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                width: 1.50,
                                color: Color(0xFFFFD233), // Border color
                              ),
                            ),
                            shadows: [
                              const BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.delivery_dining_outlined,
                                size: 50, // Adjust the size as needed
                                color: Color.fromARGB(255, 255, 255,
                                    255), // Change the icon color
                              ),
                              Text(
                                'Book Delivery',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          //await getParcelList();
                          Navigator.of(context)
                              .pushReplacementNamed('/customer_checkParcel');
                          // Your code to handle the tap event
                        },
                        child: Container(
                          width: 155,
                          height: 129,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFD233),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                width: 1.50,
                                color: Color(0xFFFFD233), // Border color
                              ),
                            ),
                            shadows: [
                              const BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.widgets,
                                size: 50, // Adjust the size as needed
                                color: Color.fromARGB(255, 255, 255,
                                    255), // Change the icon color
                              ),
                              Text(
                                'Check Parcel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                ///////////////////////////
              ],
            ),
            /////////////////////////first row for book and check parcel
            const SizedBox(
              height: 30,
            ),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //book and check parcel button
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/customer_profile');
                        // Your code to handle the tap event
                      },
                      child: Container(
                        width: 155,
                        height: 129,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFFD233),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              width: 1.50,
                              color: Color(0xFFFFD233), // Border color
                            ),
                          ),
                          shadows: [
                            const BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.manage_accounts,
                              size: 50, // Adjust the size as needed
                              color: Color.fromARGB(
                                  255, 255, 255, 255), // Change the icon color
                            ),
                            Text(
                              'Update Profile',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/customer_quickScan');
                        // Your code to handle the tap event
                      },
                      child: Container(
                        width: 155,
                        height: 129,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFFD233),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              width: 1.50,
                              color: Color(0xFFFFD233), // Border color
                            ),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.qr_code_scanner,
                              size: 50, // Adjust the size as needed
                              color: Color.fromARGB(
                                  255, 255, 255, 255), // Change the icon color
                            ),
                            Text(
                              'Quick scan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            ])
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
