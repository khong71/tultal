import 'package:flutter/material.dart';
import 'package:tultal/Page/Login.dart';
import 'package:tultal/Page/Profileraider.dart';

class Homeraider extends StatefulWidget {
  const Homeraider({super.key});

  @override
  State<Homeraider> createState() => _HomeraiderState();
}

class _HomeraiderState extends State<Homeraider> {
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SingOut'),
          content: const Text('Are you sure you want to leave?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst); 
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()), 
                );
              },
              child: const Text('ok'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ยกเลิก
              },
              child: const Text('cancle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // เรียกแสดงกล่องโต้ตอบเมื่อกดปุ่มย้อนกลับ
        _showLogoutDialog();
        return false; // ปิดหน้าต่างในขณะนี้
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEADABC), // Background color
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
                MaterialPageRoute(builder: (context) => const Profileraider()),
              );
            },
          ),
          title: const Text('Hello, raider', style: TextStyle(color: Colors.black)),
        ),
        body: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/image/turtle.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'List', // 'List' header
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    listItem('ผู้รับ', '0800000000'),
                    const SizedBox(height: 10),
                    listItem('ผู้รับ', '0800000001'),
                    const SizedBox(height: 10),
                    listItem('ผู้รับ', '0800000002'),
                    const SizedBox(height: 10),
                    listItem('ผู้รับ', '0800000003'),
                    const SizedBox(height: 10),
                    listItem('ผู้รับ', '0800000004'),
                    const SizedBox(height: 10),
                    listItem('ผู้รับ', '0800000005'),
                    const SizedBox(height: 10),
                    listItem('ผู้รับ', '0800000006'),
                    const SizedBox(height: 10),
                    listItem('ผู้รับ', '0800000007'),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Bottom drawer with icons
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.person_outline, size: 40),
                onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profileraider()),
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

  Widget listItem(String title, String phoneNumber) {
    return Container(
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
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
              'https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png'), // Profile image
        ),
        title: Text(title),
        subtitle: Text(phoneNumber),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            // Button action
          },
          child: const Text(
            'Job work',
            const SizedBox(height: 30),
            const SizedBox(height: 20),
                const Text('Password'),
                const SizedBox(height: 8),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
