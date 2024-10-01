import 'package:flutter/material.dart';

class Homeraider extends StatefulWidget {
  const Homeraider({super.key});

  @override
  State<Homeraider> createState() => _HomeraiderState();
}

class _HomeraiderState extends State<Homeraider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEADABC), // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png'), // Online profile image
          ),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ProfilePage()),
            // );
          },
        ),
        title: const Text('Hello, raider', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'รายการ', // 'List' header
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
      // Bottom drawer with icons
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.person_outline, size: 30),
                onPressed: () {
                  // Navigate to another page
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, size: 30),
                onPressed: () {
                  // Logout action
                },
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
          child: const Text('Job work'
          ,style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
