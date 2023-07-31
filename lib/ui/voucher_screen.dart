// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_order_app/data/bloc/voucher/voucher_bloc.dart';
// import 'package:flutter_order_app/ui/order_screen.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'order_confirmation_screen.dart';

// class VoucherScreen extends StatefulWidget {
//   final String kode;

//   const VoucherScreen({super.key, required this.kode});

//   @override
//   State<VoucherScreen> createState() => _VoucherScreenState();
// }

// class _VoucherScreenState extends State<VoucherScreen> {
//   bool selected = false;
//   int nominal = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Input Voucher',
//           style: GoogleFonts.montserrat(),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Daftar Voucher Anda',
//               style: GoogleFonts.montserrat().copyWith(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 10),
//             BlocProvider(
//               create: (context) => VoucherBloc()..add(Voucher(widget.kode)),
//               child: BlocBuilder<VoucherBloc, VoucherState>(
//                 builder: (context, state) {
//                   if (state is VoucherSuccess) {
//                     return SizedBox(
//                       height: 500,
//                       child: ListView.builder(
//                         itemCount: state.voucher.length,
//                         itemBuilder: (context, index) {
//                           var data = state.voucher[index];
//                           return Card(
//                             child: ListTile(
//                               onTap: () {
//                                 setState(() {
//                                   selected = true;
//                                   nominal = data.nominal;
//                                 });
//                               },
//                               title: Text('Voucher'),
//                               subtitle: Text('Rp ${data.nominal}'),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }

//                   if (state is VoucherFailed) {
//                     print(state.e);
//                   }

//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: selected == true
//           ? Padding(
//               padding: const EdgeInsets.all(20),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OrderConfirmationScreen(
//                           // nominalVoucher: nominal,
//                           ),
//                     ),
//                   );
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => OrderConfirmationScreen(
//                   //       nominalVoucher: nominal,
//                   //     ),
//                   //   ),
//                   // );
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   height: 42,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Color(0xff009AAD),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Text(
//                     'Pilih Voucher',
//                     style: GoogleFonts.montserrat(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           : Container(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }
