// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tultal/Page/Homeuser.dart';

class Checkstatus extends StatefulWidget {
  final int userId;
  const Checkstatus({super.key, required this.userId});

  @override
  State<Checkstatus> createState() => _CheckstatusState();
}

class _CheckstatusState extends State<Checkstatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2DBBF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // ไอคอนย้อนกลับ
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Homeuser(
                      userId: widget.userId)), // นำทางกลับไปยังหน้า Homeuser
            );
          },
        ),
        title: Text('Check Status'), // ชื่อหน้าปัจจุบัน
      ),
      body: Center(
        child: Text(
          'User ID: ${widget.userId}',
        ),
      ),
    );
  }
}
