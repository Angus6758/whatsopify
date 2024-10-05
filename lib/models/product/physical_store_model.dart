import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seller_management/main.export.dart';

class PhysicalStoreState {
  PhysicalStoreState({
    this.id,
    this.galleryWithId,
    required this.name,
    required this.categoryId,
    required this.subCategoryId,
    required this.description,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaKeywords,
    required this.price,
    required this.discountPercentage,
    required this.minQty,
    required this.maxQty,
    required this.shortDescription,
    required this.shippingDeliveryIds,
    required this.featuredImage,
    required this.choiceNos,
    required this.warrantyPolicy,
    required this.brandId,
    required this.gallery,
    required this.attributeData,
    required this.choiceOptions,
    required this.weight,
    required this.shippingFee,
    required this.feeMultiplier,
    required this.taxIds,
    required this.taxAmounts,
    required this.taxTypes,
  });

  factory PhysicalStoreState.fromProduct(ProductModel? product) {
    final options = <String, List<String>>{};
    final attributes = <String, dynamic>{};
    if (product != null) {
      for (var attr in product.attributeValues) {
        options['choice_options_${attr.id}'] = attr.values;
      }
      for (var stock in product.stock) {
        attributes['price_${stock.attribute}'] = stock.price;
        attributes['qty_${stock.attribute}'] = stock.qty;
      }
    }

    return PhysicalStoreState(
      id: product?.uid,
      name: product?.name,
      categoryId: product?.category.id.toString(),
      subCategoryId: product?.subCategory?.id.toString(),
      description: product?.description,
      metaTitle: product?.metaTitle,
      metaDescription: product?.metaTitle,
      metaKeywords: product?.metaKeywords,
      price: product?.price.toString(),
      discountPercentage: product?.discountPercentage.toString(),
      minQty: product?.minPurchaseQty.toString(),
      maxQty: product?.maxPurchaseQty.toString(),
      shortDescription: product?.shortDescription,
      shippingDeliveryIds: product?.shippings.map((e) => e.toString()).toList(),
      featuredImage:
          product?.featuredImage == null ? null : left(product!.featuredImage),
      gallery: product?.galleryImage == null
          ? null
          : product!.galleryImage
              .map((e) => left<String, File>(e.url))
              .toList(),
      galleryWithId: product?.galleryImage,
      warrantyPolicy: product?.warrantyPolicy,
      brandId: product?.brand?.id.toString(),
      choiceNos: product?.attributes,
      attributeData: attributes,
      choiceOptions: options,
      weight: product?.weight.toString(),
      shippingFee: product?.shippingFee.toString() ?? '0',
      feeMultiplier: product?.feeMultiplier ?? false,
      taxIds: null,
      taxAmounts: product?.tax.map((e) => '${e.amount}').toList(),
      taxTypes: product?.tax.map((e) => e.isPercentage() ? '0' : '1').toList(),
    );
  }

  final String? id;
  final String? brandId;
  final String? categoryId;
  final String? description;
  final String? discountPercentage;
  final Either<String, File>? featuredImage;
  final List<Either<String, File>>? gallery;
  final List<GalleryImage>? galleryWithId;
  final String? maxQty;
  final String? metaDescription;
  final List<String>? metaKeywords;
  final String? metaTitle;
  final String? minQty;
  final String? name;
  final String? price;
  final List<String>? shippingDeliveryIds;
  final String? shortDescription;
  final String? subCategoryId;
  final String? warrantyPolicy;
  final List<String>? choiceNos;
  final QMap? attributeData;
  final Map<String, List<String>>? choiceOptions;
  final String? weight;
  final String? shippingFee;
  final bool feeMultiplier;
  final List<String>? taxIds;
  final List<String>? taxAmounts;
  final List<String>? taxTypes;

  bool isBasicInfoDone() {
    return price.isNotNullOrEmpty() &&
        maxQty.isNotNullOrEmpty() &&
        minQty.isNotNullOrEmpty() &&
        shortDescription.isNotNullOrEmpty() &&
        description.isNotNullOrEmpty();
  }

  bool isMetaDataDone() {
    return metaDescription.isNotNullOrEmpty() &&
        metaTitle.isNotNullOrEmpty() &&
        metaKeywords.isNotNullOrEmpty();
  }

  bool isTaxDataDone() {
    return taxAmounts.isNotNullOrEmpty() && taxTypes.isNotNullOrEmpty();
  }

