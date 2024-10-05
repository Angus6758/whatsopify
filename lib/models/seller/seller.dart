import '../../main.export.dart';

class Seller {
  const Seller({
    required this.name,
    required this.username,
    required this.email,
    required this.rating,
    required this.phone,
    required this.address,
    required this.balance,
    required this.image,
    required this.shop,
    required this.isBanned,
  });

  factory Seller.fromMap(Map<String, dynamic> json) {
    return Seller(
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      rating: json.parseInt('rating'),
      phone: json['phone'] ?? '',
      address: json['address'] == null
          ? null
          : CustomerAddress.fromMap(json['address']),
      balance: json.parseInt('balance'),
      image: json['image'] ?? '',
      shop: ShopData.fromMap(json['shop']),
      isBanned: json['is_banned'] ?? false,
    );
  }

  final CustomerAddress? address;
  final int balance;
  final String email;
  final String image;
  final String name;
  final String phone;
  final int rating;
  final ShopData shop;
  final String username;
  final bool isBanned;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'rating': rating,
      'phone': phone,
      'address': address?.toMap(),
      'balance': balance,
      'image': image,
      'shop': shop.toMap(),
      'is_banned': isBanned,
    };
  }
}

class CustomerAddress {
  const CustomerAddress({
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.lat,
    required this.lng,
  });

  factory CustomerAddress.fromMap(Map<String, dynamic> json) {
    return CustomerAddress(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
      lat: json['latitude'] ?? '',
      lng: json['longitude'] ?? '',
    );
  }

  final String address;
  final String city;
  final String state;
  final String zip;
  final String? lat;
  final String? lng;

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'latitude': lat,
      'longitude': lng,
    };
  }
}
