// To parse this JSON data, do
//
//     final registerUser = registerUserFromJson(jsonString);

import 'dart:convert';

RegisterUser registerUserFromJson(String str) => RegisterUser.fromJson(json.decode(str));

String registerUserToJson(RegisterUser data) => json.encode(data.toJson());

class RegisterUser {
    String userName;
    String userEmail;
    String userPassword;
    String userLocation;
    // String userImage;
    String userPhone;
    String userAddress;

    RegisterUser({
        required this.userName,
        required this.userEmail,
        required this.userPassword,
        required this.userLocation,
        // required this.userImage,
        required this.userPhone,
        required this.userAddress,
    });

    factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
        userName: json["user_name"],
        userEmail: json["user_email"],
        userPassword: json["user_password"],
        userLocation: json["user_location"],
        // userImage: json["user_image"],
        userPhone: json["user_phone"],
        userAddress: json["user_address"],
    );

    Map<String, dynamic> toJson() => {
        "user_name": userName,
        "user_email": userEmail,
        "user_password": userPassword,
        "user_location": userLocation,
        // "user_image": userImage,
        "user_phone": userPhone,
        "user_address": userAddress,
    };
}
