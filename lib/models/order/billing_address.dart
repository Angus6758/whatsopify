import 'package:flutter/material.dart';

import '../../main.export.dart';

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

  BillingAddress copyWith({
    ValueGetter<int?>? id,
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
      id: id != null ? id() : this.id,
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
