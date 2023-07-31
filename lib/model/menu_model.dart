import 'dart:convert';

class MenuModel {
  int? id;
  String nama;
  int harga;
  String tipe;
  String gambar;

  MenuModel({
    this.id,
    required this.nama,
    required this.harga,
    required this.tipe,
    required this.gambar,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        id: json["id"],
        nama: json["nama"],
        harga: json["harga"],
        tipe: json["tipe"],
        gambar: json["gambar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "harga": harga,
        "tipe": tipe,
        "gambar": gambar,
      };
}
