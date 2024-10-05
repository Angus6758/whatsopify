
import 'package:flutter/widgets.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/settings/country.dart';

class BillingAddress {
  const BillingAddress({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.state,
    required this.address,
    required this.zipCode,
    required this.country,
    required this.id,
    required this.addressName,
    required this.lat,
    required this.lng,
  });

  factory BillingAddress.fromMap(Map<String, dynamic> map) {
    return BillingAddress(
      id: map.parseInt('id', -1),
      addressName: map['name'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'],
      zipCode: map['zip'] ?? '',
      country: map.converter('country', (v) => Country.fromMap(v)),
      state: map.converter('state', (v) => CountryState.fromMap(v)),
      city: map.converter('city', (v) => StateCity.fromMap(v)),
      address: _parseAddress(map, 'address') ?? '',
      lat: map['address']?['latitude'],
      lng: map['address']?['longitude'],
    );
  }

  static String? _parseAddress(Map<String, dynamic> map, String key) {
    final address = map[key];
    if (address is String) return address;
    if (address is Map<String, dynamic>) return address[key];

    return null;
  }

  static BillingAddress empty = const BillingAddress(
    id: null,
    addressName: '',
    firstName: '',
    address: '',
    lastName: '',
    email: '',
    phone: null,
    city: null,
    state: null,
    country: null,
    zipCode: '',
    lat: null,
    lng: null,
  );

  final int? id;
  final String addressName;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;

  final String address;
  final String zipCode;
  final Country? country;
  final CountryState? state;
  final StateCity? city;
  final String? lat;
  final String? lng;

  String get fullName => '$firstName $lastName';

  BillingAddress copyWith({
    // ValueGetter<int?>? id,
    String? addressName,
    String? firstName,
    String? lastName,
    String? email,
    ValueGetter<String?>? phone,
    String? address,
    String? zipCode,
    ValueGetter<Country?>? country,
    ValueGetter<CountryState?>? state,
    ValueGetter<StateCity?>? city,
    ValueGetter<String?>? lat,
    ValueGetter<String?>? lng,
  }) {
    return BillingAddress(
      id: id,
      addressName: addressName ?? this.addressName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone != null ? phone() : this.phone,
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
      country: country != null ? country() : this.country,
      state: state != null ? state() : this.state,
      city: city != null ? city() : this.city,
      lat: lat != null ? lat() : this.lat,
      lng: lng != null ? lng() : this.lng,
    );
  }

  bool get isNamesEmpty => firstName.isEmpty && lastName.isEmpty;

  BillingAddress copyWithMap(Map<String, dynamic> map) {
    return BillingAddress(
      id: id,
      addressName: addressName,
      firstName: map['first_name'] ?? firstName,
      lastName: map['last_name'] ?? lastName,
      email: map['email'] ?? email,
      phone: map['phone'] ?? phone,
      address: map['address'] ?? address,
      zipCode: map['zip'] ?? zipCode,
      country: map.converter('country', (v) => Country.fromMap(v), country),
      state: map.converter('state', (v) => CountryState.fromMap(v), state),
      city: map.converter('city', (v) => StateCity.fromMap(v), city),
      lat: map['latitude'] ?? lat,
      lng: map['longitude'] ?? lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': addressName,
      'first_name': firstName,
      'last_name': lastName,
      'address': {'address': address, 'latitude': lat, 'longitude': lng},
      'email': email,
      'phone': phone,
      'city': city?.toMap(),
      'state': state?.toMap(),
      'country': country?.toMap(),
      'zip': zipCode,
      'id': id,
    };
  }
}
