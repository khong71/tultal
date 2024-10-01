// ignore_for_file: prefer_const_constructors, avoid_types_as_parameter_names, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tultal/Page/ProfilePage.dart';
import 'package:tultal/Page/Sender.dart';

class Homeuser extends StatefulWidget {
  const Homeuser({super.key});

  @override
  State<Homeuser> createState() => _HomeuserState();
}

class _HomeuserState extends State<Homeuser> {
  String? username; // ตัวแปรสำหรับเก็บชื่อผู้ใช้

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profilepage()),
              );
            },
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/image/logo.png', // Replace with your image path
                    width: 30, // Adjust size as needed
                    height: 30,
                    fit: BoxFit
                        .cover, // Ensures the image covers the circular area
                  ),
                ),
                const SizedBox(width: 8), // Space between image and text
                const Text('Home User'),
              ],
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Sender()),
                  );
                },
                child: Card(
                  elevation: 20, // ระดับความสูงของเงา
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // มุมโค้งของการ์ด
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        20.0), // ปรับขนาด padding ให้เหมาะสม
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // จัดเรียงแบบซ้าย-ขวา
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize
                              .min, // ขนาดของคอลัมน์จะเป็นไปตามเนื้อหา
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // จัดเรียงข้อความไปทางซ้าย
                          children: [
                            Text('ส่งของ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                          ],
                        ),
                        // ตัวอย่างรูปภาพ
                        Image.asset(
                          'assets/image/logo.png', // แทนที่ด้วยที่อยู่ของรูปภาพที่ต้องการ
                          width: 50, // กำหนดความกว้างของรูปภาพ
                          height: 150, // กำหนดความสูงของรูปภาพ
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50), // ระยะห่างระหว่างการ์ด
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Sender()),
                  );
                },
                child: Card(
                  elevation: 20, // ระดับความสูงของเงา
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // มุมโค้งของการ์ด
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        20.0), // ปรับขนาด padding ให้เหมาะสม
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // จัดเรียงแบบซ้าย-ขวา
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize
                              .min, // ขนาดของคอลัมน์จะเป็นไปตามเนื้อหา
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // จัดเรียงข้อความไปทางซ้าย
                          children: [
                            Text('รับของ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                          ],
                        ),
                        // ตัวอย่างรูปภาพ
                        Image.asset(
                          'assets/image/logo.png', // แทนที่ด้วยที่อยู่ของรูปภาพที่ต้องการ
                          width: 50, // กำหนดความกว้างของรูปภาพ
                          height: 150, // กำหนดความสูงของรูปภาพ
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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.home, color: Colors.black, size: 30),
                  ],
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.all_inbox, color: Colors.black, size: 30),
                  ],
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.black, size: 30),
                  ],
                ),
                onPressed: () => signOut(),
              ),
            ])));
  }

  void signOut() {}
}
