import 'package:flutter/material.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final String orderId = "asd";
  final double totalPrice = 1000.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // แสดงรูป QR Code PromptPay
              QRCodeGenerate(
                promptPayId: "0655389857",
                amount: totalPrice,
                width: 400,
                height: 400,
              ),

              const SizedBox(height: 10),
              Text(
                "Total Price: ${totalPrice.toStringAsFixed(2)} ฿",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Order ID: $orderId",
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/homenine');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // เปลี่ยนสีปุ่มเป็นฟ้า
                  foregroundColor: Colors.white, // เปลี่ยนสีตัวอักษรเป็นขาว
                  elevation: 6, // เพิ่มความนูนของปุ่ม
                  shadowColor: Colors.blueAccent, // เพิ่มเงาสีน้ำเงินให้ปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // ทำให้ปุ่มมีมุมโค้ง
                  ),
                  minimumSize:
                      Size(double.infinity, 50), // ทำให้ปุ่มเต็มความกว้าง
                ),
                child: Text(
                  'Home',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
