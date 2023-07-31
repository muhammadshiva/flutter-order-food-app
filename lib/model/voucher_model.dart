class VoucherModel {
  int id;
  String kode;
  String gambar;
  int nominal;
  String status;

  VoucherModel({
    required this.id,
    required this.kode,
    required this.gambar,
    required this.nominal,
    required this.status,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
        id: json["id"],
        kode: json["kode"],
        gambar: json["gambar"] ?? "",
        nominal: json["nominal"],
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "gambar": gambar,
        "nominal": nominal,
        "status": status,
      };
}
