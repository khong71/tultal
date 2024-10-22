// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Login.dart';

class Sender extends StatefulWidget {
  final int userId;
  const Sender({super.key, required this.userId});

  @override
  State<Sender> createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  final TextEditingController _searchController =
      TextEditingController(); // ตัวควบคุมสำหรับ TextField

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2DBBF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // ไอคอนย้อนกลับ
          onPressed: () {
            Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
          },
        ),
        title: Text('Sender'), // ชื่อหน้าปัจจุบัน
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
                      builder: (context) => Homeuser(
                          userId: widget.userId)), // นำทางไปยังหน้า Homeuser
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
              onPressed: () => signOut(context), // ฟังก์ชัน signOut
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFDBC7A1),
        child: Column(
          children: [
            Text('User ID: ${widget.userId}'),
            Padding(
              padding: const EdgeInsets.all(
                  20.0), // กำหนดค่า padding เป็น 20.0 สำหรับทุกด้าน
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // จัดเรียงให้ชิดซ้าย
                children: [
                  const Text('ค้นหาเบอร์โทรผู้รับ'), // ข้อความค้นหา
                  const SizedBox(
                      height: 8), // ช่องว่างระหว่างข้อความกับ TextField
                  TextField(
                    controller: _searchController, // เชื่อมต่อกับตัวควบคุม
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      suffixIcon: IconButton(
                        // ปุ่มแว่นขยาย
                        icon: const Icon(Icons.search), // ไอคอนแว่นขยาย
                        onPressed: () {
                          // ล็อกสิ่งที่พิมพ์ออกมา
                          String searchText =
                              _searchController.text; // เก็บค่าที่ถูกพิมพ์
                          log('ค้นหาเบอร์โทร: $searchText'); // ตัวอย่างการทำงาน
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    color: Color(0xFFF1DBB7),
                    elevation: 5, // กำหนดระดับเงา
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // มุมโค้ง
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(
                            8.0), // เพิ่ม padding รอบๆ TextField
                        child: TextField(
                          textAlign: TextAlign.center, // จัดข้อความไปกลาง
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // กำหนดขอบของ TextField
                            hintText:
                                'กรอกข้อความที่นี่', // ข้อความตัวอย่างใน TextField
                          ),
                          style: const TextStyle(fontSize: 16), // ขนาดตัวอักษร
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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

  void CheckStatu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Checkstatus(userId: widget.userId)),
    );
  }
}
