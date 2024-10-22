import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Login.dart';

class Senditem extends StatefulWidget {
  final int userId;
  const Senditem({super.key, required this.userId});

  @override
  State<Senditem> createState() => _SenditemState();
}

class _SenditemState extends State<Senditem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2DBBF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
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
              icon: const Column(
                children: [
                  Icon(Icons.home, color: Colors.black, size: 30),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homeuser(userId: widget.userId),
                  ), // นำทางไปยังหน้า Homeuser
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'รายการที่รอส่งของ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 2, // จำนวนผู้ส่งที่รอ
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/image/logo.png'), // รูปโปรไฟล์
                            radius: 25,
                          ),
                          title: const Text(
                            'ผู้รับ',
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: const Text('0811111111'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // นำทางไปยังหน้า CheckStatus
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Checkstatus(userId: widget.userId),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.brown, // Brown for the button
                              foregroundColor: Colors.white, // White text
                            ),
                            child: const Text(
                              'เช็ค',
                            ),
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

  void CheckStatu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Checkstatus(userId: widget.userId)),
    );
  }
}
