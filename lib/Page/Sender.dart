// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Login.dart';
import 'dart:developer';

import 'package:tultal/config/config.dart';
import 'package:tultal/model/res/getUsers.dart'; // For logging search text

import 'package:http/http.dart' as http;

class Recipient {
  final String name;
  final String phone;
  final String image;

  Recipient(this.name, this.phone, this.image);
}

class Sender extends StatefulWidget {
  final int userId; // Add the userId parameter
  const Sender({super.key, required this.userId});

  @override
  State<Sender> createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _imageFile;
  Recipient? selectedRecipient;
  LatLng _selectedLocation =
      const LatLng(16.246825669508297, 103.25199289277295);
  final MapController mapController = MapController();

  late List<GetUsers> users;
  late Future<void> loadData;
  String url = '';

  List<Recipient> recipients = [];

  List<Recipient> filteredRecipients = [];

  String server = '';
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRecipients);
    filteredRecipients = recipients;
    _getCurrentLocation();

    Config.getConfig().then(
      (value) {
        log(value['serverAPI']); // แสดงค่าใน log สำหรับการ debug
        setState(() {
          server = value['serverAPI']; // อัปเดตค่า server
        });
        loadDataAsync(); // เรียกใช้ฟังก์ชันโหลดข้อมูล
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecipients() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredRecipients = recipients.where((recipient) {
        return recipient.name.toLowerCase().contains(query) ||
            recipient.phone.contains(query);
      }).toList();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _resetRecipientSelection() {
    setState(() {
      selectedRecipient = null;
      _searchController.clear();
      filteredRecipients = recipients;
    });
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      mapController.move(_selectedLocation, 15.0);
    });
  }

  Future<void> _moveToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      mapController.move(_selectedLocation, 15.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2DBBF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Sender'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE2DBBF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 30),
              onPressed: () {
                // Navigate to home page or replace with the right route
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.all_inbox, color: Colors.black, size: 30),
              onPressed: () => CheckStatu(),
            ),
            IconButton(
              icon:
                  const Icon(Icons.exit_to_app, color: Colors.black, size: 30),
              onPressed: () {
                _showSignOutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFDBC7A1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ID: ${widget.userId}'), // Display userId
              if (selectedRecipient == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Search Recipient'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            String searchText = _searchController.text;
                            log('ค้นหาเบอร์โทร: $searchText');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              if (selectedRecipient == null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: filteredRecipients.map((recipient) {
                        // ใช้ filteredRecipients ที่ถูกกรอง
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(recipient
                                .image), // ตรวจสอบให้แน่ใจว่าฟิลด์นี้มีข้อมูล
                          ),
                          title: Text(recipient.name), // แสดงชื่อ
                          subtitle: Text(recipient.phone), // แสดงเบอร์โทรศัพท์
                          onTap: () {
                            setState(() {
                              selectedRecipient = recipient; // เลือก recipient
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              if (selectedRecipient != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Card(
                      color: const Color(0xFFF1DBB7),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(selectedRecipient!.image),
                              ),
                              title: Text(selectedRecipient!.name),
                              subtitle: Text(selectedRecipient!.phone),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _resetRecipientSelection,
                                child: const Text('Change'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _imageFile == null
                                ? GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SafeArea(
                                            child: Wrap(
                                              children: <Widget>[
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.photo_library),
                                                  title: const Text(
                                                      'Choose from gallery'),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.gallery);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.camera_alt),
                                                  title: const Text(
                                                      'Take a picture'),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.camera);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 150,
                                      child: const Icon(Icons.camera_alt,
                                          size: 50, color: Colors.grey),
                                    ),
                                  )
                                : Image.file(
                                    File(_imageFile!.path),
                                    height: 150,
                                  ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _descriptionController,
                              maxLength: 200,
                              minLines: 5,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Details...',
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Please select the point where the driver will pick up the item.',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 250,
                              child: Stack(
                                children: [
                                  FlutterMap(
                                    mapController: mapController,
                                    options: MapOptions(
                                      initialCenter: _selectedLocation,
                                      initialZoom: 15.0,
                                      onTap: (tapPosition, point) {
                                        setState(() {
                                          _selectedLocation = point;
                                          mapController.move(
                                              point, mapController.camera.zoom);
                                        });
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
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: FloatingActionButton(
                                      onPressed: _moveToCurrentLocation,
                                      child: const Icon(Icons.my_location),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Add the Send Button below the map
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                ),
                                onPressed: () async {
                                  await _uploadImage(); // เรียกใช้งานฟังก์ชันเพื่ออัพโหลดภาพ
                                },
                                child: const Text('Send'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSignOutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () => signOut(context),
            ),
          ],
        );
      },
    );
  }

  void CheckStatu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Checkstatus(userId: widget.userId)),
    );
  }

  void signOut(BuildContext context) {
    final box = GetStorage(); // สร้าง instance ของ GetStorage
    box.remove('isLoggedIn'); // ลบสถานะการล็อกอิน

    // นำทางกลับไปยังหน้า Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> loadDataAsync() async {
    var res = await http.get(Uri.parse('$server/GetUsers'));
    log(res.body);

    // แปลง JSON เป็น List<GetUsers>
    users = getUsersFromJson(res.body);
    log(users.length.toString());

    // แปลง List<GetUsers> เป็น List<Recipient>
    recipients = users.map((user) {
      return Recipient(user.userName, user.userPhone,
          user.userImage); // ตรวจสอบว่า user มีฟิลด์เหล่านี้
    }).toList();

    log('Total recipients: ${recipients.length}'); // แสดงจำนวน recipients ที่เพิ่มเข้ามา

    // อัปเดต filteredRecipients หลังจากโหลดข้อมูล
    setState(() {
      filteredRecipients = recipients; // อัปเดตตัวกรอง recipients
    });
  }

  // ฟังก์ชันสำหรับอัพโหลดภาพไปยัง Firebase Storage

// ฟังก์ชันสำหรับอัพโหลดไฟล์และบันทึก URL
  Future<void> _uploadImage() async {
  if (_imageFile != null) {
    // สร้างชื่อไฟล์สำหรับอัพโหลดไปยังโฟลเดอร์ test
    String fileName = 'test/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // อัพโหลดไฟล์ไปยัง Firebase Storage
    try {
      File imageFile = File(_imageFile!.path);
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(fileName).putFile(imageFile);

      // รับ URL ของไฟล์ที่อัพโหลด
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // บันทึก URL ลง Firestore
      await FirebaseFirestore.instance
          .collection('your_collection_name') // เปลี่ยนชื่อที่นี่
          .add({
        'imageUrl': downloadUrl,
        'description': _descriptionController.text,
        'location': GeoPoint(
          _selectedLocation.latitude,
          _selectedLocation.longitude,
        ),
      });

      // แสดงข้อความสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload successful!')),
      );
    } catch (e) {
      log('upload :$e');
    }
  } else {
    // หากไม่มีไฟล์ให้แสดงข้อความ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select an image.')),
    );
  }
}

}
