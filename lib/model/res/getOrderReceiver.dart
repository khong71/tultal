// To parse this JSON data, do
//
//     final getOrderReceiver = getOrderReceiverFromJson(jsonString);

import 'dart:convert';

List<GetOrderReceiver> getOrderReceiverFromJson(String str) => List<GetOrderReceiver>.from(json.decode(str).map((x) => GetOrderReceiver.fromJson(x)));

String getOrderReceiverToJson(List<GetOrderReceiver> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetOrderReceiver {
    int orderId;
    String orderInfo;
    String orderImage;
    int orderSenderId;
    int orderReceiverId;
    int userId;
    String username;
    String userPhone;
    String userImage;

    GetOrderReceiver({
        required this.orderId,
        required this.orderInfo,
        required this.orderImage,
        required this.orderSenderId,
        required this.orderReceiverId,
        required this.userId,
        required this.username,
        required this.userPhone,
        required this.userImage,
    });

    factory GetOrderReceiver.fromJson(Map<String, dynamic> json) => GetOrderReceiver(
        orderId: json["order_id"],
        orderInfo: json["order_info"],
        orderImage: json["order_image"],
        orderSenderId: json["order_sender_id"],
        orderReceiverId: json["order_receiver_id"],
        userId: json["user_id"],
        username: json["user_name"],
        userPhone: json["user_phone"],
        userImage: json["user_image"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_info": orderInfo,
        "order_image": orderImage,
        "order_sender_id": orderSenderId,
        "order_receiver_id": orderReceiverId,
        "user_id": userId,
        "user_name": username,
        "user_phone": userPhone,
        "user_image": userImage,
    };
}
