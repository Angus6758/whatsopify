import 'package:seller_management/main.export.dart';

class ShippingProvider {
  const ShippingProvider({
    required this.description,
    required this.duration,
    required this.image,
    required this.methodName,
    required this.priceConfigs,
    required this.uid,
    required this.id,
    required this.isFreeShipping,
    required this.type,
  });

  factory ShippingProvider.fromMap(Map<String, dynamic> map) {
    return ShippingProvider(
     id: map.parseInt('id'),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      methodName: map['method_name'] ?? '',
      duration: map['duration'] ?? '',
      description: map['description'] ?? '',
      priceConfigs: ShippingPriceConfig.fromList(map['price_configuration']),
      image: map['image'],
      isFreeShipping: map.parseBool('is_free_shipping'),
      type: map['shipping_type'] ?? '',
    );
  }
  static List<ShippingProvider> mapToList(String key, QMap map) {
    final data = map[key]?['data'];
    if (data == null) return [];
    return List<ShippingProvider>.from(
      data.map((e) => ShippingProvider.fromMap(e)),
    );
  }

  final String description;
  final String duration;
  final int id;
  final String image;
  final bool isFreeShipping;
  final String methodName;
  final List<ShippingPriceConfig> priceConfigs;
  final String type;
  final String uid;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'method_name': methodName,
      'duration': duration,
      'description': description,
      'price_configuration': priceConfigs.map((e) => e.toMap()).toList(),
      'image': image,
      'is_free_shipping': isFreeShipping,
      'shipping_type': type,
    };
  }
}

class ShippingPriceConfig {
  const ShippingPriceConfig({
    required this.zoneId,
    required this.greaterThan,
    required this.lessThanEq,
    required this.cost,
  });

  factory ShippingPriceConfig.fromMap(Map<String, dynamic> map) {
    return ShippingPriceConfig(
      zoneId: map.parseInt('zone_id'),
      greaterThan: map.parseNum('greater_than'),
      lessThanEq: map.parseNum('less_than_eq'),
      cost: map.parseNum('cost'),
    );
  }

  final num cost;
  final num greaterThan;
  final num lessThanEq;
  final int zoneId;

  static List<ShippingPriceConfig> fromList(List? list) {
    return List<ShippingPriceConfig>.from(
      list?.map((x) => ShippingPriceConfig.fromMap(x)) ?? [],
    );
  }

  bool isBetween(num amount) {
    final data = amount > greaterThan.formateSelf(rateCheck: true) &&
        amount <= lessThanEq.formateSelf(rateCheck: true);

    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'cost': cost,
      'greater_than': greaterThan,
      'less_than_eq': lessThanEq,
      'zone_id': zoneId,
    };
  }
}

enum ShippingCarrierType {
  priceWise,
  weightWise;

  String get name {
    return switch (this) {
      priceWise => 'price_wise',
      weightWise => 'weight_wise',
    };
  }

  static ShippingCarrierType fromName(String? name) {
    return switch (name) {
      'price_wise' => priceWise,
      'weight_wise' => weightWise,
      _ => priceWise,
    };
  }
}
