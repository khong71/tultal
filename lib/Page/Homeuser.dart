// ignore_for_file: prefer_const_constructors, avoid_types_as_parameter_names, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Login.dart';
import 'package:tultal/Page/ProfilePage.dart';
import 'package:tultal/Page/Receiver.dart';
import 'package:tultal/Page/Sender.dart';

class Homeuser extends StatefulWidget {
  final int userId;
  const Homeuser({super.key, required this.userId});

  @override
  State<Homeuser> createState() => _HomeuserState();
}

class _HomeuserState extends State<Homeuser> {
  String? username; // ตัวแปรสำหรับเก็บชื่อผู้ใช้

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // ปิดการแสดงปุ่มย้อนกลับใน AppBar
          backgroundColor: const Color(0xFFE2DBBF),
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profilepage(userId: widget.userId)),
              );
            },
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/image/logo.png', // Replace with your image path
                    width: 30,
                    height: 30,
                    fit: BoxFit
                        .cover, // Ensures the image covers the circular area
                  ),
                ),
                const SizedBox(width: 8),
                const Text('User'),
              ],
            ),
          ),
        ),
        body: Container(
          color: const Color(0xFFE2DBBF), // พื้นหลังหลักของหน้าจอ
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Sender()),
                            );
                          },
                          child: Card(
                            color: const Color(0xFFC2B195),
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('ส่งของ',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                  Image.asset(
                                    'assets/image/black-turtle.png',
                                    width: 100,
                                    height: 180,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Receiver()),
                            );
                          },
                          child: Card(
                            color: const Color(0xFFC2B195),
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('รับของ',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                  Image.asset(
                                    'assets/image/box.jpg',
                                    width: 100,
                                    height: 180,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            color: const Color(0xFFE2DBBF),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Column(
                      children: [
                        Icon(Icons.home, color: Colors.black, size: 30),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Homeuser()), // นำทางไปยังหน้า Homeuser
                      );
                    },
                  ),
                  IconButton(
                    icon: const Column(
                      children: [
                        Icon(Icons.all_inbox, color: Colors.black, size: 30),
                      ],
                    ),
                    onPressed: () => CheckStatu(),
                  ),
                  IconButton(
                    icon: const Column(
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.black, size: 30),
                      ],
                    ),
                    onPressed: () => signOut(context),
                  ),
                ])));
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

  void CheckStatu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Checkstatus(userId: widget.userId)),
    );
  }

  // ฟังก์ชันสำหรับแสดงกล่องยืนยันเมื่อผู้ใช้กดปุ่มย้อนกลับ
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SingOut'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              signOut(context); // เรียกฟังก์ชัน signOut เมื่อผู้ใช้กดตกลง
            },
            child: const Text('Ok'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิด dialog เมื่อผู้ใช้กดยกเลิก
            },
            child: const Text('Cancel'),
          ),
        ],
        );
      },
    ) ?? false;
  }

  // ฟังก์ชันสำหรับแสดงกล่องยืนยันเมื่อผู้ใช้กดปุ่มออกจากระบบ
  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SingOut'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              signOut(context); // เรียกฟังก์ชัน signOut เมื่อผู้ใช้กดตกลง
            },
            child: const Text('Ok'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิด dialog เมื่อผู้ใช้กดยกเลิก
            },
            child: const Text('Cancel'),
          ),
        ],
        );
      },
    );
  }
}
