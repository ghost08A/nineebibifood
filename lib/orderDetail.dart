import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Orderdetail extends StatefulWidget {
  const Orderdetail({super.key});

  @override
  State<Orderdetail> createState() => _OrderdetailState();
}

class _OrderdetailState extends State<Orderdetail> {
  int _selectedDeliveryOption = 0;
  int _selectedEcoOption = 0;
  List<Map<String, dynamic>> orderItems = [];
  late String shopName;

  @override
  void initState() {
    super.initState();
    // ✅ รับข้อมูลจาก `Get.arguments` ที่ส่งมาจาก `Menu1`
    final Map<String, dynamic> args = Get.arguments ?? {};
    orderItems = List<Map<String, dynamic>>.from(args['items'] ?? []);
    shopName = args['shop_name'];

    setState(() {
      _selectedDeliveryOption = args['delivery_option'] ?? 0;
      _selectedEcoOption = args['eco_option'] == true ? 1 : 0;
    });
  }

  final double standardDeliveryPrice = 15.00;
  final double expressDeliveryPrice = 25.00;
  final double nextDayDeliveryPrice = 40.00;
  final double ecoOptionPrice = 1.00;

  double getSelectedDeliveryPrice() {
    switch (_selectedDeliveryOption) {
      case 0:
        return standardDeliveryPrice;
      case 1:
        return expressDeliveryPrice;
      case 2:
        return nextDayDeliveryPrice;
      default:
        return 0.0;
    }
  }

  double getTotalPrice() {
    double deliveryPrice = getSelectedDeliveryPrice();
    double ecoPrice = _selectedEcoOption == 1 ? ecoOptionPrice : 0.0;
    double itemsPrice = orderItems.fold(
        0,
        (sum, item) =>
            sum + (item['price'] as double) * (item['quantity'] as int));
    return deliveryPrice + ecoPrice + itemsPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // utf8.decode(item['name'].toString().codeUnits)
        title: Text('$shopName',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Options',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...[
                            {
                              'label': 'ส่งถูกสุด',
                              'price': standardDeliveryPrice,
                              'value': 0
                            },
                            {
                              'label': 'ส่งธรรมดา',
                              'price': expressDeliveryPrice,
                              'value': 1
                            },
                            {
                              'label': 'ส่งเร็วทันใจ',
                              'price': nextDayDeliveryPrice,
                              'value': 2
                            },
                          ].map((option) {
                            bool isSelected =
                                _selectedDeliveryOption == option['value'];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDeliveryOption =
                                      option['value'] as int;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.green.shade600
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      option['label'] as String,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      '${(option['price'] as double).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ...orderItems.map((item) => Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //utf8.decode(markets[index]['name'].toString().codeUnits),
                                      Text(
                                        '${item['quantity']} x ${utf8.decode(item['name'].toString().codeUnits)}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        '${(item['price'] as double).toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Divider(),
                                  SizedBox(height: 5),
                                ],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eco-friendly Options',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          SizedBox(height: 10),
                          RadioListTile<int>(
                            title: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'ฉันต้องการรับช้อนซ้อมพลาสติก',
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: Text(
                                '${ecoOptionPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ),
                            value: 1,
                            groupValue: _selectedEcoOption,
                            activeColor: Colors.green.shade700,
                            onChanged: (value) {
                              setState(() {
                                _selectedEcoOption = value!;
                              });
                            },
                          ),
                          Divider(thickness: 1, color: Colors.grey.shade300),
                          RadioListTile<int>(
                            title: Text(
                              'ฉันไม่ต้องการรับช้อนซ้อมพลาสติก',
                              style: TextStyle(fontSize: 18),
                            ),
                            value: 0,
                            groupValue: _selectedEcoOption,
                            activeColor: Colors.green.shade700,
                            onChanged: (value) {
                              setState(() {
                                _selectedEcoOption = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${getTotalPrice().toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/payment', arguments: {
                      "items": orderItems,
                      "shop_name": shopName,
                      "delivery_option": _selectedDeliveryOption,
                      "delivery_price": getSelectedDeliveryPrice(),
                      "eco_option": _selectedEcoOption == 1,
                      "total_price": getTotalPrice(),
                    });
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
                    'ชำระเงิน',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
