// To parse this JSON data, do
//
//     final getOrder = getOrderFromJson(jsonString);

import 'dart:convert';

List<GetOrder> getOrderFromJson(String str) => List<GetOrder>.from(json.decode(str).map((x) => GetOrder.fromJson(x)));

String getOrderToJson(List<GetOrder> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetOrder {
    int orderid;
    String orderImage;
    String orderInfo;
    String orderSenderId;
    String orderReceiverId;

    GetOrder({
        required this.orderid,
        required this.orderImage,
        required this.orderInfo,
        required this.orderSenderId,
        required this.orderReceiverId,
    });

    factory GetOrder.fromJson(Map<String, dynamic> json) => GetOrder(
        orderid: json["order_id"],
        orderImage: json["order_image"],
        orderInfo: json["order_info"],
        orderSenderId: json["order_sender_id"],
        orderReceiverId: json["order_receiver_id"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderid,
        "order_image": orderImage,
        "order_info": orderInfo,
        "order_sender_id": orderSenderId,
        "order_receiver_id": orderReceiverId,
    };
}
