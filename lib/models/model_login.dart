// To parse this JSON data, do
//
//     final modelLogin = modelLoginFromJson(jsonString);

import 'dart:convert';

ModelLogin modelLoginFromJson(String str) =>
    ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  int value;
  String message;
  String username;
  String level;
  String id;

  ModelLogin({
    required this.value,
    required this.message,
    required this.username,
    required this.level,
    required this.id,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
        value: json["value"],
        message: json["message"],
        username: json["username"],
        level: json["level"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "username": username,
        "level": level,
        "id": id,
      };
}
