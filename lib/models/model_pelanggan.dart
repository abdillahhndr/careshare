// To parse this JSON data, do
//
//     final modelListPelanggan = modelListPelangganFromJson(jsonString);

import 'dart:convert';

ModelListPelanggan modelListPelangganFromJson(String str) =>
    ModelListPelanggan.fromJson(json.decode(str));

String modelListPelangganToJson(ModelListPelanggan data) =>
    json.encode(data.toJson());

class ModelListPelanggan {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelListPelanggan({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListPelanggan.fromJson(Map<String, dynamic> json) =>
      ModelListPelanggan(
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
  String username;
  String nama;

  Datum({
    required this.id,
    required this.username,
    required this.nama,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        username: json["username"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "nama": nama,
      };
}
