// To parse this JSON data, do
//
//     final modelForgotPass = modelForgotPassFromJson(jsonString);

import 'dart:convert';

ModelForgotPass modelForgotPassFromJson(String str) => ModelForgotPass.fromJson(json.decode(str));

String modelForgotPassToJson(ModelForgotPass data) => json.encode(data.toJson());

class ModelForgotPass {
    bool isSuccess;
    int value;
    String message;
    String id;

    ModelForgotPass({
        required this.isSuccess,
        required this.value,
        required this.message,
        required this.id,
    });

    factory ModelForgotPass.fromJson(Map<String, dynamic> json) => ModelForgotPass(
        isSuccess: json["is_success"],
        value: json["value"],
        message: json["message"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "is_success": isSuccess,
        "value": value,
        "message": message,
        "id": id,
    };
}
