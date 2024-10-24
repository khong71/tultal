// To parse this JSON data, do
//
//     final registerDriver = registerDriverFromJson(jsonString);

import 'dart:convert';

RegisterDriver registerDriverFromJson(String str) => RegisterDriver.fromJson(json.decode(str));

String registerDriverToJson(RegisterDriver data) => json.encode(data.toJson());

class RegisterDriver {
    String raiderName;
    String raiderEmail;
    String raiderPhone;
    String raiderImage;
    String raiderNumder;
    String raiderPassword;
    String raiderLocation;

    RegisterDriver({
        required this.raiderName,
        required this.raiderEmail,
        required this.raiderPhone,
        required this.raiderImage,
        required this.raiderNumder,
        required this.raiderPassword,
        required this.raiderLocation,
    });

    factory RegisterDriver.fromJson(Map<String, dynamic> json) => RegisterDriver(
        raiderName: json["Raider_name"],
        raiderEmail: json["Raider_email"],
        raiderPhone: json["Raider_Phone"],
        raiderImage: json["Raider_image"],
        raiderNumder: json["Raider_numder"],
        raiderPassword: json["Raider_password"],
        raiderLocation: json["Raider_location"],
    );

    Map<String, dynamic> toJson() => {
        "Raider_name": raiderName,
        "Raider_email": raiderEmail,
        "Raider_Phone": raiderPhone,
        "Raider_image": raiderImage,
        "Raider_numder": raiderNumder,
        "Raider_password": raiderPassword,
        "Raider_location": raiderLocation,
    };
}
