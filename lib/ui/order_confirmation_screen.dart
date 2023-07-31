import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_app/data/bloc/voucher/voucher_bloc.dart';
import 'package:flutter_order_app/data/controller/order_controller.dart';
import 'package:flutter_order_app/ui/order_confirmation_screen.dart';
import 'package:flutter_order_app/ui/voucher_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final int totalPrice;
  final int totalVoucher;
  final int totalAmount;

  const OrderConfirmationScreen({
    super.key,
    required this.totalPrice,
    required this.totalVoucher,
    required this.totalAmount,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final CancelOrderController _cancelOrderController = Get.put(CancelOrderController());
  final OrderController _orderController = Get.put(OrderController());
  TextEditingController voucherController = TextEditingController();
  bool selected = false;
  Map<int, int> amounts = {}; // Map untuk menyimpan jumlah pesanan
  Map<int, int> totalPrices = {}; // Map untuk menyimpan total harga

  int amount = 0;
  int totalPrice = 0;
  int totalVoucher = 0;

  void _closeAllBottomSheets() {
    Navigator.popUntil(context, (route) => !Navigator.of(context).canPop());
  }

  void _validateVoucher(String kodeVoucher) {
    // Panggil event Voucher pada bloc dan kirim kode voucher sebagai argumennya
    VoucherBloc voucherBloc = context.read<VoucherBloc>();
    voucherBloc.add(Voucher(kodeVoucher));
  }

  void _showVoucherListBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/voucher.png',
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Daftar Voucher Anda',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              BlocProvider(
                create: (context) => VoucherBloc()..add(Voucher(voucherController.text)),
                child: BlocBuilder<VoucherBloc, VoucherState>(
                  builder: (context, state) {
                    if (state is VoucherSuccess) {
                      return SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: state.voucher.length,
                          itemBuilder: (context, index) {
                            var data = state.voucher[index];
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    selected = true;
                                    totalVoucher = data.nominal;
                                    print('Voucher dipilih : $selected');
                                    // nominal = data.nominal;
                                  });
                                },
                                title: Text('Voucher'),
                                subtitle: Text(
                                  "Rp ${NumberFormat('#,###', 'id').format(data.nominal)}",
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    if (state is VoucherFailed) {
                      print(state.e);
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              totalVoucher == 0
                  ? Container()
                  : InkWell(
                      onTap: () {
                        print('VOUCHER : ${voucherController.text}');
                        print('NOMINAL VOUCHER : $totalVoucher');
                        // Navigator.pop(context);
                        _closeAllBottomSheets();
                        // Get.to(
                        //   VoucherScreen(
                        //     kode: voucherController.text,
                        //   ),
                        // );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 42,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xff009AAD),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Pilih Voucher',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
            ],
          ),
        );
      },
    );
  }

  void _showVoucherBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200, // Sesuaikan dengan ukuran yang diinginkan
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/voucher.png',
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Punya kode voucher ?',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'Masukan kode voucher disini',
                style: GoogleFonts.montserrat(
                  color: Color(0xff2E2E2E),
                ),
              ),
              const Spacer(),
              TextField(
                controller: voucherController,
                decoration: InputDecoration(
                  labelText: 'Masukkan kode voucher',
                ),
              ),
              // const SizedBox(height: 16),
              const Spacer(),
              InkWell(
                onTap: () {
                  print('VOUCHER : ${voucherController.text}');
                  _showVoucherListBottomSheet();
                  // Get.to(
                  //   VoucherScreen(
                  //     kode: voucherController.text,
                  //   ),
                  // );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 42,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff009AAD),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Validasi Voucher',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Color(0xff00717F),
                size: 36,
              ),
              SizedBox(width: 10),
              Text(
                'Konfirmasi',
                style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Apakah anda yakin ingin membatalkan pesanan ini ?',
            style: GoogleFonts.montserrat(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog saat tombol "Batal" ditekan
              },
              child: Text(
                'Batal',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('Yakin');
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff00717F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Yakin',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Order',
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
          ),
          // Obx(
          //   () {
          //     if (_orderController.isLoading.value) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else if (_orderController.error.value.isNotEmpty) {
          //       return Text(_orderController.error.value);
          //     } else {
          //       return Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 27),
          //         child: Container(
          //           height: MediaQuery.of(context).size.height * 0.55,
          //           child: ListView.builder(
          //             itemCount: _orderController.menu.length,
          //             itemBuilder: (context, index) {
          //               var data = _orderController.menu[index];

          //               if (!amounts.containsKey(data.id)) {
          //                 // Jika belum ada, set jumlah pesanan dan total harga menjadi 0
          //                 amounts[data.id!] = 0;
          //                 totalPrices[data.id!] = 0;
          //               }

          //               return cardMenu(data.nama, data.harga, data.id!);
          //             },
          //           ),
          //         ),
          //       );
          //     }
          //   },
          // ),
          Stack(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                decoration: BoxDecoration(
                  color: Color(0xffEBEBEB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25), // Melengkungkan pojok kiri atas
                    topRight: Radius.circular(25), // Melengkungkan pojok kanan atas
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Total Pesanan ',
                                style: GoogleFonts.montserrat().copyWith(
                                  color: Color(0xff2E2E2E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold, // Tambahkan properti fontWeight di sini
                                ),
                              ),
                              TextSpan(
                                text: '(${widget.totalAmount} Menu) : ', // Menggunakan fungsi untuk menghitung jumlah total pesanan
                                style: GoogleFonts.montserrat().copyWith(
                                  color: Color(0xff2E2E2E),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Rp ${NumberFormat('#,###', 'id').format(widget.totalPrice)}",
                          // 'Rp ${widget.totalPrice}', // Menggunakan fungsi untuk menghitung total harga
                          style: GoogleFonts.montserrat().copyWith(
                            color: Color(0xff009AAD),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 2),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset(
                          'assets/voucher.png',
                          height: 20,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Voucher',
                          style: GoogleFonts.montserrat().copyWith(
                            color: Color(0xff2E2E2E),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        widget.totalVoucher == 0
                            ? InkWell(
                                // onTap: () {
                                //   _showVoucherBottomSheet(); // Panggil fungsi untuk menampilkan bottom sheet
                                // },
                                child: Text(
                                  'Tidak ada voucher',
                                  style: GoogleFonts.montserrat().copyWith(
                                    color: Color(0xff2E2E2E),
                                  ),
                                ),
                              )
                            : InkWell(
                                // onTap: () {
                                //   _showVoucherBottomSheet(); // Panggil fungsi untuk menampilkan bottom sheet
                                // },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'hemat',
                                      style: GoogleFonts.montserrat().copyWith(),
                                    ),
                                    Text(
                                      "Rp ${NumberFormat('#,###', 'id').format(widget.totalVoucher)}",
                                      style: GoogleFonts.montserrat().copyWith(
                                        color: Color(0xffD81D1D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        // Icon(Icons.arrow_right),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  height: 65,
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 18),
                  width: MediaQuery.of(context).size.width, // Lebar container mengikuti lebar layar
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25), // Melengkungkan pojok kiri atas
                      topRight: Radius.circular(25), // Melengkungkan pojok kanan atas
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/cart.png',
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Text(
                            'Total Pembayaran',
                            style: GoogleFonts.montserrat().copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "Rp ${NumberFormat('#,###', 'id').format(widget.totalPrice)}",
                            style: GoogleFonts.montserrat().copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff009AAD),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          _showConfirmationDialog(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => OrderConfirmationScreen(
                          //         // nominalVoucher: totalVoucher,
                          //         // totalAmount: widget.totalAmount,
                          //         // totalPrice: widget.totalPrice,
                          //         ),
                          //   ),
                          // );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 175,
                          height: 42,
                          decoration: BoxDecoration(
                            color: widget.totalPrice == 0 ? Color(0xffBCBBBB) : Color(0xff009AAD),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Batalkan Pesanan',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
