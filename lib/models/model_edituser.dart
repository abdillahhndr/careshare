import 'dart:convert';

ModelEditUser modelEditUserFromJson(String str) =>
    ModelEditUser.fromJson(json.decode(str));

String modelEditUserToJson(ModelEditUser data) => json.encode(data.toJson());

class ModelEditUser {
  bool isSuccess;
  int value;
  String message;
  String username;
  String email;
  String address; // Add the address field
  String id;

  ModelEditUser({
    required this.isSuccess,
    required this.value,
    required this.message,
    required this.username,
    required this.email,
    required this.address, // Initialize the address field
    required this.id,
  });

  factory ModelEditUser.fromJson(Map<String, dynamic> json) => ModelEditUser(
        isSuccess: json["is_success"],
        value: json["value"],
        message: json["message"],
        username: json["username"],
        email: json["email"],
        address: json["address"], // Assign the value of address
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "is_success": isSuccess,
        "value": value,
        "message": message,
        "username": username,
        "email": email,
        "address": address, // Include address in the JSON data
        "id": id,
      };
}
