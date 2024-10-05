
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seller_management/features/product/view/content/brand_models.dart';
import 'package:seller_management/features/product/view/content/category_models.dart';
import 'package:seller_management/features/product/view/content/digital_product_models.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/misc/pagination.dart';

enum SortType {
  lowToHigh,
  highToLow;

  const SortType();

  String translated(BuildContext context) {
    return switch (this) {
      lowToHigh => TR.lowToHigh(context),
      highToLow => TR.highToLow(context),
    };
  }

  String get queryParam {
    return switch (this) {
      lowToHigh => 'lowtohigh',
      highToLow => 'hightolow',
    };
  }
}

class ProductFilteringState {
  ProductFilteringState({
    required this.brand,
    required this.category,
    required this.max,
    required this.min,
    required this.sortType,
    required this.products,
    this.pagination,
  });

  final BrandData? brand;
  final CategoriesData? category;
  final String max;
  final String min;
  final SortType sortType;
  final PaginationInfo? pagination;
  final Either<List<ProductsData>, List<DigitalProduct>> products;

  ProductFilteringState copyWith({
    BrandData? brand,
    CategoriesData? category,
    String? max,
    String? min,
    SortType? sortType,
    Either<List<ProductsData>, List<DigitalProduct>>? products,
    PaginationInfo? pagination,
  }) {
    return ProductFilteringState(
      brand: brand ?? this.brand,
      category: category ?? this.category,
      max: max ?? this.max,
      min: min ?? this.min,
      sortType: sortType ?? this.sortType,
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
    );
  }

  ProductFilteringState setRegular(
    List<ProductsData> products, [
    PaginationInfo? pagination,
  ]) {
    return copyWith(
      products: left(products),
      pagination: pagination,
    );
  }

  ProductFilteringState setDigital(
    List<DigitalProduct> products, [
    PaginationInfo? pagination,
  ]) {
    return copyWith(
      products: right(products),
      pagination: pagination,
    );
  }

  static final empty = ProductFilteringState(
    brand: null,
    category: null,
    max: '',
    min: '',
    sortType: SortType.highToLow,
    pagination: null,
    products: left(<ProductsData>[]),
  );
}
