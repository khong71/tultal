// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:tultal/Page/Login.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: LoginPage(),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tultal/Page/Homeraider.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Login.dart';



void main() async {
  GetStorage.init(); // เริ่มต้น GetStorage
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage(); // สร้าง instance ของ GetStorage
    bool isLoggedIn = box.read('isLoggedIn') ?? false; // อ่านสถานะล็อกอิน (ค่าเริ่มต้นคือ false ถ้าไม่มีการบันทึกค่า)
    String userType = box.read('userType') ?? ''; // ตรวจสอบประเภทของผู้ใช้ (user/raider)
    int userId = box.read('userId') ?? 0; // อ่าน userId (ค่าเริ่มต้นคือ 0 ถ้าไม่มีการบันทึกค่า)
    int raiderId = box.read('userId') ?? 0;

    return MaterialApp(
      title: 'Flutter Demo',
      home: isLoggedIn 
          ? (userType == 'user' ? Homeuser(userId: userId) : Homeraider(raiderId: raiderId)) // ถ้าเป็น user ไปหน้า Homeuser ถ้าเป็น raider ไปหน้า Homeraider
          : LoginPage(), // ถ้ายังไม่ล็อกอินให้ไปหน้า LoginPage
    );
  }
}