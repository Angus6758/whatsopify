import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/settings/country.dart';
import 'package:seller_management/features/product/view/user_content/billing_address.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.address,
    required this.email,
    required this.image,
    required this.name,
    required this.phone,
    required this.uid,
    required this.username,
    this.imageFile,
    required this.id,
    required this.billingAddress,
    required this.country,
  });

  factory UserModel.fromFlatMap(Map<String, dynamic> map) {
    return UserModel(
      address: AddressModel(
        address: map['address'] ?? '',
        city: map['city'] ?? '',
        state: map['state'] ?? '',
        zip: map['zip'] ?? '',
        lat: map['latitude'] ?? '',
        lng: map['longitude'] ?? '',
      ),
      email: map['email'] ?? '',
      image: '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      uid: 'null' ?? "null uid",
      username: map['username'] ?? '',
      id: 0 ?? 3,
      billingAddress: const [],
      country: null,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      address: AddressModel.fromMap(map['address']),
      email: map['email'] ??(throw Exception('UID is missing or null')),
      image: map['image'] ?? (throw Exception('UID is missing or null')),
      name: map['name'] ?? (throw Exception('UID is missing or null')),
      phone: map['phone'] ?? (throw Exception('UID is missing or null')),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      username: map['username'] ?? (throw Exception('UID is missing or null')),
      id: map['id'] != null ? intFromAny(map['id']) : throw Exception('ID is missing or null'),
      billingAddress: List<BillingAddress>.from(
        (map['billing_address']?['data'] as List?)?.map(
              (e) => BillingAddress.fromMap(e),
            ) ??
            [],
      ),
      country: map.converter('country', (c) => Country.fromMap(c)),
    );
  }

  static UserModel empty = UserModel(
    address: AddressModel.empty,
    email: '',
    image: '',
    name: '',
    phone: '',
    uid: '',
    username: '',
    id: 7675,
    billingAddress: const [],
    country: null,
  );

  final AddressModel address;
  final List<BillingAddress> billingAddress;
  final String email;
  final int id;
  final String image;
  final File? imageFile;
  final String name;
  final String phone;
  final String uid;
  final String username;
  final Country? country;

  @override
  List<Object> get props {
    return [address, email, image, name, phone, uid, username, id];
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'address': address.toMap()});
    result.addAll({'email': email});
    result.addAll({'image': image});
    result.addAll({'name': name});
    result.addAll({'phone': phone});
    result.addAll({'uid': uid});
    result.addAll({'username': username});
    result.addAll({'id': id});
    result.addAll({
      'billing_address': {'data': billingAddress.map((e) => e.toMap()).toList()}
    });
    result.addAll({'country': country?.toMap()});

    return result;
  }

  UserModel setAddress({
    String? address,
    String? city,
    ValueGetter<String?>? lat,
    ValueGetter<String?>? lng,
    String? state,
    String? zip,
  }) {
    return copyWith(
      address: this.address.copyWith(
            address: address,
            city: city,
            state: state,
            zip: zip,
            lat: lat,
            lng: lng,
          ),
    );
  }

  //* modified to match the body of the post request
  //! The [File] image field is missing. It is added in the post method directly
  Map<String, dynamic> toPostMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'username': username});
    result.addAll({'phone': phone});
    result.addAll({...address.toMap()});
    result.addAll({'country_id': country?.id});

    return result;
  }

  UserModel copyWith({
    int? id,
    String? uid,
    String? name,
    String? username,
    String? image,
    ValueGetter<File?>? imageFile,
    String? email,
    String? phone,
    AddressModel? address,
    List<BillingAddress>? billingAddress,
    ValueGetter<Country?>? country,
  }) {
    return UserModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      image: image ?? this.image,
      imageFile: imageFile != null ? imageFile() : this.imageFile,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      billingAddress: billingAddress ?? this.billingAddress,
      country: country != null ? country() : this.country,
    );
  }
}

class AddressModel extends Equatable {
  const AddressModel({
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.lat,
    required this.lng,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      lat: map['latitude'],
      lng: map['longitude'],
    );
  }

  static AddressModel empty = const AddressModel(
    address: '',
    city: '',
    state: '',
    zip: '',
    lat: '',
    lng: '',
  );

  final String address;
  final String city;
  final String? lat;
  final String? lng;
  final String state;
  final String zip;

  @override
  List<Object> get props => [address, city, state, zip];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'address': address});
    result.addAll({'city': city});
    result.addAll({'state': state});
    result.addAll({'zip': zip});
    result.addAll({'latitude': lat});
    result.addAll({'longitude': lng});

    return result;
  }

  AddressModel copyWith({
    String? address,
    String? city,
    ValueGetter<String?>? lat,
    ValueGetter<String?>? lng,
    String? state,
    String? zip,
  }) {
    return AddressModel(
      address: address ?? this.address,
      city: city ?? this.city,
      lat: lat != null ? lat() : this.lat,
      lng: lng != null ? lng() : this.lng,
      state: state ?? this.state,
      zip: zip ?? this.zip,
    );
  }
}
