import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pixelpioneer_cpplink/customer/customer_homePage.dart';
import 'package:pixelpioneer_cpplink/customer_register.dart';
import 'package:pixelpioneer_cpplink/registerType_Page.dart';
import 'package:pixelpioneer_cpplink/rider/rider_homePage.dart';
import 'package:pixelpioneer_cpplink/rider/rider_uploadVehicle.dart';
import 'package:pixelpioneer_cpplink/splash_page.dart';
import 'firebase_options.dart'; // Make sure this is configured with your Firebase options

// import 'customer_pages/customer_quickScan.dart';
// import 'rider_pages/rider_changeProfilePicture.dart';
// import 'admin_pages/admin_homepage.dart';
import 'login_page.dart'; // Assuming you have a login page
// import 'home_page.dart';  // Assuming you have a home page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPPLink Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define initial route
      initialRoute: '/',
      // Define routes
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),

        '/register_type': (context) => const RegisterTypePage(),
        '/customer_registration': (context) => const CustomerRegisterPage(),

////////////////////users homepage////////////////

        //admin
        // '/admin_home': (context) => const AdminHomePage(),
        // '/admin_profile': (context) => const AdminProfile(),
        // '/admin_changeName': (context) => const AdminChangeName(),
        // '/admin_changePw': (context) => const AdminChangePassword(),
        // '/admin_changePFP': (context) => const AdminChangePicture(),
        // '/admin_changePhone': (context) => const AdminChangePhone(),
        // '/admin_manageParcel': (context) => const AdminManageParcel(),
        // '/admin_updateParcel': (context) => const AdminUpdateParcel(),
        // '/admin_registerParcel': (context) => const AdminRegisterParcel(),
        // '/admin_manageRider': (context) => const ManageRiderPage(),
        // '/admin_quickFind': (context) => const AdminQuickFind(),
        // '/admin_quickFindResult': (context) => const AdminQuickFindResult(),
        // '/admin_scantrackID': (context) => const AdminScanTrackID(),

        //customer
        '/customer_home': (context) => const CustomerHomepage(),
        // '/customer_profile': (context) => const CustomerProfile(),
        // '/changeName': (context) => const CustomerChangeName(),
        // '/changePw': (context) => const CustomerChangePassword(),
        // '/changePFP': (context) => const CustomerChangePicture(),
        // '/changePhone': (context) => const CustomerChangePhone(),
        // '/customer_booking': (context) => const customerBooking(),
        // '/customer_myRider': (context) => const customerRiderPage(),
        // '/customer_checkParcel': (context) => const customerCheckParcel(),
        // '/customer_quickScan': (context) => const customerQuickScan(),

        // rider
        '/rider_home': (context) => const RiderHomePage(),
        // '/rider_changeName': (context) => const RiderChangeName(),
        // '/rider_changePw': (context) => const RiderChangePassword(),
        // '/rider_changePFP': (context) => const RiderChangePicture(),
        // '/rider_changePhone': (context) => const RiderChangePhone(),
        // '/rider_profile': (context) => const RiderChangeProfile(),
        // '/rider_changeVehicle': (context) => const RiderChangeVehicle(),
        '/rider_vehicle': (context) => const RiderUploadVehicle(),
        // '/rider_booking': (context) => const RiderBooking(),
        // '/rider_myRider': (context) => const RiderRiderPage(),
        // '/rider_checkParcel': (context) => const RiderCheckParcel(),
        // '/rider_quickScan': (context) => const RiderQuickScan(),

//////////////////delivery mode//////////////////////
        // '/delivery_homepage': (context) => const DeliveryHomePage(),
        // '/delivery_list': (context) => const DeliveryList(),
        // '/delivery_proof': (context) => const DeliveryProof(),
        // '/delivery_qrPage': (context) => const QrCodePage(),
        // '/delivery_profilePage': (context) => const DeliveryProfilePage(),

//////////////////forgot password//////////////////
        // '/forgotPassword': (context) => const ForgotPassword(),
        // '/otpVerification': (context) => const OTPVerification(),
        // '/resetPassword': (context) => const ResetPassword(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to CPPLink'),
      ),
      body: Center(
        child: Text('Main Interface'),
      ),
    );
  }
}
