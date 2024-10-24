// To parse this JSON data, do
//
//     final getUsers = getUsersFromJson(jsonString);

import 'dart:convert';

List<GetUsers> getUsersFromJson(String str) => List<GetUsers>.from(json.decode(str).map((x) => GetUsers.fromJson(x)));

String getUsersToJson(List<GetUsers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUsers {
    int userId;
    String userName;
    String userEmail;
    String userPassword;
    String userLocation;
    String userImage;
    String userPhone;
    String userAddress;

    GetUsers({
        required this.userId,
        required this.userName,
        required this.userEmail,
        required this.userPassword,
        required this.userLocation,
        required this.userImage,
        required this.userPhone,
        required this.userAddress,
    });

    factory GetUsers.fromJson(Map<String, dynamic> json) => GetUsers(
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
