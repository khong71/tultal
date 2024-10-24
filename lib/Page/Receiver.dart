// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Login.dart';
import 'package:tultal/config/config.dart';
import 'package:tultal/model/res/GetOrderSendList.dart';
import 'package:tultal/model/res/GetOrdersreceiverList.dart';

class Receiver extends StatefulWidget {
  final int userId;
  const Receiver({super.key, required this.userId});

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  List<GetOrdersreceiverList> orders = []; // สร้าง List สำหรับเก็บข้อมูลที่ได้จาก API
  bool isLoading = true; // สถานะการโหลดข้อมูล
  String server = '';

  @override
  void initState() {
    super.initState();
    fetchOrders(); // เรียกฟังก์ชันเพื่อดึงข้อมูลเมื่อเริ่มต้น
    Config.getConfig().then(
      (value) {
        log(value['serverAPI']); // แสดงค่าใน log สำหรับการ debug
        setState(() {
          server = value['serverAPI']; // อัปเดตค่า server
        });
        fetchOrders(); // เรียกใช้ฟังก์ชันโหลดข้อมูล
      },
    );
  }

  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse(
        '$server/GetOrdersreceiverList?id=${widget.userId}')); // URL ดึงข้อมูลที่กำหนดไว้

    if (response.statusCode == 200) {
      // ถ้าการเรียก API สำเร็จ
      setState(() {
        orders = getOrdersreceiverListFromJson(response.body); // แปลง JSON และเก็บใน List
        isLoading = false; // เปลี่ยนสถานะการโหลดข้อมูล
      });
    } else {
      // ถ้าการเรียก API ล้มเหลว
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2DBBF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homeuser(userId: widget.userId),
              ),
            );
          },
        ),
        title: const Text('SendList', style: TextStyle(color: Colors.black)),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE2DBBF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homeuser(userId: widget.userId),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.black, size: 30),
              onPressed: () => signOut(context), // ฟังก์ชัน signOut
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFDBC7A1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // แสดง loading indicator
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: orders.length, // จำนวนรายการจาก API
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(order.userImage), // รูปผู้รับจากฐานข้อมูล
                                  radius: 25,
                                ),
                                title: Text(
                                  order.userName, // ชื่อผู้รับจากฐานข้อมูล
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(order.userPhone), // เบอร์โทรจากฐานข้อมูล
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.brown, // Brown for the button
                                    foregroundColor: Colors.white, // White text
                                  ),
                                  child: const Text('เช็ค'),
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
}
