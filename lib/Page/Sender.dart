import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tultal/Page/CheckStatus.dart';
import 'package:tultal/Page/Login.dart';

class Recipient {
  final String name;
  final String phone;
  final String image;

  Recipient(this.name, this.phone, this.image);
}

class Sender extends StatefulWidget {
  const Sender({super.key});

  @override
  State<Sender> createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _imageFile; // Store selected image file
  Recipient? selectedRecipient; // Store selected recipient
  LatLng _selectedLocation =
      const LatLng(16.246825669508297, 103.25199289277295);
  final MapController mapController = MapController(); // Controller for the map

  // Sample recipient list
  final List<Recipient> recipients = [
    Recipient('John Doe', '0800000000', 'assets/image/logo.png'),
    Recipient('Jane Doe', '0800000001', 'assets/image/logo.png'),
    Recipient('Alice', '0800000002', 'assets/image/logo.png'),
    Recipient('Bob', '0800000003', 'assets/image/logo.png'),
    Recipient('Jane Doe', '0800000004', 'assets/image/logo.png'),
    Recipient('Alice', '0800000005', 'assets/image/logo.png'),
    Recipient('Bob', '0800000006', 'assets/image/logo.png'),
  ];

  // Filtered recipient list based on search
  List<Recipient> filteredRecipients = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
        _filterRecipients); // Listen for changes in the search field
    filteredRecipients = recipients; // Show all recipients initially

    // Get current location
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to filter recipients based on search input
  void _filterRecipients() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredRecipients = recipients.where((recipient) {
        return recipient.name.toLowerCase().contains(query) ||
            recipient.phone.contains(query);
      }).toList();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _resetRecipientSelection() {
    setState(() {
      selectedRecipient = null; // Reset selected recipient
      _searchController.clear(); // Clear search field
      filteredRecipients = recipients; // Reset recipient list
    });
  }

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      mapController.move(
          _selectedLocation, 15.0); // Move the map to the current location
    });
  }

  // Function to move the map to the user's current location
  Future<void> _moveToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      mapController.move(_selectedLocation, 15.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2DBBF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Sender'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE2DBBF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.all_inbox, color: Colors.black, size: 30),
              onPressed: () => CheckStatu(),
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.black, size: 30),
              onPressed: () {
                _showSignOutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFDBC7A1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedRecipient == null) // Show search field if no recipient is selected
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Search Recipient'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      keyboardType: TextInputType.phone, // Use numeric keypad
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
                  ],
                ),
              if (selectedRecipient == null) // Show list of recipients
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: filteredRecipients.map((recipient) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(recipient.image),
                          ),
                          title: Text(recipient.name),
                          subtitle: Text(recipient.phone),
                          onTap: () {
                            setState(() {
                              selectedRecipient = recipient;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              if (selectedRecipient != null) // Show selected recipient details
                Expanded(
                  child: SingleChildScrollView(
                    child: Card(
                      color: const Color(0xFFF1DBB7),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(selectedRecipient!.image),
                              ),
                              title: Text(selectedRecipient!.name),
                              subtitle: Text(selectedRecipient!.phone),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown, // Brown for the button
                                  foregroundColor: Colors.white, // White text
                                ),
                                onPressed: _resetRecipientSelection, // Change recipient button
                                child: const Text('Change'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _imageFile == null
                                ? GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SafeArea(
                                            child: Wrap(
                                              children: <Widget>[
                                                ListTile(
                                                  leading: const Icon(Icons.photo_library),
                                                  title: const Text('Choose from gallery'),
                                                  onTap: () {
                                                    _pickImage(ImageSource.gallery);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(Icons.camera_alt),
                                                  title: const Text('Take a picture'),
                                                  onTap: () {
                                                    _pickImage(ImageSource.camera);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 150,
                                      child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                                    ),
                                  )
                                : Image.file(
                                    File(_imageFile!.path),
                                    height: 150,
                                  ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _descriptionController,
                              maxLength: 200, // Limit character count
                              minLines: 5, // Start with 5 lines
                              maxLines: null, // No limit, auto-expand
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Details. . .',
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Please select the point where the driver will pick up the item. You can use your current location or tap on the map to select.',
                              style: TextStyle(
                                fontSize: 10.0, // Font size
                                color: Color.fromARGB(255, 0, 0, 0), // Text color
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 250, // Adjust size as needed
                              child: Stack(
                                children: [
                                  FlutterMap(
                                    mapController: mapController,
                                    options: MapOptions(
                                      initialCenter: _selectedLocation,
                                      initialZoom: 15.0,
                                      minZoom: 5, // Minimum zoom level
                                      maxZoom: 18, // Maximum zoom level
                                      onTap: (tapPosition, point) {
                                        setState(() {
                                          _selectedLocation = point; // Update selected coordinates
                                          mapController.move(point, mapController.camera.zoom); // Move map to selected position
                                        });
                                      },
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: _selectedLocation,
                                            width: 40,
                                            height: 40,
                                            child: const Icon(
                                              Icons.location_on,
                                              size: 40,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 16, // Adjust the position from the bottom
                                    right: 16, // Adjust the position from the right
                                    child: FloatingActionButton(
                                      backgroundColor: const Color.fromARGB(255, 171, 121, 102),
                                      onPressed: _moveToCurrentLocation, // Move to current location
                                      child: const Icon(Icons.ad_units,
                                      color: Colors.white,), // Phone icon
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown, // Brown for the button
                                foregroundColor: Colors.white, // White text
                              ),
                              onPressed: () {
                                // Function to send the item
                              },
                              child: const Text('Send'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  void CheckStatu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Checkstatus()),
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
  // ฟังก์ชันสำหรับแสดงกล่องยืนยันเมื่อผู้ใช้กดปุ่มออกจากระบบ
  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SingOut'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              signOut(context); // เรียกฟังก์ชัน signOut เมื่อผู้ใช้กดตกลง
            },
            child: const Text('Ok'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิด dialog เมื่อผู้ใช้กดยกเลิก
            },
            child: const Text('Cancel'),
          ),
        ],
        );
      },
    );
  }
}
