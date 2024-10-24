// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tultal/Page/Login.dart';
import 'package:tultal/Page/Profileraider.dart';
import 'package:tultal/Page/work.dart';
import 'package:tultal/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:tultal/model/res/getOrder.dart';

class Homeraider extends StatefulWidget {
  final int raiderId;
  const Homeraider({super.key, required this.raiderId});

  @override
  State<Homeraider> createState() => _HomeraiderState();
}

class _HomeraiderState extends State<Homeraider> {
  String? username; // ตัวแปรสำหรับเก็บชื่อผู้ใช้

  late List<GetOrder> orders = []; // กำหนดค่าเริ่มต้นเป็นลิสต์ว่าง

  late Future<void> loadData;

  String senderId = ''; // กำหนดค่าให้กับ senderId
  String receiverId = ''; // กำหนดค่าให้กับ receiverId
  int orderId = 0; // กำหนดค่าให้กับ orderId

  String server = '';
  @override
  void initState() {
    super.initState();

    Config.getConfig().then(
      (value) {
        log(value['serverAPI']); // แสดงค่าใน log สำหรับการ debug
        setState(() {
          server = value['serverAPI']; // อัปเดตค่า server
        });
        loadDataAsync(); // เรียกใช้ฟังก์ชันโหลดข้อมูล
      },
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SingOut'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                signOut(context); // เรียกฟังก์ชัน signOut เมื่อผู้ใช้กดตกลง
              },
              child: const Text('Ok'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog เมื่อผู้ใช้กดยกเลิก
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void signOut(BuildContext context) {
    final box = GetStorage(); // สร้าง instance ของ GetStorage
    box.remove('isLoggedIn'); // ลบสถานะการล็อกอิน

    // นำทางกลับไปยังหน้า Login โดยใช้ pushReplacement เพื่อแทนที่หน้า Homeraider
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showLogoutDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEADABC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png'),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Profileraider(raiderId: widget.raiderId)),
              );
            },
          ),
          title: const Text('Hello, raider',
              style: TextStyle(color: Colors.black)),
        ),
        body: FutureBuilder(
          future: loadDataAsync(), // ใช้ FutureBuilder เพื่อรอข้อมูล
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'List',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      orders.isEmpty
                          ? Center(child: Text('No orders found'))
                          : Column(
                              children: orders
                                  .map((order) => listItem(
                                      order.orderInfo,
                                      order.orderSenderId,
                                      order.orderReceiverId,
                                      order.orderImage,
                                      order.orderid))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.person_outline, size: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Profileraider(raiderId: widget.raiderId)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, size: 40),
                onPressed: _showLogoutDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItem(String info, String senderid, String receiverId, String img,
      int orderid) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10), // เพิ่มระยะห่างแนวตั้ง
              subtitle: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // จัดตำแหน่งให้กลาง
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png'), // Profile image
                  ),
                  const SizedBox(width: 10), // ระยะห่างระหว่างรูปกับข้อความ
                  Expanded(
                    child: Text(
                      info,
                      textAlign: TextAlign.center, // จัดข้อความให้กลาง
                      style: const TextStyle(fontSize: 16), // ขนาดข้อความ
                    ),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  showJobWorkDialog(info, senderid, receiverId, img, orderid);
                },
                child: const Text(
                  'Job work',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )));
  }

  Future<Map<String, String>> sender(String senderid) async {
    var res = await http.get(Uri.parse('$server/GetUserid?id=$senderid'));

    if (res.statusCode == 200) {
      // แปลงข้อมูล JSON ที่ได้มา
      var userData = jsonDecode(res.body);
      return {
        'user_image': userData[0]['user_image'],
        'user_name': userData[0]['user_name'], // คืนค่าชื่อผู้ใช้
        'user_phone': userData[0]['user_phone'], // คืนค่าเบอร์โทร
      };
    } else {
      log('Failed to load user data');
      return {
        'user_name':
            'Error: Failed to load user data', // คืนค่าชื่อผู้ใช้เป็นข้อความผิดพลาด
        'user_phone': '', // คืนค่าเบอร์โทรเป็นค่าว่าง
      };
    }
  }

  Future<Map<String, String>> receiverId1(String receiverId) async {
    var res = await http.get(Uri.parse('$server/GetUserid?id=$receiverId'));

    if (res.statusCode == 200) {
      // แปลงข้อมูล JSON ที่ได้มา
      var userData = jsonDecode(res.body);
      return {
        'user_image': userData[0]['user_image'],
        'user_name': userData[0]['user_name'], // คืนค่าชื่อผู้ใช้
        'user_phone': userData[0]['user_phone'], // คืนค่าเบอร์โทร
      };
    } else {
      log('Failed to load user data');
      return {
        'user_name': 'Error: Failed to load user data',
        'user_phone': 'N/A', // ค่าที่คืนในกรณีเกิดข้อผิดพลาด
      };
    }
  }

  Future<void> showJobWorkDialog(String info, String senderid,
      String receiverId, String img, int orderid) async {
    log('orderid: $orderid');

    // เรียกใช้ sender และ receiverId1
    Map<String, String> senderInfo = await sender(senderid); // ผลลัพธ์เป็น Map
    Map<String, String> receiverInfo =
        await receiverId1(receiverId); // ผลลัพธ์เป็น Map

    // แยกค่าจาก Map
    String senderName = senderInfo['user_name'] ?? 'Unknown';
    String senderPhone = senderInfo['user_phone'] ?? 'N/A';
    String senderImage = senderInfo['user_image'] ?? ''; // รับภาพผู้ส่ง

    String receiverName = receiverInfo['user_name'] ?? 'Unknown';
    String receiverPhone = receiverInfo['user_phone'] ?? 'N/A';
    String receiverImage = receiverInfo['user_image'] ?? ''; // รับภาพผู้รับ

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sender Section with border
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: senderImage.isNotEmpty
                        ? NetworkImage(senderImage) // แสดงภาพผู้ส่งถ้ามี
                        : NetworkImage(
                            'https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png'), // ใช้ภาพดีฟอลต์ถ้าไม่มี
                  ),
                  title: Text(
                    'Sender: $senderName\nPhone: $senderPhone', // แสดงชื่อผู้ส่งและเบอร์โทร
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Image.network(
                    'https://th.mlb-korea.com/cdn/shop/files/A_8809947353338_01_JPG_841af844-d94e-4cf4-8153-1b7ce2a50eab.jpg?v=1721013006',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    info,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Icon(Icons.arrow_downward),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: receiverImage.isNotEmpty
                        ? NetworkImage(receiverImage) // แสดงภาพผู้รับถ้ามี
                        : NetworkImage(
                            'https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png'), // ใช้ภาพดีฟอลต์ถ้าไม่มี
                  ),
                  title: Text(
                      'Receiver: $receiverName\nPhone: $receiverPhone'), // แสดงชื่อผู้รับและเบอร์โทร
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                    onPressed: () async {
                      await insertwork(context,widget.raiderId,senderid,receiverId,orderid);
                    },
                    child: const Text('Job work',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadDataAsync() async {
    // ทำการเรียกข้อมูลผู้ใช้จาก API
    var res = await http.get(Uri.parse('$server/GetOrders'));

    // ใช้ utf8.decode เพื่อแปลงข้อมูลเป็น UTF-8
    String jsonResponse = utf8.decode(res.bodyBytes);

    // แปลงข้อมูล JSON เป็น object
    orders = getOrderFromJson(jsonResponse);

    log(orders.length.toString());
  }
  

  Future<void> insertwork(BuildContext context, int raiderId, String senderId, String receiverId, int orderId) async {
  var response = await http.post(
    Uri.parse('$server/InsertDrive'),
    body: {
      'drive_image1': '',
      'drive_image2': '',
      'order_id': '$orderId',
      'drive_status': '0',
      'raider_id': '$raiderId',
    },
  );

  if (response.statusCode == 200) {
    // ถ้า insert สำเร็จ ทำการดำเนินการต่อ
    print('Insert successful');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Work(
          raiderId: raiderId, // ต้องส่งค่าเป็น int
          senderid: senderId, // ต้องส่งค่าเป็น String
          receiverId: receiverId, // ต้องส่งค่าเป็น String
          orderid: orderId, // ต้องส่งค่าเป็น int
        ),
      ),
    );
  } else {
    // ถ้า insert ไม่สำเร็จ แสดง error message
    print('Insert failed with status: ${response.statusCode}');
  }
}


}
