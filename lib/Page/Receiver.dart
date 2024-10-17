// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Login.dart';

class Receiver extends StatefulWidget {
  const Receiver({super.key});

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
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
        title: Text('Receiver'), // ชื่อหน้าปัจจุบัน
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
              onPressed: () => signOut(context), // ฟังก์ชัน signOut
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Your Page Content Here'), // เนื้อหาของหน้า
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
      MaterialPageRoute(builder: (context) => Checkstatus()),
    );
  }
}
