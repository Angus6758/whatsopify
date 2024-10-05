import 'package:seller_management/main.export.dart';

class DigitalAttribute {
  DigitalAttribute({
    required this.id,
    required this.uid,
    required this.name,
    required this.status,
    required this.price,
    required this.shortDetails,
    required this.values,
    required this.createdAt,
  });

  factory DigitalAttribute.fromMap(Map<String, dynamic> map) {
    return DigitalAttribute(
     id: map.parseInt('id'),
      uid: map['uid'],
      name: map['name'] ?? '',
      status: map['status'] ?? '',
      price: map.parseInt('price'),
      shortDetails: map['short_details'] ?? '',
      values: List<DigitalAttributeValue>.from(map['values']?['data']
              ?.map((e) => DigitalAttributeValue.fromMap(e)) ??
          []),
      createdAt: map['created_at'] ?? '',
    );
  }

  final String createdAt;
  final int id;
  final String name;
  final int price;
  final String shortDetails;
  final String status;
  final String uid;
  final List<DigitalAttributeValue> values;

  static List<DigitalAttribute> mapToList(Map<String, dynamic> map) {
    final data = map['digital_attributes']?['data'];
    if (data == null) return [];
    return List<DigitalAttribute>.from(
      data?.map((e) => DigitalAttribute.fromMap(e)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'status': status,
      'price': price,
      'short_details': shortDetails,
      'values': values.map((e) => e.toMap()).toList(),
      'created_at': createdAt
    };
  }
}

class DigitalAttributeValue {
  DigitalAttributeValue({
    required this.id,
    required this.uid,
    required this.value,
    required this.createdAt,
    required this.status,
  });

  factory DigitalAttributeValue.fromMap(Map<String, dynamic> map) {
    return DigitalAttributeValue(
     id: map.parseInt('id'),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      value: map['value'] ?? '',
      createdAt: map['created_at'] ?? '',
      status: map['status'] ?? '',
    );
  }

  final String createdAt;
  final int id;
  final String status;
  final String uid;
  final String value;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'uid': uid});
    result.addAll({'value': value});
    result.addAll({'created_at': createdAt});
    result.addAll({'status': status});

    return result;
  }
}
