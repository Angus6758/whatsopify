
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';

class CustomInfo {
  const CustomInfo({
    required this.name,
    required this.type,
    required this.options,
    required this.isRequired,
    required this.label,
  });

  factory CustomInfo.fromMap(Map<String, dynamic> map) {
    return CustomInfo(
      name: map['data_name'],
      isRequired: map.parseBool('data_required'),
      type: KFieldType.fromValue(map['type']),
      options: map['data_value'],
      label: map['data_label'],
    );
  }

  final String label;
  final bool isRequired;
  final String name;
  final String? options;
  final KFieldType type;

  List<String> get optionsList => options?.split(',').toList() ?? [];

  Map<String, dynamic> toMap() {
    return {
      'data_name': name,
      'data_required': isRequired ? '1' : '0',
      'type': type.name,
      'data_value': options,
      'data_label': label,
    };
  }
}

enum KFieldType {
  text,
  textarea,
  number,
  select;

  factory KFieldType.fromValue(String value) {
    return switch (value) {
      'textarea' => textarea,
      'number' => number,
      'select' => select,
      _ => text
    };
  }
}
