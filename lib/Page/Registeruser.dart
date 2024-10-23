// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tultal/Page/Login.dart';
import 'package:tultal/config/config.dart';
import 'package:tultal/model/req/registerUser.dart';

class Registeruser extends StatefulWidget {
  const Registeruser({super.key});

  @override
  State<Registeruser> createState() => _RegisteruserState();
}

class _RegisteruserState extends State<Registeruser> {
  String server = '';
  XFile? image;
  String imgUrl = '';
  LatLng _selectedLocation =
      const LatLng(16.246825669508297, 103.25199289277295);
  MapController mapController = MapController();
  TextEditingController _locationController =
      TextEditingController(); // Controller for location display
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Function to determine the current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Function to validate inputs before registration
  String? _validateInputs() {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      return "Please fill in completely."; //กรุณากรอกให้ครบทุกช่อง
    }

    // Check if the first character of address is a space
    if (_addressController.text.isNotEmpty &&
        _addressController.text[0] == ' ') {
      return "Invalid email format EX.test@gmail.com"; //รูปแบบ email ไม่ถูกต้อง
    }

    // Email validation
    if (!_emailController.text.endsWith('@gmail.com')) {
      return "Invalid email format EX.test@gmail.com"; //รูปแบบ email ไม่ถูกต้อง
    }

