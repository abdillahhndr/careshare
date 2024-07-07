import 'dart:convert';

class LoginResponse {
  int value;
  String message;
  String username;
  String email;
  String id;
  String address; // Change the type to non-nullable String

  LoginResponse({
    required this.value,
    required this.message,
    required this.username,
    required this.email,
    required this.id,
    required this.address, // Initialize address in the constructor
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Assign an empty string to address if it's not present in the JSON data
    final address = json.containsKey('address') ? json['address'] : '';
    return LoginResponse(
      value: json["value"],
      message: json["message"],
      username: json["username"],
      email: json["email"],
      id: json["id"],
      address: address, // Assign the address
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "value": value,
      "message": message,
      "username": username,
      "email": email,
      "id": id,
      "address": address,
    };
  }
}

// Functions to parse JSON data
LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());