  bool isAttributeValid() {
    final isEmptyOrNull = choiceNos.isNullOrEmpty() ||
        attributeData.isNullOrEmpty() ||
        choiceOptions.isNullOrEmpty();

    if (isEmptyOrNull) return false;

    var length =
        choiceOptions?.values.map((e) => e.length).reduce((a, b) => a * b) ?? 0;

    return (choiceNos?.length == choiceOptions?.length) ||
        (attributeData?.length == length * 2);
  }

  bool isCategoryDone() => categoryId.isNotNullOrEmpty();

  (bool, String) validateRequired() {
    if (name.isNullOrEmpty()) {
      return (false, 'Name is required');
    }
    if (price.isNullOrEmpty()) {
      return (false, 'Price is required');
    }
    if (maxQty.isNullOrEmpty()) {
      return (false, 'Maximum quantity is required');
    }
    if (minQty.isNullOrEmpty()) {
      return (false, 'Minimum quantity is required');
    }
    if (weight.isNullOrEmpty()) {
      return (false, 'Product weight is required');
    }
    if (shippingFee.isNullOrEmpty()) {
      return (false, 'Flat Shipping fee is required');
    }

    if (shortDescription.isNullOrEmpty()) {
      return (false, 'Short description is required');
    }
    if (description.isNullOrEmpty()) {
      return (false, 'Description is required');
    }
    if (featuredImage.isNullOrEmpty()) {
      return (false, 'Featured image is required');
    }
    if (gallery.isNullOrEmpty()) {
      return (false, 'At least one image is required');
    }
    if (choiceNos.isNullOrEmpty()) {
      return (false, 'At least one Attribute is required');
    }
    if (categoryId.isNullOrEmpty()) {
      return (false, 'Category is required');
    }

    return (true, '');
  }

  Map<String, dynamic> toMap([bool excludeFile = true]) {
    final data = {
      'name': name,
      'price': price,
      'discount_percentage': discountPercentage,
      'minimum_purchase_qty': minQty,
      'maximum_purchase_qty': maxQty,
      'short_description': shortDescription,
      'description': description,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'brand_id': brandId,
      'meta_title': metaTitle,
      'meta_keywords': metaKeywords,
      'meta_description': metaDescription,
      if (!excludeFile) 'featured_image': featuredImage,
      if (!excludeFile) 'gallery_image': gallery,
      'shipping_delivery_id': shippingDeliveryIds,
      'warranty_policy': warrantyPolicy,
      'choice_no': choiceNos,
      'weight': weight,
      'shipping_fee': shippingFee ?? 0,
      'shipping_fee_multiply': feeMultiplier ? 1 : 0,
      'tax_id': taxIds,
      'tax_amount': taxAmounts,
      'tax_type': taxTypes,
      ...?attributeData,
      ...?choiceOptions,
    };

    return data;
  }

  Future<Map<String, dynamic>> toMapMultiPart() async {
    final feature = await featuredImage?.fold(
      (l) => null,
      (r) async => await MultipartFile.fromFile(
        r.path,
        filename: r.path.split('/').last,
      ),
    );

    final galleryParts = <MultipartFile>[];
    for (var img in gallery ?? []) {
      await img.fold(
        (l) => null,
        (r) async {
          final file = await MultipartFile.fromFile(
            r.path,
            filename: r.path.split('/').last,
          );
          galleryParts.add(file);
        },
      );
    }

    return {
      'featured_image': feature,
      'gallery_image': galleryParts,
    };
  }

