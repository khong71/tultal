// To parse this JSON data, do
//
//     final getInfoOrder = getInfoOrderFromJson(jsonString);

import 'dart:convert';

List<GetInfoOrder> getInfoOrderFromJson(String str) => List<GetInfoOrder>.from(json.decode(str).map((x) => GetInfoOrder.fromJson(x)));

String getInfoOrderToJson(List<GetInfoOrder> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetInfoOrder {
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

    GetInfoOrder({
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
    });

    factory GetInfoOrder.fromJson(Map<String, dynamic> json) => GetInfoOrder(
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
    };
}
