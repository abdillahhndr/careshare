import 'dart:convert';

OtpResponse otpResponseFromJson(String str) => OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  final int value;
  final String message;

  OtpResponse({
    required this.value,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      value: json['value'],
      message: json['message'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'message': message,
    };
  }
}
