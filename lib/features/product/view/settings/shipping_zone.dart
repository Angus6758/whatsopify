

import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/settings/country.dart';

class ShippingZone {
  const ShippingZone({
    required this.id,
    required this.countries,
  });

  factory ShippingZone.fromMap(Map<String, dynamic> map) {
    return ShippingZone(
     id: map.parseInt('id'),
      countries: Country.fromList(map['countries']),
    );
  }

  final List<Country> countries;
  final int id;

  static List<ShippingZone> fromList(Map<String, dynamic> map) {
    return List<ShippingZone>.from(
      map['data']?.map((x) => ShippingZone.fromMap(x)) ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'countries': {'data': countries.map((x) => x.toMap()).toList()},
    };
  }
}

class ShippingConfig {
  const ShippingConfig({
    required this.standardFee,
    required this.type,
  });

  factory ShippingConfig.fromMap(Map<String, dynamic>? map) {
    return ShippingConfig(
      standardFee: map?.parseNum('standard_shipping_fee') ?? 0,
      type: ShippingType.fromName(map?['shipping_option']),
    );
  }

  final num standardFee;
  final ShippingType type;

  Map<String, dynamic> toMap() {
    return {
      'standard_shipping_fee': standardFee,
      'shipping_option': type.name,
    };
  }
}

enum ShippingType {
  productCentric,
  flat,
  locationBased,
  carrierSpecific;

  String get name => switch (this) {
        productCentric => 'PRODUCT_CENTRIC',
        flat => 'FLAT',
        locationBased => 'LOCATION_BASED',
        carrierSpecific => 'CARRIER_SPECIFIC',
      };

  static ShippingType fromName(String? name) {
    return switch (name) {
      'PRODUCT_CENTRIC' => productCentric,
      'FLAT' => flat,
      'LOCATION_BASED' => locationBased,
      'CARRIER_SPECIFIC' => carrierSpecific,
      _ => productCentric,
    };
  }

  bool get isFlat => this == flat;
  bool get isLocationBased => this == locationBased;
  bool get isCarrierSpecific => this == carrierSpecific;
  bool get isProductCentric => this == productCentric;
}
