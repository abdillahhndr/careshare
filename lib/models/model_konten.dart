

import 'dart:convert';

ModelKonten modelKontenFromJson(String str) =>
    ModelKonten.fromJson(json.decode(str));

String modelKontenToJson(ModelKonten data) => json.encode(data.toJson());

class ModelKonten {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelKonten({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelKonten.fromJson(Map<String, dynamic> json) => ModelKonten(
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
  String judul;
  String isiKonten;
  String gambarKonten;
  DateTime tglKonten;

  Datum({
    required this.id,
    required this.judul,
    required this.isiKonten,
    required this.gambarKonten,
    required this.tglKonten,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        judul: json["judul"],
        isiKonten: json["isi_konten"],
        gambarKonten: json["gambar_konten"],
        tglKonten: DateTime.parse(json["tgl_konten"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "isi_konten": isiKonten,
        "gambar_konten": gambarKonten,
        "tgl_konten": tglKonten.toIso8601String(),
      };
}