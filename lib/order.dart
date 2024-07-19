// class Order {
//   final String poNumber;
//   final String date;
//   final String contact;
//   final String address;

//   Order({
//     required this.poNumber,
//     required this.date,
//     required this.contact,
//     required this.address,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       poNumber: json['poNumber'],
//       date: json['date'],
//       contact: json['contact'],
//       address: json['address'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'poNumber': poNumber,
//       'date': date,
//       'contact': contact,
//       'address': address,
//     };
//   }
// }
