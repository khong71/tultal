// To parse this JSON data, do
//
//     final loginRaider = loginRaiderFromJson(jsonString);

import 'dart:convert';

LoginRaider loginRaiderFromJson(String str) => LoginRaider.fromJson(json.decode(str));

String loginRaiderToJson(LoginRaider data) => json.encode(data.toJson());

class LoginRaider {
    String raiderEmail;
    String raiderPassword;

    LoginRaider({
        required this.raiderEmail,
        required this.raiderPassword,
    });

    factory LoginRaider.fromJson(Map<String, dynamic> json) => LoginRaider(
        raiderEmail: json["raider_email"],
        raiderPassword: json["raider_password"],
    );

    Map<String, dynamic> toJson() => {
        "raider_email": raiderEmail,
        "raider_password": raiderPassword,
    };
}
