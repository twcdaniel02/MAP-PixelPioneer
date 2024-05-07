import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelpioneer_cpplink/controller.dart';

class RiderUploadVehicle extends StatefulWidget {
  const RiderUploadVehicle({Key? key}) : super(key: key);

  @override
  _RiderUploadVehicleState createState() => _RiderUploadVehicleState();
}

class _RiderUploadVehicleState extends State<RiderUploadVehicle> {
  dynamic image;
  XFile? fileImage;
  File? imageFile;
  bool isImageSelected = false;
  bool isLoading = false;
  String _selectedVehicleType = 'Motorcycle';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _imageFile;
  bool _isLoading = false;

  // Future<void> uploadVehicle(dynamic id) async {
  //   if (!_formKey.currentState!.validate() || _imageFile == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Please fill all fields and select an image')));
  //     return;
  //   }

  //   setState(() => _isLoading = true);

  //   try {
  //     final user = _auth.currentUser;
  //     if (user == null) throw Exception('No user logged in');

  //     String filePath =
  //         'vehicles/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     File file = File(_imageFile!.path);

  //     // Upload image
  //     UploadTask task = FirebaseStorage.instance.ref(filePath).putFile(file);
  //     final snapshot = await task;
  //     final imageUrl = await snapshot.ref.getDownloadURL();

  //     // Store vehicle details
  //     await _firestore.collection('riders').doc(user.uid).update({
  //       'vehicleModel': _modelController.text.toUpperCase(),
  //       'vehicleColor': _colorController.text.toUpperCase(),
  //       'plateNumber': _plateController.text.toUpperCase(),
  //       'vehicle_type': _selectedVehicleType.toUpperCase(),
  //       'vehicleImageUrl': imageUrl,
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Vehicle uploaded successfully')));
  //     Navigator.pop(context);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error uploading vehicle: $e')));
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  Future<void> uploadVehicle(dynamic id) async {
    print('Entering uploadVehicle');

    try {
      print('entering try');
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      String filePath ='vehicles/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File file = File(_imageFile!.path);
      print('File: $file');

      // Upload image
      UploadTask task = FirebaseStorage.instance.ref(filePath).putFile(file);
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      print('Image URL: $imageUrl');

     
      // Store vehicle details
      await _firestore.collection('riders').doc(user.uid).set({
        'vehicle_model': _modelController.text.toUpperCase(),
        'vehicle_color': _colorController.text.toUpperCase(),
        'plate_number': _plateController.text.toUpperCase(),
        'vehicle_type': _selectedVehicleType.toUpperCase(),
        //'picture_url': imageUrl,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehicle uploaded successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading vehicle: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void getImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
        isImageSelected = true;
      });
    }
    setState(() {
      fileImage = pickedImage;
    });
  }

