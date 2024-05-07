import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pixelpioneer_cpplink/controller.dart';

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({Key? key}) : super(key: key);

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool riderMode = false;
  String? riderId;
  Map<String, dynamic>? riderDetails;

  @override
  void initState() {
    super.initState();
    fetchRiderDetailsAndSetMode();
  }

   void riderModeActive() async {
    setState(() {
      riderMode = true;
    });
    await getRequestedParcelList();
    await getRiderParcel(user_rider[0]['rider_id']);
    //!! not sure
    //await updateRiderStatus(user_rider[0]['rider_id'], 'idle');
    await updateRiderStatus('idle');

    Navigator.pushNamedAndRemoveUntil(
        context, '/delivery_homepage', (route) => false);
  }


  Future<void> fetchRiderDetailsAndSetMode() async {
    var user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot riderSnapshot =
          await _firestore.collection('riders').doc(user.uid).get();

      if (riderSnapshot.exists) {
        riderDetails = riderSnapshot.data() as Map<String, dynamic>?;
        setState(() {
          riderId = user.uid;
          riderMode = riderDetails?['status'] != 'offline';
        });
      }
    }
  }

  Future<void> updateRiderStatus(String status) async {
    if (riderId != null) {
      await _firestore.collection('riders').doc(riderId).update({
        'status': status,
      });
      setState(() {
        riderMode = status != 'offline';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(250, 195, 44, 1),
          centerTitle: true,
          title: Text(
            'Rider Homepage',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            // Example content goes here
            Text("Rider Homepage Content"),
          ],
        ),
      ),
    );
  }
}
