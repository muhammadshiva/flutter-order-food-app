class OrderModel {
  String nominalDiskon;
  String nominalPesanan;
  List<Map<String, dynamic>> items; // Tambahkan properti untuk menyimpan data menu yang dipesan

  OrderModel({
    required this.nominalDiskon,
    required this.nominalPesanan,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        nominalDiskon: json["nominal_diskon"],
        nominalPesanan: json["nominal_pesanan"],
        items: List<Map<String, dynamic>>.from(json["items"].map((item) => item)),
      );

  Map<String, dynamic> toJson() => {
        "nominal_diskon": nominalDiskon,
        "nominal_pesanan": nominalPesanan,
        "items": List<dynamic>.from(items.map((item) => item)),
      };
}
