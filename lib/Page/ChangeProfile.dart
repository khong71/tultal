// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Changeprofile extends StatefulWidget {
  const Changeprofile({super.key});

  @override
  State<Changeprofile> createState() => _ChangeprofileState();
}

class _ChangeprofileState extends State<Changeprofile> {
  late Future<void> loadData;

  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // ไอคอนย้อนกลับ
          onPressed: () {
            Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
          },
        ),
        title: Text('Chang Profile'), // ชื่อหน้าปัจจุบัน
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'),
                );
              }

              fullnameCtl.text = 'gg';
              emailCtl.text = 'gg';
              phoneCtl.text = 'gg';

              return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    SizedBox(
                      width: 200,
                      height: 200, // เพิ่ม height เพื่อให้ได้ขนาดวงกลม
                      child: ClipOval(
                        child: Image.network(
                          'https://png.pngtree.com/thumb_back/fh260/background/20230610/pngtree-an-orange-kitten-sitting-on-a-table-with-drops-of-water-image_2935343.jpg',
                          fit:
                              BoxFit.cover, // ทำให้รูปภาพครอบคลุมพื้นที่ทั้งหมด
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Username'),
                          TextField(
                            controller: fullnameCtl,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('E-mail'),
                          TextField(
                            controller: phoneCtl,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Address'),
                          TextField(
                            controller: emailCtl,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: FilledButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Changeprofile()),
                          );
                        },
                        child: const Text('Change'),
                      )),
                    )
                  ]));
            }),
      ),
    );
  }

  Future<void> loadDataAsync() async {}
}
