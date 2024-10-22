// To parse this JSON data, do
//
//     final getUser = getUserFromJson(jsonString);

import 'dart:convert';

GetUser getUserFromJson(String str) => GetUser.fromJson(json.decode(str));

String getUserToJson(GetUser data) => json.encode(data.toJson());

class GetUser {
    String userEmail;
    String userPassword;

    GetUser({
        required this.userEmail,
        required this.userPassword,
    });

    factory GetUser.fromJson(Map<String, dynamic> json) => GetUser(
        userEmail: json["user_email"],
        userPassword: json["user_password"],
    );

    Map<String, dynamic> toJson() => {
        "user_email": userEmail,
        "user_password": userPassword,
    };
}
