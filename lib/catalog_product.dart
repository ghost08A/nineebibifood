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
            "https://logos-world.net/wp-content/uploads/2020/04/McDonalds-Logo.png"),
    Product(
        id: 1,
        title: 'The Pizza Company',
        desc:
            'The Pizza Company เป็นที่รู้จักในเรื่อง พิซซ่าหน้าหนา หน้าจัดเต็ม ที่มีชีสเยิ้มและเครื่องแน่น ต่างจากแบรนด์พิซซ่าอื่นที่เน้นแป้งมากกว่า',
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/The_Pizza_Company_Logo_%282023%29.svg/1200px-The_Pizza_Company_Logo_%282023%29.svg.png"),
  ];
}
