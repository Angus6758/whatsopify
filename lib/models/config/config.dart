import 'package:collection/collection.dart';
import 'package:seller_management/_core/_core.dart';

class Config {
  const Config({
    required this.registration,
    required this.deliveryStatus,
    required this.ticketPriority,
  });

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      registration: map['registration'] as bool,
      deliveryStatus: JEnum.fromMap(map['delevary_status']),
      ticketPriority: JEnum.fromMap(map['ticket_priority']),
    );
  }

  final JEnum deliveryStatus;
  final JEnum ticketPriority;
  final bool registration;

  List<MapEntry<String, int>> get validStatus => deliveryStatus.enumData.entries
      .where((e) => e.value == 2 || e.value == 3)
      .toList();

  Map<String, dynamic> toMap() {
    final data = {
      'registration': registration,
      'delevary_status': deliveryStatus.enumData,
      'ticket_priority': ticketPriority.enumData,
    };
    return data;
  }
}

class JEnum {
  JEnum({required this.enumData});

  final Map<String, int> enumData;

  factory JEnum.fromMap(Map<String, dynamic> map) {
    final data = map..forEach((key, value) => map[key] = map.parseInt(key));

    return JEnum(enumData: Map<String, int>.from(data));
  }

  /// Gets the value of the enum from the enum code
  String operator [](int code) {
    return enumData.entries.firstWhereOrNull((e) => e.value == code)?.key ??
        'Unknown';
  }
}
