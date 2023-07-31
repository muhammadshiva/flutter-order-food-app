import 'package:flutter/material.dart';
import 'package:flutter_order_app/ui/order_confirmation_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Sukses',
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Order Berhasil!',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Terima kasih atas pesanan Anda.',
              style: GoogleFonts.montserrat(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Kembali ke halaman sebelumnya atau halaman utama setelah sukses
                Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) {
                //         OrderConfirmationScreen()
                //       },
                //     ));
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff009AAD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Kembali',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