    // Check if there are characters before @gmail.com
    String email = _emailController.text;
    if (email.indexOf('@gmail.com') <= 0) {
      return "Invalid email format EX.test@gmail.com"; // No characters before @gmail.com
    }

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      return "Passwords don't match"; //รหัสผ่านไม่ตรงกัน
    }

    // Check if image is selected
    if (image == null) {
      return "Please select a picture."; //กรุณาเลือกรูปภาพ
    }

    return null; // All validations passed
  }

  @override
  void initState() {
    super.initState();
    Config.getConfig().then(
      (value) {
        log(value['serverAPI']); // แสดงค่าใน log สำหรับการ debug
        setState(() {
          server = value['serverAPI']; // อัปเดตค่า server
        });
      },
    );
    // ดึงตำแหน่งอัตโนมัติ
    _determinePosition().then((position) {
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _locationController.text =
            "${position.latitude}, ${position.longitude}";
        mapController.move(_selectedLocation,
            mapController.camera.zoom); // ปรับตำแหน่งบนแผนที่
      });
    }).catchError((error) {
      log("Error getting location: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
        backgroundColor: const Color.fromRGBO(226, 219, 191, 1),
      ),
      body: Stack(
        children: [
          // Background color container
          Container(
            color: const Color.fromRGBO(226, 219, 191, 1),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/image/logohaft.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Form fields
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 0),
                // Profile Image Selection
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Wrap(
                              children: [
                                Column(
                                  children: [
                                    FilledButton(
                                      onPressed: () async {
                                        final ImagePicker picker =
                                            ImagePicker();
                                        image = await picker.pickImage(
                                            source: ImageSource.gallery);
                                        log('Pressed');

                                        if (image != null &&
                                            image!.path.isNotEmpty) {
                                          log('Image selected: ${image!.path}');
                                          imgUrl = await uploadImage(image!);
                                          if (imgUrl.isNotEmpty) {
                                            log('Image uploaded successfully: $imgUrl');
                                            setState(() {});
                                          } else {
                                            log('Image upload failed.');
                                          }
                                        } else {
                                          log('No image selected or invalid image path.');
                                        }

                                        Navigator.of(context)
                                            .pop(); // Close modal
                                      },

                                      child: Text(
                                          'Select from Gallery'), // ข้อความในปุ่ม
                                    ),
                                    // หากต้องการเพิ่มตัวเลือกการถ่ายภาพด้วยกล้อง
                                    // ListTile(
                                    //   leading: const Icon(Icons.camera_alt),
                                    //   title: const Text('Take a picture'),
                                    //   onTap: () async {
                                    //     final ImagePicker picker = ImagePicker();
                                    //     image = await picker.pickImage(source: ImageSource.camera);
                                    //     if (image != null) {
                                    //       log(image!.path);
                                    //       imgUrl = await uploadimg(image!);
                                    //       log(imgUrl);
                                    //       setState(() {});
                                    //     } else {
                                    //       log('No image taken.');
                                    //     }
                                    //     Navigator.of(context).pop();
                                    //   },
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color.fromARGB(255, 173, 173, 173),
                      child: image != null
                          ? ClipOval(
                              child: Image.file(
                                File(imgUrl), // ใช้ imgUrl ที่ได้จากการอัปโหลด
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // Username field
                const Text('Username'),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s')), // ไม่ให้มีช่องว่าง
                  ],
                ),
                const SizedBox(height: 20),
                // Email field
                const Text('Email'),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(
                        "[^a-zA-Z0-9@.]")), // Allow valid email characters
                  ],
                ),
                const SizedBox(height: 20),
                // Phone number field
                const Text('Phone Number'),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  keyboardType: TextInputType.phone, // Show numeric keypad
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Only allow digits
                  ],
                ),
                const SizedBox(height: 20),
                // Address field
                const Text('Address'),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s')), // ไม่ให้มีช่องว่าง
                  ],
                ),
                const SizedBox(height: 20),
                // Password field
                const Text('Password'),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  obscureText: true, // Hide password input
                ),
                const SizedBox(height: 20),
                // Confirm Password field
                const Text('Confirm Password'),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  obscureText: true, // Hide password input
                ),
                const SizedBox(height: 20),
                // Location field (hidden but can be used for backend)
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                // Map Display
                SizedBox(
                  height: 250, // ปรับขนาดตามต้องการ
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: _selectedLocation,
                      initialZoom: 15.0,
                      minZoom: 5, // กำหนดค่า zoom ต่ำสุด
                      maxZoom: 18, // กำหนดค่า zoom สูงสุด
                      onTap: (tapPosition, point) {
                        setState(() {
                          _selectedLocation = point; // อัปเดตพิกัดที่เลือก
                          _locationController.text =
                              "${point.latitude}, ${point.longitude}"; // อัปเดตในฟิลด์ตำแหน่ง
                          mapController.move(
                              point,
                              mapController.camera
                                  .zoom); // ย้ายแผนที่ไปยังตำแหน่งที่เลือก
                        });
                        log('Selected Location: ${_selectedLocation.latitude}, ${_selectedLocation.longitude}');
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_on,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Register button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 145, 89, 57),
                    ),
                    onPressed: Register,
                    child: const Text(
                      'Register(user)',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void Register() {
    // Validate inputs before proceeding
    String? validationMessage = _validateInputs();
    if (validationMessage != null) {
      // Show error dialog and return to keep the user on the same page
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(validationMessage),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return; // Exit the method if validation fails
    }

    // Validate phone number length
    if (_phoneController.text.length != 10) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Phone number is incomplete or has more than 10 digits.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Proceed with registration
    var data = RegisterUser(
      userName: _usernameController.text,
      userEmail: _emailController.text,
      userPassword: _passwordController.text,
      userLocation: _locationController.text,
      userImage: '_image',
      userPhone: _phoneController.text,
      userAddress: _addressController.text,
    );

    http
        .post(
      Uri.parse('$server/Register'),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: registerUserToJson(data),
    )
        .then((response) {
      Navigator.of(context).pop(); // Close loading dialog
      if (response.statusCode == 200) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        log('Register Success: ${responseData['message']}');

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Successfully registered!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show error message if registration failed
        var errorData = jsonDecode(utf8.decode(response.bodyBytes));
        log('Failed to register. Error: ${response.statusCode} - ${errorData['message'] ?? 'No additional message'}');

        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(
                  'Failed to register: ${errorData['message'] ?? 'Unknown error'}'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      Navigator.of(context).pop(); // Close loading dialog
      log('Connection error: $error');
      // Show connection error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Connection error, please try again later.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          );
        },
      );
    });
  }

  Future<String> uploadImage(XFile image) async {
    // สร้าง Reference สำหรับ Firebase Storage
    final storageRef = FirebaseStorage.instance.ref();

    // สร้าง path สำหรับเก็บรูปภาพ
    final imageRef = storageRef.child('gg/${image.name}');

    // อัปโหลดรูปภาพ
    await imageRef.putFile(File(image.path));

    // รับ URL ของรูปภาพที่ถูกอัปโหลด
    String downloadURL = await imageRef.getDownloadURL();
    return downloadURL;
  }
}
