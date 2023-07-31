import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_order_app/model/menu_model.dart';
import 'package:flutter_order_app/model/order_model.dart';
import 'package:flutter_order_app/model/voucher_model.dart';
import 'package:flutter_order_app/shared/shared_value.dart';

class OrderRepository {
  final Dio dio = Dio();

  // Fetch Menu
  Future<List<MenuModel>> fetchMenu() async {
    try {
      final response = await dio.get(
        '$baseUrl/menus',
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return List<MenuModel>.from(
          (response.data['datas'] as List<dynamic>).map(
            (menu) => MenuModel.fromJson(menu),
          ),
        );
      }

      print('Fetch menu success : ${response.data}');

      throw jsonDecode(response.data)['message'];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VoucherModel>> fetchVoucher(String kode) async {
    try {
      final response = await dio.get(
        '$baseUrl/vouchers?kode=$kode',
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Pengecekan apakah response.data['datas'] adalah Map atau List
        if (response.data['datas'] is List) {
          return List<VoucherModel>.from(
            (response.data['datas'] as List<dynamic>).map(
              (voucher) => VoucherModel.fromJson(voucher),
            ),
          );
        } else if (response.data['datas'] is Map) {
          // Buat List dengan elemen tunggal berisi data dari Map
          final voucherData = response.data['datas'] as Map<String, dynamic>;
          final voucher = VoucherModel.fromJson(voucherData);
          return [voucher];
        } else {
          throw Exception('Unexpected response data format');
        }
      }

      print('Fetch voucher success : ${response.data}');

      throw jsonDecode(response.data)['message'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createOrder(OrderModel data) async {
    try {
      // Konversi data pesanan menjadi JSON menggunakan toJson() dari OrderModel
      String jsonData = jsonEncode(data.toJson());

      // Lakukan POST request dengan data JSON yang sudah dikonversi
      var response = await dio.post(
        '$baseUrl/order',
        data: jsonData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Success Create Order');
      } else {
        throw response.data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelOrder(int id) async {
    var response = await dio.delete(
      '$baseUrl/order/cancel/$id',
      options: Options(
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ),
    );

    if (response.statusCode == 200) {
      print('Success Delete Order');
    } else {
      throw response.data['message'];
    }
  }
  //   try {
  //     var formData = FormData.fromMap({
  //       'nominal_diskon': data.nominalDiskon,
  //       'nominal_pesanan': data.nominalPesanan,
  //     });

  //     var response = await dio.post(
  //       '$baseUrl/order',
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           HttpHeaders.contentTypeHeader: 'application/json',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       print('Success Create Order');
  //     } else {
  //       throw response.data['message'];
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
