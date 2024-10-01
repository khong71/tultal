import 'package:flutter/material.dart';
import 'package:tultal/Page/Homeraider.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Registerdriver.dart';
import 'package:tultal/Page/Registeruser.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

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
                  style: TextStyle(color: Colors.red),
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
                child: const Text('Sign In', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => registerUser(context),
                    child: const Text('Register', style: TextStyle(color: Colors.black)),
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
                    child: const Text('Apply for work', style: TextStyle(color: Colors.white)),
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
  
  void signIn(BuildContext context) {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  // Example user validation
  if (email == '1' && password == '1') {
   
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homeuser()),
    );
  } else {
    // แสดงข้อความผิดพลาด
    setState(() {
      errorMessage = 'Invalid email or password';
    });
  }
}




}
