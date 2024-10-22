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
    return Scaffold(
        appBar: AppBar(
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
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('User'),
              ],
            ),
          ),
        ),
        body: Container(
          color: const Color(0xFFE2DBBF),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'User ID: ${widget.userId}'), // ใช้ widget.userId เพื่อเข้าถึง userId
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Sender(userId: widget.userId)), // ส่ง userId
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
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                          ],
                        ),
                        Image.asset(
                          'assets/image/black-turtle.png',
                          width: 50,
                          height: 150,
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
                    MaterialPageRoute(
                      builder: (context) =>
                          Receiver(userId: widget.userId), // ส่ง userId
                    ),
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
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                          ],
                        ),
                        Image.asset(
                          'assets/image/box.jpg',
                          width: 50,
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                                Homeuser(userId: widget.userId)), // ส่ง userId
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
}
