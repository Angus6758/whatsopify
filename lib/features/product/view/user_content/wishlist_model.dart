

import 'package:seller_management/features/product/view/content/product_models.dart';

class WishlistData {
  WishlistData({
    required this.uid,
    required this.product,
  });

  factory WishlistData.fromMap(Map<String, dynamic> map) {
    return WishlistData(
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      product: ProductsData.fromMap(map['product']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'product': product.toMap(),
    };
  }

  final ProductsData product;
  final String uid;
}
