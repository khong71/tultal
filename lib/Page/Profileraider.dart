import 'package:flutter/material.dart';
import 'package:tultal/Page/Changeraider.dart';

class Profileraider extends StatefulWidget {
  final int raiderId;
  const Profileraider({super.key, required this.raiderId});

  @override
  State<Profileraider> createState() => _ProfileraiderState();
}

class _ProfileraiderState extends State<Profileraider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDBC7A1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFDBC7A1),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('User ID: ${widget.raiderId}'),
            const CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey,

              //แสดงรูปผู้ใช้ตรงนี้น่ะ
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Username'),
            ),
            const SizedBox(height: 8),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              enabled: false, // Make the TextField non-editable
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('License Plate'),
            ),
            const SizedBox(height: 8),
            TextField(
              enabled: false, // Make the TextField non-editable
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Changeraider(raiderId: widget.raiderId)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A3827), // Dark brown color
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Change',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
