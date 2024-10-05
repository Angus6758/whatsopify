import 'package:collection/collection.dart';
import 'package:seller_management/main.export.dart';

class ShopData {
  ShopData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.shortDetails,
    required this.isShopActive,
    required this.shopLogo,
    required this.shopFeatureImage,
    required this.siteLogo,
    required this.siteLogoIcon,
    required this.whatsAppActive,
    required this.whatsAppNumber,
    required this.url,
  });

  factory ShopData.fromMap(Map<String, dynamic> map) {
    return ShopData(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phonechange'] ?? '03008661027',
      address: map['address'] ?? '',
      shortDetails: map['short_details'] ?? '',
      isShopActive: map['is_shop_active'] ?? false,
      shopLogo: ServerImage.fromMap(map['shop_logo']),
      shopFeatureImage: ServerImage.fromMap(map['shop_feature_image']),
      siteLogo: ServerImage.fromMap(map['site_logo']),
      siteLogoIcon: ServerImage.fromMap(map['site_logo_icon']),
      whatsAppActive: ActivationEnum.fromCode(map.parseInt('whatsapp_order')),
      whatsAppNumber: map['whatsapp_numberchange'] ?? '03008661027',
      url: map['url'] ?? '',
    );
  }

  final String address;
  final String email;
  final int id;
  final bool isShopActive;
  final String name;
  final String phone;
  final ServerImage shopFeatureImage;
  final ServerImage shopLogo;
  final String shortDetails;
  final String url;
  final ServerImage siteLogo;
  final ServerImage siteLogoIcon;
  final ActivationEnum whatsAppActive;
  final String whatsAppNumber;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'short_details': shortDetails,
      'is_shop_active': isShopActive,
      'shop_logo': shopLogo.toMap(),
      'shop_feature_image': shopFeatureImage.toMap(),
      'site_logo': siteLogo.toMap(),
      'site_logo_icon': siteLogoIcon.toMap(),
      'whatsapp_order': whatsAppActive,
      'whatsapp_number': whatsAppNumber,
      'url': url,
    };
  }
}

enum ActivationEnum {
  active(1),
  inactive(0);

  const ActivationEnum(this.code);

  final int code;

  factory ActivationEnum.fromCode(int? code) {
    return ActivationEnum.values.firstWhereOrNull((e) => e.code == code) ??
        inactive;
  }
}