  Future<void> uploadImage(dynamic userId) async {
  print('Entering uploadImage');
  try {
    print('ImageFile: $imageFile');
    if (fileImage == null) {
      throw 'No image selected';
    }
      var querySnapshot = await _firestore.collection('riders')
        .where('userId', isEqualTo: userId)
        .get();

      if (querySnapshot.docs.isEmpty) {
      print("No matching rider found for the given userId.");
      return;
    }
    print(querySnapshot);

    // Assuming userId is unique and only one document should match
    String riderId = querySnapshot.docs.first.id;
    print(riderId);

    // Defining the path in Firebase Storage
    String filePath = 'riders/$userId/vehicle.${imageFile!.path.split('.').last.toLowerCase()}';

    // Uploading the file to Firebase Storage
    TaskSnapshot snapshot = await FirebaseStorage.instance.ref(filePath).putFile(imageFile!);
    String imageUrl = await snapshot.ref.getDownloadURL();
    print('Image uploaded: $imageUrl');

    // Updating Firestore with the new image URL
    await _firestore.collection('riders').doc(riderId).update({'picture_url': imageUrl});
    print('Firestore updated with image URL');
  } catch (e) {
    print('Error uploading image: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 195, 44, 1),
        centerTitle: true,
        title: const Text(
          'Setup Your Profile',
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
            Navigator.pop(context);
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
                const Text(
                  'Upload Vehicle Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(
                                width: 150,
                                height: 150,
                                child: isImageSelected == true
                                    ? Image(image: FileImage(imageFile!))
                                    : Container(
                                        color: const Color.fromARGB(
                                            255, 154, 154, 154),
                                        child: const Center(
                                          child: Text('No image'),
                                        ),
                                      )),
                            Container(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () async {
                                  getImage();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                child: const Text('Upload Photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    )),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 263,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.5,
                                  color: const Color.fromARGB(56, 25, 25, 25),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(164, 117, 117, 117),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _plateController,
                                textAlignVertical: TextAlignVertical.center,
                                maxLines: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                ],
                                decoration: InputDecoration(
                                  hintText: "Enter vehicle plate number",
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 249, 249, 249),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 1.50,
                                      color: Color(0xFFFFD233),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  prefixIcon: const Icon(
                                    Icons.pin,
                                    color: Color(0xFFFFD233),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a vehicle plate number';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 263,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.5,
                                  color: const Color.fromARGB(56, 25, 25, 25),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(164, 117, 117, 117),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _modelController,
                                textAlignVertical: TextAlignVertical.center,
                                maxLines: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                ],
                                decoration: InputDecoration(
                                  hintText: "Enter vehicle model",
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 249, 249, 249),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 1.50,
                                      color: Color(0xFFFFD233),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  prefixIcon: const Icon(
                                    Icons.delivery_dining_outlined,
                                    color: Color(0xFFFFD233),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter vehicle model';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 263,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.5,
                                  color: const Color.fromARGB(56, 25, 25, 25),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(164, 117, 117, 117),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedVehicleType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedVehicleType = newValue!;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 249, 249, 249),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 1.50,
                                      color: Color(0xFFFFD233),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  prefixIcon: const Icon(
                                    Icons.delivery_dining_outlined,
                                    color: Color(0xFFFFD233),
                                  ),
                                ),
                                items:
                                    ["Motorcycle", "Car"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select vehicle type';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 263,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.5,
                                  color: const Color.fromARGB(56, 25, 25, 25),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(164, 117, 117, 117),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _colorController,
                                textAlignVertical: TextAlignVertical.center,
                                maxLines: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                ],
                                decoration: InputDecoration(
                                  hintText: "Enter vehicle colour",
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 249, 249, 249),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 1.50,
                                      color: Color(0xFFFFD233),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  prefixIcon: const Icon(
                                    Icons.water_drop,
                                    color: Color(0xFFFFD233),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter vehicle colour';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 30),
                                InkWell(
                                  onTap: () async {
                                    if (isImageSelected == false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Please Upload Image')));
                                      return;
                                    }

                                    setState(() {
                                      isLoading = true;
                                    });
                                    var vehicleModel =
                                        _modelController.text.toUpperCase();
                                    var vehicleColor =
                                        _colorController.text.toUpperCase();
                                    var plateNumber =
                                        _plateController.text.toUpperCase();
                                    var vehicleType = _selectedVehicleType;
                                    if (_formKey.currentState!.validate()) {
                                      final id = await signupRider(
                                          vehicleModel,
                                          vehicleColor,
                                          plateNumber,
                                          vehicleType);
                                      // await signIn();
                                      await uploadVehicle(id);
                                      await uploadImage(id);

                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator
                                                            .pushNamedAndRemoveUntil(
                                                                context,
                                                                '/login',
                                                                (route) =>
                                                                    false);
                                                      },
                                                      child: const Text('OK'))
                                                ],
                                                content: const Text(
                                                    'Vehicle Successfully Uploaded'),
                                              ));
                                    }

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: Container(
                                    width: 263,
                                    height: 53,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      color: const Color.fromARGB(
                                          255, 44, 174, 48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          width: 1.50,
                                          color:
                                              Color.fromARGB(255, 44, 174, 48),
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
                                    child: isLoading == false
                                        ? const Text(
                                            'Confirm',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 15,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : const Text(
                                            'Loading..',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 15,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                InkWell(
                                  onTap: isLoading == true
                                      ? null
                                      : () async {
                                          // Your code to handle the tap event
                                          if (mounted) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                          }

                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Lexend',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                          onPressed: () async {
                                                            try {
                                                              await signupRider(
                                                                  vehicleModel,
                                                                  vehicleColor,
                                                                  plateNumber,
                                                                  vehicleType);
                                                              Navigator
                                                                  .pushNamedAndRemoveUntil(
                                                                      context,
                                                                      '/login',
                                                                      (route) =>
                                                                          false);
                                                            } catch (e) {
                                                              return;
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Confirm',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Lexend',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ))),
                                                    ],
                                                    content: const Text(
                                                        'Your current information will not be saved. Are you sure you want to proceed? You can update your vehicle details on the \'Update Profile\' page.'),
                                                  ));

                                          if (mounted) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                  child: Container(
                                    width: 263,
                                    height: 33,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      color: const Color.fromARGB(
                                          255, 252, 69, 69),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          width: 1.50,
                                          color:
                                              Color.fromARGB(255, 255, 60, 54),
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
                                    child: isLoading == false
                                        ? const Text(
                                            'Upload later',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 15,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : const Text(
                                            'Loading..',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 15,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
    );
  }
}
