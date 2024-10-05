import 'package:seller_management/main.export.dart';

class Customer {
  const Customer({
    required this.uid,
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.image,
    required this.address,
    required this.country,
    required this.billingAddress,
    required this.lastMessage,
  });

  static Customer? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    if (map['latest_conversation'] == null) {}
    return Customer(
      uid: map['uid'],
     id: map.parseInt('id'),
      name: map['name'] ?? '',
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      image: map['image'],
      address: map.converter('address', (v) => CustomerAddress.fromMap(v)),
      country: map.converter('country', (x) => Country.fromMap(x)),
      billingAddress: map['billing_address'],
      lastMessage: map.converter(
        'latest_conversation',
        (x) => CustomerMessage.fromMap(x),
      ),
    );
  }

  final CustomerAddress? address;
  final dynamic billingAddress;
  final Country? country;
  final String email;
  final int id;
  final String image;
  final String name;
  final String? phone;
  final String uid;
  final String? username;
  final CustomerMessage? lastMessage;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'image': image,
      'address': address?.toMap(),
      'country': country,
      'billing_address': billingAddress,
      'latest_conversation': lastMessage?.toMap(),
    };
  }
}
