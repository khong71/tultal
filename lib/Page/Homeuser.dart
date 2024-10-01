// ignore_for_file: prefer_const_constructors, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class Homeuser extends StatefulWidget {
  const Homeuser({super.key});

  @override
  State<Homeuser> createState() => _HomeuserState();
}

class _HomeuserState extends State<Homeuser> {
  String? username; // ตัวแปรสำหรับเก็บชื่อผู้ใช้

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home User'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Home Page Content"),
              if (username != null) // แสดงชื่อผู้ใช้หากมี
                Text("Username: $username"),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Column(
                      children: [
                        Icon(Icons.home, color: Colors.black, size: 30),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Column(
                      children: [
                        Icon(Icons.all_inbox, color: Colors.black, size: 30),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Column(
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.black, size: 30),
                      ],
                    ),
                    onPressed: () => signOut(),
                  ),
                ])));
  }

  void signOut() {
  }
}
