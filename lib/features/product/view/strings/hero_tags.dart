import 'dart:math';

import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';



class HeroTags {
  const HeroTags._();

  static String random = '${Random().nextInt(10000)}';

  static String productImgTag(ProductsData? product, String? type) => product ==
          null
      ? '$type$random'
      : '${product.featuredImage} _>_ ${product.name} _>_ ${product.uid.ifEmpty(random)} _>_ $type';

  static String iconTag(String uid, String? type) =>
      '${uid.ifEmpty(random)} _>_ $type';

  static String productNameTag(ProductsData? product, String? type) =>
      product == null
          ? '$type$random'
          : '${product.name} _>_ ${product.uid.ifEmpty(random)} _>_ $type';

  static String productPriceTag(ProductsData? product, String? type) => product ==
          null
      ? '$type$random'
      : '${product.price + product.discountAmount} _>_ ${product.uid.ifEmpty(random)} _>_ $type';
}
