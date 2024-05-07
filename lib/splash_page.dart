import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart'; // Make sure this is set up correctly for navigation

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
  await Future.delayed(Duration.zero);
  if (!mounted) {
    return;
  }

  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    String userID = currentUser.uid;

    // Query Firestore to get user role
    DocumentSnapshot adminDoc = await FirebaseFirestore.instance.collection('admin').doc(userID).get();
    DocumentSnapshot riderDoc = await FirebaseFirestore.instance.collection('rider').doc(userID).get();
    DocumentSnapshot customerDoc = await FirebaseFirestore.instance.collection('users').doc(userID).get();

    if (adminDoc.exists) {
      print('User is an admin');
      //await getAdminData(userID);
      Navigator.of(context).pushReplacementNamed('/admin_home');
    } else if (riderDoc.exists) {
      print('User is a rider');
      //  await getData(userID);
      //   await getRiderStatus(); //for checking rider status
      //   await checkDelivery();
      //   await updateListParcel();
      Navigator.of(context).pushReplacementNamed('/rider_home');
    } else if (customerDoc.exists) {
      print('User is a customer');
      // await getData(userID);
      //   await updateListParcel();
      Navigator.of(context).pushReplacementNamed('/customer_home');
    }
  } else {
    Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login page
  }
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
