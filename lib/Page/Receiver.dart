// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Login.dart';

class Receiver extends StatefulWidget {
  final int userId;
  const Receiver({super.key, required this.userId});

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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Receiver', style: TextStyle(color: Colors.black)),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE2DBBF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 30),
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
              icon: const Icon(Icons.all_inbox, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Checkstatus(userId: widget.userId)),
                );
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.exit_to_app, color: Colors.black, size: 30),
              onPressed: () => signOut(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: ${widget.userId}',
            ),
            Text('รายการที่รอรับของ', style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: 2, // จำนวนรายการ
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/image/logo.png'), // ใส่รูปภาพโปรไฟล์ที่นี่
                          radius: 30,
                        ),
                        title: Text('ผู้ส่ง'),
                        subtitle: Text('0811111111'),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF795548), // ปรับสีปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Checkstatus(userId: widget.userId)),
                            );
                          },
                          child: Text('เช็ค',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signOut(BuildContext context) {
    final box = GetStorage();
    box.remove('isLoggedIn');
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
