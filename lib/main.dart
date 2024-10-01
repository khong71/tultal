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

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Login.dart';

void main() async {
  await GetStorage.init(); // เริ่มต้น GetStorage
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage(); // สร้าง instance ของ GetStorage
    bool isLoggedIn = box.read('isLoggedIn') ?? false; // อ่านสถานะล็อกอิน (ค่าเริ่มต้นคือ false ถ้าไม่มีการบันทึกค่า)

    return MaterialApp(
      title: 'Flutter Demo',
      home: isLoggedIn ? Homeuser() : LoginPage(), // ถ้าล็อกอินแล้วให้ไปหน้า Home, ถ้าไม่ให้ไปหน้า Login
    );
  }
}