  PhysicalStoreState copyWithMap(Map<String, dynamic> map) {
    return PhysicalStoreState(
      id: id,
      name: map.notNullOrEmpty('name') ?? name,
      categoryId: map.notNullOrEmpty('category_id') ?? categoryId,
      subCategoryId: map.notNullOrEmpty('sub_category_id') ?? subCategoryId,
      description: map.notNullOrEmpty('description') ?? description,
      metaTitle: map.notNullOrEmpty('meta_title') ?? metaTitle,
      metaDescription:
          map.notNullOrEmpty('meta_description') ?? metaDescription,
      metaKeywords: metaKeywords,
      price: map.notNullOrEmpty('price') ?? price,
      discountPercentage:
          map.notNullOrEmpty('discount_percentage') ?? discountPercentage,
      minQty: map.notNullOrEmpty('minimum_purchase_qty') ?? minQty,
      maxQty: map.notNullOrEmpty('maximum_purchase_qty') ?? maxQty,
      shortDescription:
          map.notNullOrEmpty('short_description') ?? shortDescription,
      shippingDeliveryIds: map.converter(
        'shipping_delivery_id',
        (v) => List<String>.from(v),
        shippingDeliveryIds,
      ),
      choiceNos: map.converter(
        'choice_no',
        (v) => List<String>.from(v),
        choiceNos,
      ),
      warrantyPolicy: map.notNullOrEmpty('warranty_policy') ?? warrantyPolicy,
      brandId: map.notNullOrEmpty('brand_id') ?? brandId,
      featuredImage: featuredImage,
      gallery: gallery,
      attributeData: attributeData,
      choiceOptions: choiceOptions,
      weight: map.notNullOrEmpty('weight') ?? weight,
      shippingFee: map.notNullOrEmpty('shipping_fee') ?? shippingFee,
      feeMultiplier:
          map.notNullOrEmpty('shipping_fee_multiply') ?? feeMultiplier,
      taxIds: taxIds,
      taxAmounts: taxAmounts,
      taxTypes: taxTypes,
    );
  }

  PhysicalStoreState copyWith({
    ValueGetter<String?>? brandId,
    ValueGetter<String?>? categoryId,
    ValueGetter<List<String>?>? choiceNos,
    ValueGetter<String?>? description,
    ValueGetter<String?>? discountPercentage,
    ValueGetter<Either<String, File>?>? featuredImage,
    ValueGetter<List<Either<String, File>>?>? gallery,
    ValueGetter<String?>? maxQty,
    ValueGetter<String?>? metaDescription,
    ValueGetter<List<String>?>? metaKeywords,
    ValueGetter<String?>? metaTitle,
    ValueGetter<String?>? minQty,
    ValueGetter<String?>? name,
    ValueGetter<String?>? price,
    ValueGetter<List<String>?>? shippingDeliveryIds,
    ValueGetter<String?>? shortDescription,
    ValueGetter<String?>? subCategoryId,
    ValueGetter<String?>? warrantyPolicy,
    ValueGetter<QMap?>? attributeData,
    ValueGetter<Map<String, List<String>>?>? choiceOptions,
    ValueGetter<String?>? weight,
    ValueGetter<String?>? shippingFee,
    bool? feeMultiplier,
    ValueGetter<List<String>?>? taxIds,
    ValueGetter<List<String>?>? taxAmounts,
    ValueGetter<List<String>?>? taxTypes,
  }) {
    return PhysicalStoreState(
      id: id,
      brandId: brandId != null ? brandId() : this.brandId,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      choiceNos: choiceNos != null ? choiceNos() : this.choiceNos,
      description: description != null ? description() : this.description,
      discountPercentage: discountPercentage != null
          ? discountPercentage()
          : this.discountPercentage,
      featuredImage:
          featuredImage != null ? featuredImage() : this.featuredImage,
      gallery: gallery != null ? gallery() : this.gallery,
      maxQty: maxQty != null ? maxQty() : this.maxQty,
      metaDescription:
          metaDescription != null ? metaDescription() : this.metaDescription,
      metaKeywords: metaKeywords != null ? metaKeywords() : this.metaKeywords,
      metaTitle: metaTitle != null ? metaTitle() : this.metaTitle,
      minQty: minQty != null ? minQty() : this.minQty,
      name: name != null ? name() : this.name,
      price: price != null ? price() : this.price,
      shippingDeliveryIds: shippingDeliveryIds != null
          ? shippingDeliveryIds()
          : this.shippingDeliveryIds,
      shortDescription:
          shortDescription != null ? shortDescription() : this.shortDescription,
      subCategoryId:
          subCategoryId != null ? subCategoryId() : this.subCategoryId,
      warrantyPolicy:
          warrantyPolicy != null ? warrantyPolicy() : this.warrantyPolicy,
      attributeData:
          attributeData != null ? attributeData() : this.attributeData,
      choiceOptions:
          choiceOptions != null ? choiceOptions() : this.choiceOptions,
      galleryWithId: galleryWithId,
      weight: weight != null ? weight() : this.weight,
      shippingFee: shippingFee != null ? shippingFee() : this.shippingFee,
      feeMultiplier: feeMultiplier ?? this.feeMultiplier,
      taxIds: taxIds != null ? taxIds() : this.taxIds,
      taxAmounts: taxAmounts != null ? taxAmounts() : this.taxAmounts,
      taxTypes: taxTypes != null ? taxTypes() : this.taxTypes,
    );
  }
}
