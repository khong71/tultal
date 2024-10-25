// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:tultal/Page/Homeraider.dart';
import 'package:tultal/Page/Sender.dart';
import 'package:tultal/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:tultal/model/res/getSender.dart';

class Work extends StatefulWidget {
  final int raiderId;
  final String senderid;
  final String receiverId;
  final int orderid;

  const Work({
    required this.raiderId,
    required this.senderid,
    required this.receiverId,
    required this.orderid,
  });

  @override
  State<Work> createState() => _WorkState();
}

class _WorkState extends State<Work> {
  int status =
      0; // 0: en route to pickup, 1: picked up, 2: en route to destination, 3: delivered
  final ImagePicker _picker = ImagePicker();
  XFile? pickupImage;
  XFile? deliveryImage;
  double? senderLatitude;
  double? senderLongitude;
  double? receiverLatitude;
  double? receiverLongitude;

  // Geolocation variables
  Position? _currentPosition;

  String server = '';
  @override
  void initState() {
    super.initState();

    // ดึงค่าการตั้งค่า serverAPI
    Config.getConfig().then((value) {
      if (value != null && value['serverAPI'] != null) {
        log('Server API: ${value['serverAPI']}'); // แสดงค่าใน log สำหรับการ debug
        setState(() {
          server = value['serverAPI']; // อัปเดตค่า server
        });

        // เรียกใช้ฟังก์ชัน Sender และ receiver หลังจากตั้งค่า server เสร็จ
        Sender(widget.senderid);
        receiver(widget.receiverId);
      } else {
        log('Failed to retrieve serverAPI from config'); // แสดง log หากไม่ได้ค่าจากการตั้งค่า
      }
    }).catchError((error) {
      log('Error retrieving config: $error'); // แสดง log เมื่อเกิดข้อผิดพลาด
    });
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      // Handle location error
      log('Location error: $e');
      // Default position can be set as fallback
      if (mounted) {
        setState(() {
          _currentPosition = Position(
            latitude: 16.246825669508297,
            longitude: 103.25199289277295,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
            isMocked: false,
          );
        });
      }
    }
  }

  // Function to update status and turtle position
  void _updateStatus(int newStatus) {
    setState(() {
      status = newStatus;
    });
  }

  // Image picker function
  Future<void> _pickImage(bool isPickup) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() async {
      if (isPickup) {
        pickupImage = image;

        var url = Uri.parse('$server/Putstatus?id=${widget.orderid}');

        // Create the request body
        var requestBody = {
          "drive_image1":
              "https://img.lovepik.com/free_png/32/49/18/79V58PICd6yd2XF6Uc758PIC58PIC_PIC2018.png_860.png",
          "drive_image2": "",
          "drive_status": "1"
        };

        // Make the PUT request
        var res = await http.put(
          url,
          body: jsonEncode(requestBody), // Convert request body to JSON
          headers: {
            'Content-Type': 'application/json', // Set content type for JSON
          },
        );

        // Check the response status of the PUT request
        if (res.statusCode == 200) {
          _updateStatus(1);
        } else {
          // Handle unsuccessful update
          print('Failed to update order status: ${res.body}');
        }
      } else {
        deliveryImage = image;

        var url = Uri.parse('$server/Putstatus?id=${widget.orderid}');

        var requestBody = {
          "drive_image1":
              "https://img.lovepik.com/free_png/32/49/18/79V58PICd6yd2XF6Uc758PIC58PIC_PIC2018.png_860.png",
          "drive_image2":
              "https://www.gopola.asia/images/ready-template/crop-1589354378793.jpg",
          "drive_status": "2"
        };

        var res = await http.put(
          url,
          body: jsonEncode(requestBody),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (res.statusCode == 200) {
          _updateStatus(2);
        } else {
          print('Failed to update order status: ${res.body}');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent the back navigation
        return false; // Return false to prevent back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delivery'),
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFEADABC),
        ),
        backgroundColor: const Color(0xFFEADABC),
        body: Column(
          children: [
            // Status stepper
            _buildStatusStepper(),

            // Map display
            Expanded(child: _buildMap()),

            // Recipient info and image upload
            _buildRecipientInfo(),

            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStepper() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusIcon('On the way', 0),
          _buildStatusIcon('Picked up', 1),
          _buildStatusIcon('At destination', 2),
          _buildStatusIcon('Delivered', 3),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String label, int step) {
    return Column(
      children: [
        Image.asset(
          'assets/image/3077443.png',
          color: status >= step
              ? null
              : Colors.grey, // Set color to grey if step is not reached
          width: 30,
          height: 30,
        ),
        Text(label),
      ],
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(_currentPosition?.latitude ?? 16.246825669508297,
            _currentPosition?.longitude ?? 103.25199289277295),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            // Current location marker
            Marker(
              point: LatLng(_currentPosition?.latitude ?? 16.246825669508297,
                  _currentPosition?.longitude ?? 103.25199289277295),
              child: Image.asset(
                'assets/image/3077443.png',
                width: 30,
                height: 30,
              ),
            ),
            // Sender location marker
            if (senderLatitude != null && senderLongitude != null)
              Marker(
                point: LatLng(senderLatitude!, senderLongitude!),
                child: Icon(
                  Icons.person,
                ),
              ),
            // Receiver location marker
            if (receiverLatitude != null && receiverLongitude != null)
              Marker(
                point: LatLng(receiverLatitude!, receiverLongitude!),
                child: Icon(Icons.add_box),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecipientInfo() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to start
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                size: 50,
              ),
              Expanded(
                // ใช้ Expanded เพื่อให้ Text ใช้พื้นที่ได้เต็มที่
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align to start
                  children: [
                    Text(
                        'Recipient: John Doe'), // คุณสามารถปรับให้แสดงชื่อที่ถูกต้องได้
                    Text('Phone: 0800000000'), // แสดงหมายเลขโทรศัพท์
                    Text('Raider ID: ${widget.raiderId}'), // แสดง Raider ID
                    Text('Sender ID: ${widget.senderid}'), // แสดง Sender ID
                    Text(
                        'Receiver ID: ${widget.receiverId}'), // แสดง Receiver ID
                    Text('Order ID: ${widget.orderid}'), // แสดง Order ID
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                // Display the uploaded pickup image
                pickupImage != null
                    ? Image.file(
                        File(pickupImage!.path),
                        width: 100,
                        height: 100,
                      )
                    : const SizedBox(height: 100), // Placeholder if no image
                ElevatedButton(
                  onPressed: pickupImage != null
                      ? null // Disable button if image is already picked
                      : () async {
                          await _pickImage(true); // Pick image for pickup
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.brown, // Set the background color to brown
                  ),
                  child: Text(
                    pickupImage != null ? 'Received' : 'Upload',
                    style: TextStyle(
                      color: pickupImage != null
                          ? const Color.fromARGB(83, 0, 0, 0)
                          : Colors.white, // Change text color
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                // Display the uploaded delivery image
                deliveryImage != null
                    ? Image.file(
                        File(deliveryImage!.path),
                        width: 100,
                        height: 100,
                      )
                    : const SizedBox(height: 100), // Placeholder if no image
                ElevatedButton(
                  onPressed: deliveryImage != null
                      ? null // Disable button if delivery image is already picked
                      : (pickupImage !=
                              null // Enable button only if pickup image is uploaded
                          ? () async {
                              await _pickImage(
                                  false); // Pick image for delivery
                            }
                          : null), // Disable if pickup image is not uploaded
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.brown, // Set the background color to brown
                  ),
                  child: Text(
                    deliveryImage != null ? 'Delivered' : 'Upload',
                    style: TextStyle(
                      color: deliveryImage != null
                          ? const Color.fromARGB(83, 0, 0, 0)
                          : Colors.white, // Change text color
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: (pickupImage != null && deliveryImage != null)
              ? () {
                  // Action for "ตกลง"
                  _updateStatus(3);
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delivery successful'),
                        content: const Text(
                            'Do you want to return to the homepage?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              var url = Uri.parse(
                                  '$server/Putstatus?id=${widget.orderid}');

                              var requestBody = {
                                "drive_image1":
                                    "https://img.lovepik.com/free_png/32/49/18/79V58PICd6yd2XF6Uc758PIC58PIC_PIC2018.png_860.png",
                                "drive_image2":
                                    "https://www.gopola.asia/images/ready-template/crop-1589354378793.jpg",
                                "drive_status": "3"
                              };

                              var res = await http.put(
                                url,
                                body: jsonEncode(requestBody),
                                headers: {
                                  'Content-Type': 'application/json',
                                },
                              );

                              if (res.statusCode == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homeraider(
                                          raiderId: widget.raiderId)),
                                );
                              } else {
                                print(
                                    'Failed to update order status: ${res.body}');
                              }
                            },
                            child: const Text('Ok'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Cancle'),
                          ),
                        ],
                      );
                    },
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown, // Set the background color to brown
          ),
          child: const Text(
            'Completion',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  late GetSender getSender; // อ็อบเจ็กต์เดียว

  Future<void> Sender(String senderid) async {
    try {
      var response =
          await http.get(Uri.parse('$server/GetUserid?id=$senderid'));

      if (response.statusCode == 200) {
        // log('Response body: ${response.body}');

        // แปลงข้อมูล JSON ที่ได้รับ
        var jsonData = jsonDecode(response.body);

        // เช็คว่าเป็น List หรือ Map
        if (jsonData is List) {
          // log('Received a List: ${jsonData.toString()}');
        } else if (jsonData is Map) {
          log('Received a Map: ${jsonData.toString()}');
        }

        // ถ้าเป็น List คุณต้องทำการดึงข้อมูลผู้ใช้จากรายการ
        if (jsonData is List && jsonData.isNotEmpty) {
          getSender = GetSender.fromJson(
              jsonData[0]); // สมมติว่าเราต้องการผู้ใช้แรกในรายการ

          // Split the location into latitude and longitude
          List<String> locationParts = getSender.userLocation.split(',');
          if (locationParts.length == 2) {
            String latitude = locationParts[0].trim();
            String longitude = locationParts[1].trim();

            log('Sender latitude: $latitude');
            log('Sender longitude: $longitude');

            setState(() {
              senderLatitude = double.tryParse(latitude);
              senderLongitude = double.tryParse(longitude);
            });
          } else {
            log('Invalid location format: ${getSender.userLocation}');
          }
        }
      } else {
        log('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error parsing data: $e');
    }
  }

  Future<void> receiver(String receiverId) async {
    try {
      var response =
          await http.get(Uri.parse('$server/GetUserid?id=$receiverId'));

      if (response.statusCode == 200) {
        // แปลงข้อมูล JSON ที่ได้รับ
        var jsonData = jsonDecode(response.body);

        // เช็คว่าเป็น List หรือ Map
        if (jsonData is List) {
          // log('Received a List: ${jsonData.toString()}');
        } else if (jsonData is Map) {
          log('Received a Map: ${jsonData.toString()}');
        }

        // ถ้าเป็น List คุณต้องทำการดึงข้อมูลผู้ใช้จากรายการ
        if (jsonData is List && jsonData.isNotEmpty) {
          GetSender receiver = GetSender.fromJson(
              jsonData[0]); // สมมติว่าเราต้องการผู้ใช้แรกในรายการ

          // Split the location into latitude and longitude
          List<String> locationParts = receiver.userLocation.split(',');
          if (locationParts.length == 2) {
            String latitude = locationParts[0].trim();
            String longitude = locationParts[1].trim();

            log('Receiver latitude: $latitude');
            log('Receiver longitude: $longitude');
            setState(() {
              receiverLatitude = double.tryParse(latitude);
              receiverLongitude = double.tryParse(longitude);
            });
          } else {
            log('Invalid location format: ${receiver.userLocation}');
          }
        }
      } else {
        log('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error parsing data: $e');
    }
  }
}
