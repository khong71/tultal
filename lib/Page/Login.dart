import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tultal/Page/Homeraider.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Registerdriver.dart';
import 'package:tultal/Page/Registeruser.dart';
import 'package:tultal/config/config.dart';
import 'package:tultal/model/res/LoginRaider.dart';
import 'package:tultal/model/res/getUser.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  final box = GetStorage(); // สร้าง instance ของ GetStorage

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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEADABC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              // Turtle image
              Image.asset(
                'assets/image/logo.png',
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Turtle Driver',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Email text field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Password text field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 30),
              // Sign in button
              ElevatedButton(
                onPressed: () => signIn(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Sign In',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => registerUser(context),
                    child: const Text('Register',
                        style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () => registerDriver(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD2B48C),
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Apply for work',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Registeruser()),
    );
  }

  void registerDriver(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Registerdriver()),
    );
  }

  void signIn(BuildContext context) async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final box = GetStorage(); // สร้าง instance ของ GetStorage ที่นี่

  var data = GetUser(
    userEmail: email,
    userPassword: password,
  );

  // แสดง popup กำลังโหลด
  showLoadingDialog(context);

  try {
    final response = await http.post(
      Uri.parse('$server/LoginUser'),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: getUserToJson(data), // แปลงข้อมูลเป็น JSON ก่อนส่ง
    );

    Navigator.pop(context); // ปิด popup กำลังโหลด

    if (response.statusCode == 200) {
      log('Login successful');
      
      // ดึง userId จาก response
      final responseData = jsonDecode(response.body);
      final userId = responseData['user']['user_id']; // ตรวจสอบว่ามีคีย์นี้อยู่ใน response

      log(response.body);
      // เมื่อผู้ใช้ล็อกอินสำเร็จ
      box.write('isLoggedIn', true); // เก็บสถานะการล็อกอิน
      box.write('userType', 'user'); // เก็บประเภทผู้ใช้เป็น 'user'
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homeuser(userId: userId), // ส่ง userId ไปยัง Homeuser
        ),
      );
    } else {
      log('User login failed, attempting raider login...');
      signInRaider(context);
    }
  } catch (error) {
    Navigator.pop(context); // ปิด popup กำลังโหลดในกรณีที่เกิดข้อผิดพลาด
    log('Login request failed: $error');
    // แสดง popup ข้อผิดพลาด
    showErrorDialog(context, 'The username or password is incorrect.');
  }
}

void signInRaider(BuildContext context) async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final box = GetStorage(); // สร้าง instance ของ GetStorage ที่นี่

  var data = LoginRaider(
    raiderEmail: email,
    raiderPassword: password,
  );

  // แสดง popup กำลังโหลด
  showLoadingDialog(context);

  try {
    final response = await http.post(
      Uri.parse('$server/LoginDriver'),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: loginRaiderToJson(data), // แปลงข้อมูลเป็น JSON ก่อนส่ง
    );

    Navigator.pop(context); // ปิด popup กำลังโหลด

    if (response.statusCode == 200) {
      log('Raider login successful');
      log(response.body);
      
      // ดึง raider_id จาก response
      final responseData = jsonDecode(response.body);
      final raiderId = responseData['driver']['raider_id']; // ตรวจสอบว่ามีคีย์นี้อยู่ใน response

      // เมื่อผู้ใช้ล็อกอินสำเร็จ
      box.write('isLoggedIn', true); // เก็บสถานะการล็อกอิน
      box.write('userType', 'raider'); // เก็บประเภทผู้ใช้เป็น 'raider'

      // ส่ง raiderId ไปยัง Homeraider
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homeraider(raiderId: raiderId), // ส่ง raiderId
        ),
      );
    } else {
      log('Raider login failed');
      // แสดง popup ข้อผิดพลาด
      showErrorDialog(context, 'The username or password is incorrect.');
    }
  } catch (error) {
    Navigator.pop(context); // ปิด popup กำลังโหลดในกรณีที่เกิดข้อผิดพลาด
    log('Raider login request failed: $error');
    // แสดง popup ข้อผิดพลาด
    showErrorDialog(context, 'A connection error occurred.');
  }
}


  // แสดง popup กำลังโหลด
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // ไม่ให้ผู้ใช้กดออกจาก popup ได้
    builder: (BuildContext context) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Loading..."),
            ],
          ),
        ),
      );
    },
  );
}

// แสดง popup ข้อผิดพลาด
void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("ERROR"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("ตกลง"),
            onPressed: () {
              Navigator.of(context).pop(); // ปิด popup
            },
          ),
        ],
      );
    },
  );
}

}
