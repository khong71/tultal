// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Changeprofile extends StatefulWidget {
  const Changeprofile({super.key});

  @override
  State<Changeprofile> createState() => _ChangeprofileState();
}

class _ChangeprofileState extends State<Changeprofile> {
  late Future<void> loadData;

  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();

  File? _image; // To hold the selected image
  final ImagePicker _picker =
      ImagePicker(); // Create an instance of ImagePicker

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source); // Updated to pickImage

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDBC7A1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // ไอคอนย้อนกลับ
          onPressed: () {
            Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
          },
        ),
        title: Text('Chang Profile'), // ชื่อหน้าปัจจุบัน
      ),
      body: Container(
        color: const Color(0xFFDBC7A1),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
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
                  radius: 80, // Increase the size of the avatar
                  backgroundColor: const Color.fromARGB(255, 173, 173, 173),
                  child: _image != null
                      ? ClipOval(
                          child: Image.file(
                            _image!,
                            width: 160,
                            height: 160,
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
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Username'),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Email'),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('address'),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A3827), // Dark brown color
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadDataAsync() async {}
}
