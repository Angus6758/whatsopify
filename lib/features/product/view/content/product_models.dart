import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:seller_management/features/product/view/content/store_model.dart';
import 'package:seller_management/features/product/view/content/tax.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/region_settings/repository/region_repo.dart';
import 'package:seller_management/features/product/view/settings/shipping_model.dart';

import '../../../../locator.dart';

class ProductsData {
  const ProductsData({
    required this.uid,
    required this.name,
    required this.order,
    required this.brandNames,
    required this.categoryNames,
    required this.price,
    required this.discountAmount,
    required this.inStock,
    required this.shortDescription,
    required this.description,
    required this.maximumPurchaseQty,
    required this.minimumPurchaseQty,
    required this.rating,
    required this.featuredImage,
    required this.galleryImage,
    required this.shippingInfo,
    required this.variantNames,
    required this.variantPrices,
    required this.url,
    required this.store,
    required this.weight,
    required this.shippingFee,
    required this.multiplyFee,
    required this.taxes,
  });

  factory ProductsData.fromJson(String source) =>
      ProductsData.fromMap(json.decode(source));

  factory ProductsData.fromMap(Map<String, dynamic> map) {
    // Print map for debugging
   // print('Received Map: $map');

    // Handle variantNames
    final variantNamesData = map['varient'];
    final Map<String, List<String>> variantNames = {};

    if (variantNamesData is List) {
      for (var item in variantNamesData) {
        if (item is Map) {
          final key = item['name']?.toString() ?? 'unknown_key';
          final attributes = item['stock_attributes'];

          if (attributes is List) {
            variantNames[key] = attributes
                .where((attr) => attr is Map)
                .map((attr) => attr['display_name']?.toString() ?? '')
                .where((displayName) => displayName.isNotEmpty)
                .toList();
          } else {
            print('Warning: Expected List for attributes, but got $attributes');
          }
        } else {
          print('Warning: Expected Map for item, but got $item');
        }
      }
    } else if (variantNamesData is Map) {
      variantNamesData.forEach((key, value) {
        if (value is List) {
          variantNames[key] = value
              .where((item) => item is String)
              .map((item) => item.toString())
              .toList();
        } else {
          print('Warning: Expected List for $key, but got $value');
        }
      });
    } else {
      print('Warning: Expected List or Map for variantNames, but got $variantNamesData');
    }

    // Handle variantPrices
    final variantPricesData = map['varient_price'];
    final Map<String, dynamic> variantPrices = {};

    if (variantPricesData is Map) {
      for (var key in variantPricesData.keys) {
        final value = variantPricesData[key];
        if (value is Map) {
          variantPrices[key] = value;
        } else {
          print('Warning: Expected Map for variantPrice, but got $value');
        }
      }
    } else if (variantPricesData is List) {
      print('Warning: Expected Map for variantPrices, but got a List');
    } else {
      print('Warning: Expected Map for variantPrices, but got $variantPricesData');
    }

    return ProductsData(
      brandNames: Map<String, String?>.from(map['brand']),
      categoryNames: Map<String, String?>.from(map['category']),
      description: map['description'] ?? '',
      featuredImage: map['featured_image'] ?? '',
      galleryImage: List<String>.from(map['gallery_image']),
      inStock: map['in_stock'] ?? false,
      maximumPurchaseQty: intFromAny(map['maximum_purchase_qty']),
      minimumPurchaseQty: intFromAny(map['minimum_purchaseqty']),
      name: map['name'] ?? '',
      order: map.parseInt('order'),
      price: map.parseNum('price'),
      discountAmount: map.parseNum('discount_amount'),
      rating: Rating.fromMap(map['rating']),
      shippingInfo: List<ShippingData>.from(
          map['shipping_info']['data']?.map((x) => ShippingData.fromMap(x))),
      shortDescription: map['short_description'] ?? '',
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      variantNames: variantNames,
      variantPrices: variantPrices,
      url: map['url'] ?? 'map is missing',
      store: map['seller'] == null ? null : StoreModel.fromMap(map['seller']),
      weight: map.parseNum('weight'),
      shippingFee: map.parseNum('shipping_fee'),
      multiplyFee: map['shipping_fee_multiply_by_qty'] ?? false,
      taxes: Tax.fromList(map['taxes']),
    );
  }


  static Map<String, List<String>> _convertListToMap(List<dynamic> list) {
    Map<String, List<String>> result = {};

    for (var item in list) {
      print('Processing item: $item'); // Debug line

      if (item is Map) {
        String key = item['name']?.toString() ?? 'unknown_key';
        var attributes = item['stock_attributes'];

        // Debug value type
        print('Key: $key, Attributes: $attributes, Attributes Type: ${attributes.runtimeType}');

        if (attributes is List) {
          List<String> values = [];
          for (var attribute in attributes) {
            if (attribute is Map) {
              var displayName = attribute['display_name']?.toString() ?? '';
              if (displayName.isNotEmpty) {
                values.add(displayName);
              } else {
                print('Warning: Empty display_name for key "$key"');
              }
            } else {
              print('Warning: Expected a Map for attributes, but got $attribute');
            }
          }
          result[key] = values;
        } else {
          print('Warning: Expected a List for key "$key", but got $attributes');
          result[key] = [];
        }
      } else {
        print('Warning: Expected a Map, but got $item');
      }
    }
    print("result $result");
    return result;
  }




