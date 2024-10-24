// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tultal/Page/Login.dart';
import 'dart:developer';

import 'package:tultal/config/config.dart';
import 'package:tultal/model/req/postOrder.dart';
import 'package:tultal/model/res/getUsers.dart'; // For logging search text

import 'package:http/http.dart' as http;

class Recipient {
  final String name;
  final String phone;
  final String image;
  final LatLng location;
  final int userId;
  Recipient(this.name, this.phone, this.image, this.location, this.userId);
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 30),
              onPressed: () {
                // Navigate to home page or replace with the right route
                Navigator.pop(context);
              },
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
                            backgroundImage: AssetImage(recipient
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
                                    AssetImage(selectedRecipient!.image),
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
                            SizedBox(
                              height: 250,
                              child: Stack(
                                children: [
                                  FlutterMap(
                                    mapController: mapController,
                                    options: MapOptions(
                                      initialCenter: selectedRecipient!
                                          .location, // เริ่มต้นที่ตำแหน่งผู้รับ
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
                                          // Marker for the selected recipient
                                          Marker(
                                            point: selectedRecipient!
                                                .location, // ตำแหน่งของผู้รับ
                                            width: 40,
                                            height: 40,
                                            child: const Icon(
                                              Icons
                                                  .person, // ไอคอนรูปคนสำหรับผู้รับ
                                              size: 40,
                                              color: Colors.blue,
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
                                      onPressed: () {
                                        mapController.move(
                                            selectedRecipient!.location,
                                            15.0); // กลับไปที่ผู้รับ
                                      },
                                      backgroundColor: Colors
                                          .brown, // สีน้ำตาลสำหรับพื้นหลังของปุ่ม
                                      foregroundColor:
                                          Colors.white, // สีขาวสำหรับไอคอน
                                      child: const Icon(
                                          Icons.person), // ไอคอนรูปคน
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                onPressed: () {
                                  // Action for send button
                                },
                                child: const Text('Send'),
                              ),
                            ),
                            const SizedBox(
                                height:
                                    20), // เพิ่มพื้นที่ระหว่างปุ่มส่งและข้อความที่จะแสดง
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Your ID: ${widget.userId}\n'
                                'sender ID: ${selectedRecipient!.userId}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
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
    // ทำการเรียกข้อมูลผู้ใช้จาก API
    var res = await http.get(Uri.parse('$server/GetUsers'));
    log(res.body); // แสดงข้อมูลที่ได้รับจากเซิร์ฟเวอร์ใน log

    // สมมุติว่าเซิร์ฟเวอร์ส่งข้อมูล latitude และ longitude เป็นสตริง
    users =
        getUsersFromJson(res.body); // แปลงข้อมูล JSON เป็น List ของ GetUsers
    log(users.length.toString()); // แสดงจำนวนผู้ใช้ที่ได้รับใน log

    // แปลง List<GetUsers> เป็น List<Recipient> พร้อมตำแหน่งที่ตั้ง
    recipients = users
        .map((user) {
          String latLngString = user.userLocation; // ดึงค่าตำแหน่งที่ตั้ง

          // ตรวจสอบว่า latLngString ไม่ใช่ null หรือว่างเปล่า
          if (latLngString != null && latLngString.isNotEmpty) {
            List<String> latLng =
                latLngString.split(','); // แยกสตริงตามเครื่องหมายจุลภาค
            if (latLng.length == 2) {
              try {
                double latitude = double.parse(latLng[0]); // แปลงค่าละติจูด
                double longitude = double.parse(latLng[1]); // แปลงค่าลองจิจูด

                // ส่งคืนอ็อบเจกต์ Recipient เฉพาะเมื่อ userId ไม่ตรงกับผู้ส่ง
                if (user.userId != widget.userId) {
                  // สมมุติว่า user.userId สามารถเข้าถึงได้
                  return Recipient(user.userName, user.userPhone,
                      user.userImage, LatLng(latitude, longitude), user.userId);
                }
              } catch (e) {
                log('Error parsing latLng: $e'); // บันทึกข้อผิดพลาดการแปลง
              }
            }
          }

          // คืนค่า null สำหรับผู้ใช้ที่ไม่ควรเพิ่มใน recipients
          return null;
        })
        .where((recipient) => recipient != null)
        .cast<Recipient>()
        .toList(); // กรอง recipients เพื่อเอาค่าที่เป็น null ออก

    log('Total recipients: ${recipients.length}'); // แสดงจำนวน recipients ที่ได้

    // อัปเดต filteredRecipients หลังจากโหลดข้อมูล
    setState(() {
      filteredRecipients = recipients; // อัปเดต filtered recipients
    });
  }

  void send(int sender, int receiver) async {
    String info = _descriptionController.text;
    String img =
        _imageFile?.path ?? 'No image selected'; // Using null-aware operator

    // Validate input
    if (info.isEmpty) {
      _showDetailErrorDialog();
      log('Error: Order info cannot be empty');
      return;
    }

    // Create the PostOrder object
    var data = PostOrder(
      orderImage: img,
      orderInfo: info,
      orderSenderId: sender.toString(),
      orderReceiverId: receiver.toString(),
    );

    // Log the PostOrder data
    log('PostOrder data: '
        'Order Image: ${data.orderImage}, '
        'Order Info: ${data.orderInfo}, '
        'Sender ID: ${data.orderSenderId}, '
        'Receiver ID: ${data.orderReceiverId}');

    // Sending the POST request
    try {
      final response = await http.post(
        Uri.parse('$server/insertOrder'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: json.encode(data.toJson()),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        log('Order sent successfully: ${response.body}');

        // Show the popup to confirm the order was successful
        _showSuccessDialog();
      } else {
        log('Failed to send order: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      log('Error sending order: $e');
    }
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
      // await FirebaseFirestore.instance
      //     .collection('your_collection_name') // เปลี่ยนชื่อที่นี่
      //     .add({
      //   'imageUrl': downloadUrl,
      //   'description': _descriptionController.text,
      //   'location': GeoPoint(
      //     _selectedLocation.latitude,
      //     _selectedLocation.longitude,
      //   ),
      // });

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


  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dismissal by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Sent'),
          content:
              const Text('Your order has been added to the list successfully!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to HomeUser.dart
              },
            ),
          ],
        );
      },
    );
  }

  void _showDetailErrorDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Missing Details'),
          content: const Text(
              'Please fill in the information in the fields detail.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด popup
              },
            ),
          ],
        );
      },
    );
  }
}
