import 'models/product.dart';

class CatalogProduct {
  static final items = [
    Product(
        id: 0,
        title: 'KFC',
        desc:
            'ไก่ทอดเคนทักกี (อังกฤษ: Kentucky Fried Chicken) เป็นร้านอาหารจานด่วนมีหลายสาขาทั่วโลกที่เน้นอาหารประเภทไก่ทอด',
        imageUrl:
            "https://tse4.mm.bing.net/th?id=OIP.TmskcDaOoPVGmD6ddsWAXwHaHa&pid=Api"),
    Product(
        id: 1,
        title: 'McDonalds',
        desc:
            'อาหารหลักที่ขายทั่วไปคือ แฮมเบอร์เกอร์ ชีสเบอร์เกอร์ เฟรนช์ฟรายส์ ไก่ทอด สลัด ชุดอาหารเช้า ชุดอาหารสำหรับเด็กชื่อ แฮปปี้มีล และของหวานอีกหลายชนิด',
        imageUrl:
            "https://logos-world.net/wp-content/uploads/2020/04/McDonalds-Logo.png")
  ];
}
