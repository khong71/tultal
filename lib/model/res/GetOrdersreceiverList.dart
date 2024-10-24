// To parse this JSON data, do
//
//     final getOrdersreceiverList = getOrdersreceiverListFromJson(jsonString);

import 'dart:convert';

List<GetOrdersreceiverList> getOrdersreceiverListFromJson(String str) => List<GetOrdersreceiverList>.from(json.decode(str).map((x) => GetOrdersreceiverList.fromJson(x)));

String getOrdersreceiverListToJson(List<GetOrdersreceiverList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetOrdersreceiverList {
    int orderId;
    String orderInfo;
    String orderImage;
    int orderReceiverId;
    String userName;
    String userPhone;
    String userImage;

    GetOrdersreceiverList({
        required this.orderId,
        required this.orderInfo,
        required this.orderImage,
        required this.orderReceiverId,
        required this.userName,
        required this.userPhone,
        required this.userImage,
    });

    factory GetOrdersreceiverList.fromJson(Map<String, dynamic> json) => GetOrdersreceiverList(
        orderId: json["order_id"],
        orderInfo: json["order_info"],
        orderImage: json["order_image"],
        orderReceiverId: json["order_receiver_id"],
        userName: json["user_name"],
        userPhone: json["user_phone"],
        userImage: json["user_image"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_info": orderInfo,
        "order_image": orderImage,
        "order_receiver_id": orderReceiverId,
        "user_name": userName,
        "user_phone": userPhone,
        "user_image": userImage,
    };
}
