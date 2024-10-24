// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:tultal/Page/Homeuser.dart';

class Checkstatus extends StatefulWidget {
  final int userId;
  const Checkstatus({super.key, required this.userId});

  @override
  State<Checkstatus> createState() => _CheckstatusState();
}

class _CheckstatusState extends State<Checkstatus> {
  // Work-related variables
  final ImagePicker _picker = ImagePicker();
  XFile? pickupImage;
  XFile? deliveryImage;
  int status = 0; // 0: en route to pickup, 1: picked up, 2: en route to destination, 3: delivered

  // Geolocation variables
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      // Default to predefined coordinates if unable to get the location
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

  // Function to update status
  void _updateStatus(int newStatus) {
    setState(() {
      status = newStatus;
    });
  }

  // Image picker function
  Future<void> _pickImage(bool isPickup) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (isPickup) {
        pickupImage = image;
        _updateStatus(1); // Automatically update status after pickup image
      } else {
        deliveryImage = image;
        _updateStatus(2); // Automatically update status after delivery image
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
          backgroundColor: const Color(0xFFE2DBBF),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Back icon
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homeuser(userId: widget.userId),
                ), // Navigate back to Homeuser
              );
            },
          ),
          title: Text('Check Status'), // Current page title
        ),
        body: Column(
          children: [
            // Status stepper
            _buildStatusStepper(),

            // Map display
            Expanded(child: _buildMap()),

            // Recipient info and image upload
            _buildRecipientInfo(),
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
          color: status >= step ? null : Colors.grey, // Set color to grey if step is not reached
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
        initialCenter: LatLng(
          _currentPosition?.latitude ?? 16.246825669508297,
          _currentPosition?.longitude ?? 103.25199289277295,
        ),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(
                _currentPosition?.latitude ?? 16.246825669508297,
                _currentPosition?.longitude ?? 103.25199289277295,
              ),
              child: Image.asset(
                'assets/image/3077443.png',
                width: 30,
                height: 30,
              ),
            ),
            // Add other markers for pickup and delivery locations
          ],
        ),
      ],
    );
  }

  Widget _buildRecipientInfo() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                size: 50,
              ),
              Text('Recipient: John Doe'),
              SizedBox(width: 10),
              Text('0800000000'),
            ],
          ),
        ],
      ),
    );
  }

 
}
