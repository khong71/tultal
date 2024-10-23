// To parse this JSON data, do
//
//     final postOrder = postOrderFromJson(jsonString);

import 'dart:convert';

List<PostOrder> postOrderFromJson(String str) => List<PostOrder>.from(json.decode(str).map((x) => PostOrder.fromJson(x)));

String postOrderToJson(List<PostOrder> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostOrder {
    String orderImage;
    String orderInfo;
    String orderSenderId;
    String orderReceiverId;

    PostOrder({
        required this.orderImage,
        required this.orderInfo,
        required this.orderSenderId,
        required this.orderReceiverId,
    });

    factory PostOrder.fromJson(Map<String, dynamic> json) => PostOrder(
        orderImage: json["order_image"],
        orderInfo: json["order_info"],
        orderSenderId: json["order_sender_id"],
        orderReceiverId: json["order_receiver_id"],
    );

    Map<String, dynamic> toJson() => {
        "order_image": orderImage,
        "order_info": orderInfo,
        "order_sender_id": orderSenderId,
        "order_receiver_id": orderReceiverId,
    };
}
