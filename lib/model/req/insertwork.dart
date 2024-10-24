// To parse this JSON data, do
//
//     final insertwork = insertworkFromJson(jsonString);

import 'dart:convert';

Insertwork insertworkFromJson(String str) => Insertwork.fromJson(json.decode(str));

String insertworkToJson(Insertwork data) => json.encode(data.toJson());

class Insertwork {
    String driveImage1;
    String driveImage2;
    String orderId;
    String driveStatus;
    String raiderId;

    Insertwork({
        required this.driveImage1,
        required this.driveImage2,
        required this.orderId,
        required this.driveStatus,
        required this.raiderId,
    });

    factory Insertwork.fromJson(Map<String, dynamic> json) => Insertwork(
        driveImage1: json["drive_image1"],
        driveImage2: json["drive_image2"],
        orderId: json["order_id"],
        driveStatus: json["drive_status"],
        raiderId: json["raider_id"],
    );

    Map<String, dynamic> toJson() => {
        "drive_image1": driveImage1,
        "drive_image2": driveImage2,
        "order_id": orderId,
        "drive_status": driveStatus,
        "raider_id": raiderId,
    };
}
