import 'package:seller_management/main.export.dart';

class AttributeData {
  AttributeData({
    required this.uid,
    required this.id,
    required this.name,
    required this.values,
  });

  factory AttributeData.fromMap(Map<String, dynamic> map) {
    return AttributeData(
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
     id: map.parseInt('id'),
      name: map['name'] ?? '',
      values: mapToList('values', map),
    );
  }

  static List<AttributeData> mapToList(String key, Map<String, dynamic> map) {
    final data = map[key]?['data'];
    if (data == null) return [];
    return List<AttributeData>.from(
      data.map((e) => AttributeData.fromMap(e)),
    );
  }

  final int id;
  final String name;
  final String uid;
  final List<AttributeData> values;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'id': id,
      'name': name,
      'values': {
        'data': values.map((e) => e.toMap()).toList(),
      }
    };
  }
}
