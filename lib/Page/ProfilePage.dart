// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tultal/Page/ChangeProfile.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late Future<void> loadData;

  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();

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
        title: Text('Profile'), // ชื่อหน้าปัจจุบัน
      ),
      body: Container(
        color: const Color(0xFFDBC7A1),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey,

              //แสดงรูปผู้ใช้ตรงนี้น่ะ
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Username'),
            ),
            const SizedBox(height: 8),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              enabled: false, // Make the TextField non-editable
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('address'),
            ),
            const SizedBox(height: 8),
            TextField(
              enabled: false, // Make the TextField non-editable
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Changeprofile()),
                );
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
                'Change',
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
