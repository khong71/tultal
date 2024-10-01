import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

class Registeruser extends StatefulWidget {
  const Registeruser({super.key});

  @override
  State<Registeruser> createState() => _RegisteruserState();
}

class _RegisteruserState extends State<Registeruser> {
  File? _image;
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

  // Function to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to determine the current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
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
      return "Please fill in all fields."; //กรุณากรอกให้ครบทุกช่อง
    }

    // Check if the first character of address is a space
    if (_addressController.text.isNotEmpty &&
        _addressController.text[0] == ' ') {
      return "Invalid email format"; //รูปแบบที่อยู่ไม่ถูกต้อง
    }

    // Email validation
    if (!_emailController.text.endsWith('@gmail.com')) {
      return "Invalid email format"; //รูปแบบที่อยู่ไม่ถูกต้อง
    }

    // Check if there are characters before @gmail.com
    String email = _emailController.text;
    if (email.indexOf('@gmail.com') <= 0) {
      return "Invalid email format"; // No characters before @gmail.com
    }

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      return "Passwords don't match"; //รหัสผ่านไม่ตรงกัน
    }

    // Check if image is selected
    if (_image == null) {
      return "Please select a picture."; //กรุณาเลือกรูปภาพ
    }

    return null; // All validations passed
  }

  @override
  void initState() {
    super.initState();
    _locationController.text =
        "${_selectedLocation.latitude}, ${_selectedLocation.longitude}"; // Initial value
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
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Choose from gallery'),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Take a picture'),
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
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
                      child: _image != null
                          ? ClipOval(
                              child: Image.file(
                                _image!,
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
                        RegExp(r'^\s')), // Deny space at the beginning
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Password'),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
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
                        RegExp(r'\s')), // Deny space
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Confirm Password'),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
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
                        RegExp(r'\s')), // Deny space
                  ],
                ),
                const SizedBox(height: 30),
                // Map Display
                SizedBox(
                  height: 250, // Adjust the height as necessary
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: _selectedLocation,
                      initialZoom: 15.0,
                      onTap: (tapPosition, point) {
                        setState(() {
                          _selectedLocation =
                              point; // Update the selected location
                          _locationController.text =
                              "${point.latitude}, ${point.longitude}"; // Update location controller
                          mapController.move(
                              point,
                              mapController.camera
                                  .zoom); // Move the map to the selected location
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
                // TextField to display selected location
                const Text('Selected Location:'),
                const SizedBox(height: 8),
                TextField(
                  controller: _locationController,
                  readOnly: true, // Make it read-only
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 30),
                // Register button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      String? validationMessage = _validateInputs();
                      if (validationMessage != null) {
                        // Show error dialog
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
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Register (user)',
                      style: TextStyle(color: Colors.white),
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
}
