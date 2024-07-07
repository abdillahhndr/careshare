// To parse this JSON data, do
//
//     final modelListHistoryPayment = modelListHistoryPaymentFromJson(jsonString);

import 'dart:convert';

ModelListHistoryPayment modelListHistoryPaymentFromJson(String str) =>
    ModelListHistoryPayment.fromJson(json.decode(str));

String modelListHistoryPaymentToJson(ModelListHistoryPayment data) =>
    json.encode(data.toJson());

class ModelListHistoryPayment {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelListHistoryPayment({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListHistoryPayment.fromJson(Map<String, dynamic> json) =>
      ModelListHistoryPayment(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String userId;
  String mentorId;
  String price;
  String status;
  String snapToken;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.userId,
    required this.mentorId,
    required this.price,
    required this.status,
    required this.snapToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        mentorId: json["mentor_id"],
        price: json["price"],
        status: json["status"],
        snapToken: json["snap_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "mentor_id": mentorId,
        "price": price,
        "status": status,
        "snap_token": snapToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
