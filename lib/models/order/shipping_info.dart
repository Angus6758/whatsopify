class ShippingInfo {
  ShippingInfo({
    required this.name,
    required this.method,
    required this.duration,
    required this.unit,
  });

  static ShippingInfo? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return ShippingInfo(
      name: map['name'] ?? '',
      method: map['method_name'] ?? '',
      duration: map['duration'] ?? '',
      unit: map['duration_unit'] ?? '',
    );
  }

  final String duration;
  final String method;
  final String name;
  final String unit;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'method_name': method,
      'duration': duration,
      'duration_unit': unit,
    };
  }
}
