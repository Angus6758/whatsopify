import 'package:seller_management/main.export.dart';

class AuthConfig {
  AuthConfig({
    required this.runningSubscription,
    required this.subscription,
    required this.categories,
    required this.brands,
    required this.shippingInfo,
    required this.attributes,
    required this.sizeGuide,
    required this.taxConfigs,
  });

  factory AuthConfig.fromMap(Map<String, dynamic> map) {
    return AuthConfig(
      runningSubscription: map['has_subscription_running'] ?? false,
      subscription: map['subscription'] == null
          ? null
          : SubscriptionInfo.fromMap(map['subscription']),
      categories: Category.mapToList('categories', map),
      brands: Brand.mapToList('brands', map),
      shippingInfo: ShippingProvider.mapToList('shipping_deliveries', map),
      attributes: AttributeData.mapToList('attributes', map),
      sizeGuide: SizeGuides.fromMap(map['product_size_guide']),
      taxConfigs: TaxConfig.fromList(map['tax_configuration']),
    );
  }

  final List<AttributeData> attributes;
  final List<Brand> brands;
  final List<Category> categories;
  final bool runningSubscription;
  final List<ShippingProvider> shippingInfo;
  final List<TaxConfig> taxConfigs;
  final SizeGuides sizeGuide;
  final SubscriptionInfo? subscription;

  Map<String, dynamic> toMap() {
    return {
      'has_subscription_running': runningSubscription,
      'subscription': subscription?.toMap(),
      'categories': {'data': categories.map((e) => e.toMap()).toList()},
      'brands': {'data': brands.map((e) => e.toMap()).toList()},
      'attributes': {'data': attributes.map((e) => e.toMap()).toList()},
      'product_size_guide': sizeGuide.toMap(),
      'shipping_deliveries': {
        'data': shippingInfo.map((e) => e.toMap()).toList()
      },
      'tax_configuration': {'data': taxConfigs.map((e) => e.toMap()).toList()},
    };
  }
}

class SizeGuides {
  SizeGuides({
    required this.feature,
    required this.gallery,
  });

  factory SizeGuides.fromMap(Map<String, dynamic> map) {
    return SizeGuides(
      feature: map['featured_image'] ?? '',
      gallery: map['gallery_image'] ?? '',
    );
  }

  final String feature;
  final String gallery;

  Map<String, dynamic> toMap() {
    return {
      'featured_image': feature,
      'gallery_image': gallery,
    };
  }
}

class TaxConfig {
  const TaxConfig({
    required this.name,
    required this.id,
  });

  factory TaxConfig.fromMap(Map<String, dynamic> map) {
    return TaxConfig(
      id: map.parseInt('id') ?? 5,
      name: map['tax_name'],
    );
  }

  static List<TaxConfig> fromList(Map<String, dynamic>? map) {
    final data = List<TaxConfig>.from(
      map?['data']?.map((e) => TaxConfig.fromMap(e)) ?? [],
    );

    return data;
  }

  final int id;
  final String name;

  Map<String, dynamic> toMap() => {'id': id, 'tax_name': name};
}
