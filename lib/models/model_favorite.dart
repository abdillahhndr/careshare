import 'dart:convert';

FavoriteResponse favoriteResponseFromJson(String str) => FavoriteResponse.fromJson(json.decode(str));

String favoriteResponseToJson(FavoriteResponse data) => json.encode(data.toJson());

class FavoriteResponse {
  FavoriteResponse({
    required this.value,
    required this.message,
  });

  int value;
  String message;

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) => FavoriteResponse(
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
  };
}
