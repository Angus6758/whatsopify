import 'package:seller_management/main.export.dart';

class BillingInfo {
  const BillingInfo({
    required this.address,
    required this.city,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.state,
    required this.zip,
    required this.country,
    required this.lat,
    required this.lng,
    required this.username,
  });

  factory BillingInfo.fromMap(Map<String, dynamic> map) {
    return BillingInfo(
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'],
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      country: map['country'] ?? '',
      lat: map['latitude'],
      lng: map['longitude'],
      username: map['username'],
    );
  }

  bool get canOpenMap => lat != null && lng != null;

  factory BillingInfo.fromAddress(BillingAddress address) {
    return BillingInfo(
      address: address.address,
      username: null,
      city: address.city?.name ?? '',
      email: address.email,
      firstName: address.firstName,
      lastName: address.lastName,
      phone: address.phone,
      state: address.state?.name ?? '',
      zip: address.zipCode,
      country: address.country?.name ?? '',
      lat: address.lat,
      lng: address.lng,
    );
  }

  final String firstName;
  final String lastName;
  final String? username;
  final String email;
  final String? phone;
  final String address;
  final String zip;
  final String city;
  final String state;
  final String country;
  final String? lat;
  final String? lng;

  String get fullName => isNamesEmpty ? 'N/A' : '$firstName $lastName';

  bool get isNamesEmpty => firstName.isEmpty && lastName.isEmpty;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'address': address});
    result.addAll({'city': city});
    result.addAll({'email': email});
    result.addAll({'first_name': firstName});
    result.addAll({'last_name': lastName});
    result.addAll({'phone': phone});
    result.addAll({'state': state});
    result.addAll({'zip': zip});
    result.addAll({'country': country});
    result.addAll({'latitude': lat});
    result.addAll({'longitude': lng});
    result.addAll({'username': username});

    return result;
  }
}
