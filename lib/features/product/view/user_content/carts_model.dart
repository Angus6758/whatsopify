


import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';

class CartData {
  const CartData({
    required this.product,
    required this.uid,
    required this.price,
    required this.total,
    required this.variant,
    required this.quantity,
    required this.originalTotal,
    required this.totalTaxes,
    required this.discount,
    required this.basePrice,
    required this.baseDiscount,
    required this.tax,
  });

  factory CartData.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      print("map is null");
      throw Exception('Map is null');
    }
    print("received map: $map");
    return CartData(
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      price: map.parseNum('price'),
      quantity: map.parseInt('qty'),
      originalTotal: map.parseNum('original_total'),
      totalTaxes: map.parseNum('total_taxes'),
      discount: map.parseNum('discount'),
      total: map.parseNum('total'),
      variant: map['variant'] ?? (throw Exception('uid is missing from cart data')),
      product: ProductsData.fromMap(map['product']),
      basePrice: map.parseNum('base_price', map.parseNum('price')),
      baseDiscount: map.parseNum('base_discount', map.parseNum('price')),
      tax: map.parseNum('tax'),
    );
  }

  final String uid;
  final int quantity;
  final num basePrice;
  final num baseDiscount;
  final num price;
  final num discount;
  final num originalTotal;
  final num total;
  final num tax;
  final num totalTaxes;
  final String variant;
  final ProductsData product;

  num get variantPrice => product.variantPrices?[variant]?['discount'] ?? price;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'price': price,  // Correct key
      'qty': quantity,
      'total': total,
      'original_total': originalTotal,
      'total_taxes': totalTaxes,
      'discount': discount,
      'variant': variant,  // Correct key
      'product': product.toMap(),
      'base_price': basePrice,
      'base_discount': baseDiscount,
      'tax': tax,
    };
  }

  num get shippingFeeFormatted {
    num fee = product.shippingFee.formateSelf(rateCheck: true);
    if (product.multiplyFee) fee = fee * quantity;
    return fee;
  }

  CartData copyWith({
    num? price,
    num? total,
    num? originalTotal,
    num? totalTaxes,
    num? discount,
    String? variant,
    int? quantity,
    num? realPrice,
    num? baseDiscount,
    num? tax,
  }) {
    return CartData(
      product: product,
      uid: uid  ?? this.uid,
      originalTotal: originalTotal ?? this.originalTotal,
      totalTaxes: totalTaxes ?? this.totalTaxes,
      discount: discount ?? this.discount,
      price: price ?? this.price,
      total: total ?? this.total,
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
      basePrice: realPrice ?? basePrice,
      baseDiscount: baseDiscount ?? this.baseDiscount,
      tax: tax ?? this.tax,
    );
  }
}

