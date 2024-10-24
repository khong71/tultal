// To parse this JSON data, do
//
//     final getSender = getSenderFromJson(jsonString);

import 'dart:convert';

GetSender getSenderFromJson(String str) => GetSender.fromJson(json.decode(str));

String getSenderToJson(GetSender data) => json.encode(data.toJson());

class GetSender {
    int userId;
    String userName;
    String userEmail;
    String userPassword;
    String userLocation;
    String userImage;
    String userPhone;
    String userAddress;

    GetSender({
        required this.userId,
        required this.userName,
        required this.userEmail,
        required this.userPassword,
        required this.userLocation,
        required this.userImage,
        required this.userPhone,
        required this.userAddress,
    });

    factory GetSender.fromJson(Map<String, dynamic> json) => GetSender(
        userId: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userPassword: json["user_password"],
        userLocation: json["user_location"],
        userImage: json["user_image"],
        userPhone: json["user_phone"],
        userAddress: json["user_address"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "user_password": userPassword,
        "user_location": userLocation,
        "user_image": userImage,
        "user_phone": userPhone,
        "user_address": userAddress,
    };
}