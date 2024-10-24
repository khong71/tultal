import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:tultal/Page/Homeuser.dart';

class Checkstatus extends StatefulWidget {
  final int userId;
  final String orderInfo;
  final String orderImage;
  final String userName;
  final String userPhone;
  final String userImage;
  final int orderReceiverId;

  const Checkstatus({
    super.key,
    required this.userId,
    required this.orderInfo,
    required this.orderImage,
    required this.userName,
    required this.userPhone,
    required this.userImage,
    required this.orderReceiverId,
  });

  @override
  State<Checkstatus> createState() => _CheckstatusState();
}

class _CheckstatusState extends State<Checkstatus> {
  Position? _currentPosition;
  String? receiverName;
  String? receiverPhone;
  String? receiverImage;
  LatLng? receiverLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchReceiverInfo(widget.orderReceiverId); // Fetch receiver info
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
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

  Future<void> _fetchReceiverInfo(int receiverId) async {
    final response = await http.get(Uri.parse(
        'https://gogo-production-4a9f.up.railway.app/GetUserid?id=$receiverId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        receiverName = data['user_name'];
        receiverPhone = data['user_phone'];
        receiverImage = data['user_image'];
        final locationString = data['user_location'].split(',');
        receiverLocation = LatLng(
          double.parse(locationString[0]),
          double.parse(locationString[1]),
        );
      });
    } else {
      // Handle the error
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE2DBBF),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homeuser(userId: widget.userId),
                ),
              );
            },
          ),
          title: Text('Check Status'),
        ),
        body: Column(
          children: [
            _buildStatusStepper(),
            Expanded(child: _buildMap()),
            _buildOrderInfo(), // Display order information below the map
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
          color: Colors.grey,
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
            if (receiverLocation !=
                null) // Only add marker if location is available
              Marker(
                point: receiverLocation!,
                child: const Icon(
                  Icons.person, // Icon for the user marker
                  size: 30, // Set the size of the icon
                  color: Colors.red, // Set the color of the icon
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Info: ${utf8.decode(widget.orderInfo.codeUnits)}"),
          const SizedBox(height: 8),
          Image.network(widget.orderImage),
          const SizedBox(height: 8),
          Text("User Name: ${widget.userName}"),
          Text("User Phone: ${widget.userPhone}"),
          Image.network(
            widget.userImage,
            width: 100, // Adjust the width as needed
            height: 100, // Adjust the height as needed
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
              "Order Receiver ID: ${widget.orderReceiverId}"), // Display the order receiver ID
          const SizedBox(height: 8),
          if (receiverName != null) Text("Receiver Name: $receiverName"),
          if (receiverPhone != null) Text("Receiver Phone: $receiverPhone"),
          if (receiverImage != null)
            Image.network(receiverImage!,
                width: 100, height: 100, fit: BoxFit.cover),
        ],
      ),
    );
  }
}
