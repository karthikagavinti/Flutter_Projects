// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

// import 'order.dart'; // Adjust the path as necessary

// class FileUtils {
//   static Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   static Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/orders.json');
//   }

//   static Future<File> writeOrder(Order order) async {
//     final file = await _localFile;
//     String orderJson = jsonEncode(order.toJson());
//     return file.writeAsString(orderJson);
//   }

//   static Future<Order?> readOrder() async {
//     try {
//       final file = await _localFile;
//       String contents = await file.readAsString();
//       Map<String, dynamic> jsonMap = jsonDecode(contents);
//       return Order.fromJson(jsonMap);
//     } catch (e) {
//       // If there is an error reading, return null
//       return null;
//     }
//   }
// }
