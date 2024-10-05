import 'dart:convert';

import 'package:seller_management/features/product/view/content/digital_product_models.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';


class ProductDetailsResponse {
  ProductDetailsResponse({
    this.product,
    required this.relatedProduct,
    this.digitalProduct,
  });

  factory ProductDetailsResponse.fromJson(String source) =>
      ProductDetailsResponse.fromMap(json.decode(source));

  factory ProductDetailsResponse.fromMap(Map<String, dynamic> map) {
    // print('Received Map ProductDetailsResponse: $map');
    // if(map == null){
    //   print("mapcontainnulldata $map");
    // }else{
    //   print('map contain data');
    // }
    return ProductDetailsResponse(
      product: map.containsKey('product')
          ? ProductsData.fromMap(map['product'])
          : null,
      digitalProduct: map.containsKey('digital_product')
          ? DigitalProduct.fromMap(map['digital_product'])
          : null,
      relatedProduct: List<dynamic>.from(
        map['related_product']['data']?.map((x) => map.containsKey('product')
            ? ProductsData.fromMap(x)
            : DigitalProduct.fromMap(x)),
      ),
    );
  }

  final ProductsData? product;
  final DigitalProduct? digitalProduct;
  final List<dynamic> relatedProduct;
}
