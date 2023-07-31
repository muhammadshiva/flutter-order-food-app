import 'package:flutter_order_app/model/menu_model.dart';
import 'package:flutter_order_app/model/order_model.dart';
import 'package:flutter_order_app/model/voucher_model.dart';
import 'package:flutter_order_app/repositories/order_repository.dart';
import 'package:flutter_order_app/ui/success_screen.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var menu = <MenuModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    try {
      isLoading.value = true;
      var menuData = await OrderRepository().fetchMenu();
      menu.assignAll(menuData);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

class CreateOrderController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;

  Future<void> createDosen(OrderModel data) async {
    try {
      isLoading.value = true;
      error.value = '';
      await OrderRepository().createOrder(data);
      print('Create Order Success From Controller');

      // Navigate to another page if success
      Get.to(SuccessScreen());
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

class CancelOrderController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;

  Future<void> createDosen(int id) async {
    try {
      isLoading.value = true;
      error.value = '';
      await OrderRepository().cancelOrder(id);
      print('Cancel Order Success From Controller');

      // Navigate to another page if success
      Get.to(SuccessScreen());
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
