// To parse this JSON data, do
//
//     final getOrderSendList = getOrderSendListFromJson(jsonString);

import 'dart:convert';

List<GetOrderSendList> getOrderSendListFromJson(String str) => List<GetOrderSendList>.from(json.decode(str).map((x) => GetOrderSendList.fromJson(x)));

String getOrderSendListToJson(List<GetOrderSendList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetOrderSendList {
    int orderId;
    String orderInfo;
    String orderImage;
    int orderSenderId;
    String userName;
    String userPhone;
    String userImage;

    GetOrderSendList({
        required this.orderId,
        required this.orderInfo,
        required this.orderImage,
        required this.orderSenderId,
        required this.userName,
        required this.userPhone,
        required this.userImage,
    });

    factory GetOrderSendList.fromJson(Map<String, dynamic> json) => GetOrderSendList(
        orderId: json["order_id"],
        orderInfo: json["order_info"],
        orderImage: json["order_image"],
        orderSenderId: json["order_sender_id"],
        userName: json["user_name"],
        userPhone: json["user_phone"],
        userImage: json["user_image"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_info": orderInfo,
        "order_image": orderImage,
        "order_sender_id": orderSenderId,
        "user_name": userName,
        "user_phone": userPhone,
        "user_image": userImage,
    };
}
