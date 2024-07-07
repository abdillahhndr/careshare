// To parse this JSON data, do
//
//     final modelListMentor = modelListMentorFromJson(jsonString);

import 'dart:convert';

ModelListMentor modelListMentorFromJson(String str) =>
    ModelListMentor.fromJson(json.decode(str));

String modelListMentorToJson(ModelListMentor data) =>
    json.encode(data.toJson());

class ModelListMentor {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelListMentor({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListMentor.fromJson(Map<String, dynamic> json) =>
      ModelListMentor(
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
  String idUser;
  String nama;
  String keterangan;
  String price;
  String link;

  Datum({
    required this.id,
    required this.idUser,
    required this.nama,
    required this.keterangan,
    required this.price,
    required this.link,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        idUser: json["id_user"],
        nama: json["nama"],
        keterangan: json["keterangan"],
        price: json["price"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "nama": nama,
        "keterangan": keterangan,
        "price": price,
        "link": link,
      };
}