  final Map<String, String?> brandNames;
  final Map<String, String?> categoryNames;
  final String description;
  final num discountAmount;
  final String featuredImage;
  final List<String> galleryImage;
  final bool inStock;
  final int maximumPurchaseQty;
  final int minimumPurchaseQty;
  final bool multiplyFee;
  final String name;
  final int order;
  final num price;
  final Rating rating;
  final num shippingFee;
  final List<ShippingData> shippingInfo;
  final String shortDescription;
  final StoreModel? store;
  final List<Tax> taxes;
  final String uid;
  final String url;
  final Map<String, List> variantNames;
  final Map<String, dynamic> variantPrices;
  final num weight;

  String get category {
    final local = locate<RegionRepoEx1>().getLanguage();

    return categoryNames[local] ?? categoryNames.firstNoneNull() ?? 'N/A';
  }

  String get brand {
    final local = locate<RegionRepoEx1>().getLanguage();

    return brandNames[local] ?? brandNames.firstNoneNull() ?? 'N/A';
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'order': order,
      'brand': brandNames,
      'category': categoryNames,
      'price': price,
      'discount_amount': discountAmount,
      'in_stock': inStock,
      'short_description': shortDescription,
      'description': description,
      'maximum_purchase_qty': maximumPurchaseQty,
      'minimum_purchaseqty': minimumPurchaseQty,
      'rating': rating.toMap(),
      'featured_image': featuredImage,
      'gallery_image': galleryImage,
      'shipping_info': {'data': shippingInfo.map((e) => e.toMap()).toList()},
      'varient': variantNames,
      'varient_price': variantPrices,
      'url': url,
      'seller': store?.toMap(),
      'weight': weight,
      'shipping_fee': shippingFee,
      'shipping_fee_multiply_by_qty': multiplyFee,
      'taxes': {'data': taxes.map((e) => e.toMap()).toList()},
    };
  }

  num calculatedPrice(num price) {
    return price + totalAdditiveTax(price);
  }

  num totalAdditiveTax(num price) {
    final flats = taxes
        .where((e) => !e.isPercentage())
        .map((e) => e.amount)
        .sum
        .formateSelf(rateCheck: true);

    final percentage =
        taxes.where((e) => e.isPercentage()).map((e) => e.amount).sum;

    final percentPrice = price * (percentage / 100);

    return percentPrice + flats;
  }

  String toJson() => json.encode(toMap());

  bool get isDiscounted => price != discountAmount;

  List<String> get variantTypes => variantNames.keys.toList();

  List<String> variantsByType(String type) =>
      variantNames[type]!.map((e) => e.toString()).toList();

  int get stockCount {
    int quantity = 0;
    variantPrices.forEach((key, value) {
      quantity += (value['qty'] as String?)?.asInt ?? 0;
    });
    return quantity;
  }

  bool get availableAny => stockCount > 0;
}



class VariantPrice {
  VariantPrice({
    required this.quantity,
    required this.price,
    required this.discount,
    required this.basePrice,
    required this.baseDiscount,
  });

  factory VariantPrice.fromMap(Map<String, dynamic> map) {
    return VariantPrice(
      quantity: map.parseInt('qty'),
      price: map.parseNum('price'),
      discount: map.parseNum('discount'),
      basePrice: map.parseNum('base_price'),
      baseDiscount: map.parseNum('base_discount'),
    );
  }

  final int quantity;
  final num basePrice;
  final num baseDiscount;
  final num price;
  final num discount;

  bool get isDiscounted => price != discount;
}

class Rating {
  Rating({
    required this.totalReview,
    required this.avgRating,
    required this.review,
  });

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      totalReview: intFromAny(map['total_review']),
      avgRating: map['avg_rating']?.toDouble() ?? 0.0,
      review: map['review'].isEmpty
          ? []
          : List<Review>.from(map['review']?.map((x) => Review.fromMap(x))),
    );
  }

  final double avgRating;
  final List<Review> review;
  final int totalReview;

  Map<String, dynamic> toMap() {
    return {
      'total_review': totalReview,
      'avg_rating': avgRating,
      'review': review.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class Review {
  Review({
    required this.user,
    required this.profile,
    required this.rating,
    required this.review,
  });

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      profile: map['profile'] ?? '',
      rating: intFromAny(map['rating']),
      review: map['review'] ?? '',
      user: map['user'] ?? '',
    );
  }

  final String profile;
  final int rating;
  final String review;
  final String user;

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'profile': profile,
      'rating': rating,
      'review': review,
    };
  }

  String toJson() => json.encode(toMap());
}

class ReviewPostData {
  ReviewPostData({
    required this.uid,
    required this.review,
    required this.rate,
  });

  final int rate;
  final String review;
  final String uid;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'rate': rate});
    result.addAll({'review': review});
    result.addAll({'product_uid': uid});

    return result;
  }

  ReviewPostData copyWith({
    int? rate,
    String? review,
    String? uid,
  }) {
    return ReviewPostData(
      rate: rate ?? this.rate,
      review: review ?? this.review,
      uid: uid ?? this.uid,
    );
  }
}
