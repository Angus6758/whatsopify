import 'dart:convert';

import 'package:seller_management/features/product/view/base/item_list_with_page_data.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/region_settings/repository/region_repo.dart';

import '../../../../locator.dart';


class CategoriesBase {
  CategoriesBase({required this.categoriesData});

  factory CategoriesBase.fromJson(String source) =>
      CategoriesBase.fromMap(json.decode(source));

  factory CategoriesBase.fromMap(Map<String, dynamic> map) {
    return CategoriesBase(
      categoriesData: List<CategoriesData>.from(
          map['data']?.map((x) => CategoriesData.fromMap(x))),
    );
  }

  final List<CategoriesData> categoriesData;

  Map<String, dynamic> toMap() {
    return {
      'data': categoriesData.map((x) => x.toMap()),
    };
  }
}

class CategoriesData {
  CategoriesData({
    required this.uid,
    required this.names,
    required this.image,
  });

  factory CategoriesData.fromJson(String source) =>
      CategoriesData.fromMap(json.decode(source));

  factory CategoriesData.fromMap(Map<String, dynamic> map) {
    return CategoriesData(
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      names: Map<String, String?>.from(map['name']),
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': names,
      'image': image,
    };
  }

  String get name {
    final local = locate<RegionRepoEx1>().getLanguage();

    return names[local] ?? names.firstNoneNull() ?? 'N/A';
  }

  final String image;
  final Map<String, String?> names;
  final String uid;
}

class CategoryDetails {
  CategoryDetails({
    required this.category,
    required this.products,
    required this.homeTitle,
  });

  factory CategoryDetails.fromJson(String source) =>
      CategoryDetails.fromMap(json.decode(source));

  factory CategoryDetails.fromMap(Map<String, dynamic> map) {
    return CategoryDetails(
      category: CategoriesData.fromMap(map['category']),
      products: ItemListWithPageData<ProductsData>.fromMap(
        map['products'],
        (x) => ProductsData.fromMap(x),
      ),
      homeTitle: map['title'],
    );
  }

  final CategoriesData category;
  final ItemListWithPageData<ProductsData> products;
  final String? homeTitle;

  Map<String, dynamic> toMap() {
    return {
      'category': category.toMap(),
      'products': products.toMap((data) => data.toMap()),
      'title': homeTitle,
    };
  }
}
