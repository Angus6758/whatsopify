
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/misc/pagination.dart';

class SearchBaseModel {
  SearchBaseModel({
    required this.products,
    required this.pagination,
  });

  factory SearchBaseModel.fromMap(Map<String, dynamic> map) {
    return SearchBaseModel(
      products: List<ProductsData>.from(
          map['products']['data']?.map((x) => ProductsData.fromMap(x))),
      pagination: PaginationInfo.fromMap(map['products']['pagination']),
    );
  }

  final List<ProductsData> products;
  final PaginationInfo pagination;
}
