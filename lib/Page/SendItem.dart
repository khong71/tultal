import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Homeuser.dart';
import 'package:tultal/Page/Login.dart';
import 'package:tultal/config/config.dart';
import 'package:tultal/model/res/GetOrderSendList.dart';

class Senditem extends StatefulWidget {
  final int userId;
  const Senditem({super.key, required this.userId});

  @override
  State<Senditem> createState() => _SenditemState();
}

class _SenditemState extends State<Senditem> {
  List<GetOrderSendList> orders = [];
  bool isLoading = true;
  String server = '';

  @override
  void initState() {
    super.initState();
    fetchOrders();
    Config.getConfig().then(
      (value) {
        log(value['serverAPI']);
        setState(() {
          server = value['serverAPI'];
        });
        fetchOrders();
      },
    );
  }

  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse(
        '$server/GetOrdersSendList?id=${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        orders = getOrderSendListFromJson(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2DBBF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homeuser(userId: widget.userId),
              ),
            );
          },
        ),
        title: const Text('SendList', style: TextStyle(color: Colors.black)),
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
                  MaterialPageRoute(
                    builder: (context) => Homeuser(userId: widget.userId),
                  ),
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
      body: Container(
        color: const Color(0xFFDBC7A1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(order.userImage),
                                  radius: 25,
                                ),
                                title: Text(
                                  order.userName,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(order.userPhone),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    log('Order Receiver ID: ${order.orderReceiverId}');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Checkstatus(
                                          userId: widget.userId,
                                          orderInfo: order.orderInfo,
                                          orderImage: order.orderImage,
                                          userName: order.userName,
                                          userPhone: order.userPhone,
                                          userImage: order.userImage,
                                          orderReceiverId: order.orderReceiverId, 
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.brown,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('เช็ค'),
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
    final box = GetStorage();
    box.remove('isLoggedIn');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
