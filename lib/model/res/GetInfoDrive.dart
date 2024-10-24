// To parse this JSON data, do
//
//     final getInfoDrive = getInfoDriveFromJson(jsonString);

import 'dart:convert';

List<GetInfoDrive> getInfoDriveFromJson(String str) => List<GetInfoDrive>.from(json.decode(str).map((x) => GetInfoDrive.fromJson(x)));

String getInfoDriveToJson(List<GetInfoDrive> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetInfoDrive {
    String orderId;
    String orderSenderId;
    String orderReceiverId;
    String orderImage;
    String orderInfo;
    String userSenderName;
    String userReceiverName;
    String userLocation;
    String userImage;
    String userPhone;
    String raiderName;
    String raiderPhone;

    GetInfoDrive({
        required this.orderId,
        required this.orderSenderId,
        required this.orderReceiverId,
        required this.orderImage,
        required this.orderInfo,
        required this.userSenderName,
        required this.userReceiverName,
        required this.userLocation,
        required this.userImage,
        required this.userPhone,
        required this.raiderName,
        required this.raiderPhone,
    });

    factory GetInfoDrive.fromJson(Map<String, dynamic> json) => GetInfoDrive(
        orderId: json["order_id"],
        orderSenderId: json["order_sender_id"],
        orderReceiverId: json["order_receiver_id"],
        orderImage: json["order_image"],
        orderInfo: json["order_info"],
        userSenderName: json["user_sender_name"],
        userReceiverName: json["user_receiver_name"],
        userLocation: json["user_location"],
        userImage: json["user_image"],
        userPhone: json["user_phone"],
        raiderName: json["raider_name"],
        raiderPhone: json["raider_phone"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_sender_id": orderSenderId,
        "order_receiver_id": orderReceiverId,
        "order_image": orderImage,
        "order_info": orderInfo,
        "user_sender_name": userSenderName,
        "user_receiver_name": userReceiverName,
        "user_location": userLocation,
        "user_image": userImage,
        "user_phone": userPhone,
        "raider_name": raiderName,
        "raider_phone": raiderPhone,
    };
}
