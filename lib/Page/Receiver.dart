// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Login.dart';
import 'package:tultal/config/config.dart';
import 'package:tultal/model/res/getOrderReceiver.dart';

class Receiver extends StatefulWidget {
  final int userId;
  const Receiver({super.key, required this.userId});

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  List<GetOrderReceiver> orders = []; // สร้าง List สำหรับเก็บข้อมูลที่ได้จาก API
  bool isLoading = true; // สถานะการโหลดข้อมูล
  String server = ''; // ประกาศตัวแปร server

  @override
  void initState() {
    super.initState();
    Config.getConfig().then((value) {
      log(value['serverAPI']); // แสดงค่าใน log สำหรับการ debug
      setState(() {
        server = value['serverAPI']; // อัปเดตค่า server
      });
      fetchOrders(); // เรียกฟังก์ชันเพื่อดึงข้อมูลเมื่อเริ่มต้น
    });
  }

  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse('$server/GetOrdersId?id=${widget.userId}'));

    if (response.statusCode == 200) {
      // ถ้าการเรียก API สำเร็จ
      setState(() {
        orders = getOrderReceiverFromJson(response.body); // แปลง JSON และเก็บใน List
        isLoading = false; // เปลี่ยนสถานะการโหลดข้อมูล
      });
    } else {
      // ถ้าการเรียก API ล้มเหลว
      setState(() {
        isLoading = false; // เปลี่ยนสถานะการโหลดข้อมูล
      });
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDBC7A1),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Homeuser(userId: widget.userId)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.black, size: 30),
              onPressed: () => signOut(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // แสดง loading indicator
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User ID: ${widget.userId}'),
                  Text('Items waiting to be received', style: TextStyle(fontSize: 15)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length, // จำนวนรายการจาก API
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(order.userImage), // ใช้ NetworkImage สำหรับการโหลดภาพ
                                radius: 30,
                              ),
                              title: Text(order.username), // แสดงชื่อผู้ส่ง
                              subtitle: Text(order.userPhone), // แสดงเบอร์โทร
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
                                    MaterialPageRoute(builder: (context) => Checkstatus(userId: widget.userId)),
                                  );
                                },
                                child: Text('เช็ค', style: TextStyle(color: Colors.white)),
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
}
