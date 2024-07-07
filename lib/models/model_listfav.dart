// To parse this JSON data, do
//
//     final modelFav = modelFavFromJson(jsonString);

import 'dart:convert';

ModelFav modelFavFromJson(String str) => ModelFav.fromJson(json.decode(str));

String modelFavToJson(ModelFav data) => json.encode(data.toJson());

class ModelFav {
    bool isSuccess;
    String message;
    List<Datumf> data;

    ModelFav({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelFav.fromJson(Map<String, dynamic> json) => ModelFav(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datumf>.from(json["data"].map((x) => Datumf.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datumf {
    String id;
    String judul;
    String isiKonten;
    String gambarKonten;
    DateTime tglKonten;

    Datumf({
        required this.id,
        required this.judul,
        required this.isiKonten,
        required this.gambarKonten,
        required this.tglKonten,
    });

    factory Datumf.fromJson(Map<String, dynamic> json) => Datumf(
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
