import 'package:seller_management/main.export.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.uid,
    required this.sellerId,
    required this.name,
    required this.productType,
    required this.typeEnum,
    required this.warrantyPolicy,
    required this.brand,
    required this.category,
    required this.subCategory,
    required this.totalOrderCount,
    required this.totalDeliveredOrder,
    required this.totalPlacedOrder,
    required this.totalOrderAmount,
    required this.price,
    required this.discount,
    required this.discountPercentage,
    required this.maxPurchaseQty,
    required this.minPurchaseQty,
    required this.featuredImage,
    required this.galleryImage,
    required this.rating,
    required this.shortDescription,
    required this.description,
    required this.metaTitle,
    required this.metaKeywords,
    required this.url,
    required this.createdAt,
    required this.status,
    required this.attributes,
    required this.attributeValues,
    required this.shippings,
    required this.stock,
    required this.digitalAttributes,
    required this.weight,
    required this.shippingFee,
    required this.feeMultiplier,
    required this.tax,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    if(map == null){
      print("data is null from ProductModel");
    }
    return ProductModel(
     id: map.parseInt('id'),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      sellerId: map.parseInt('seller_id'),
      name: map['name'] ?? '',
      productType: map['product_type'] ?? '',
      typeEnum: map.parseInt('type_enum'),
      warrantyPolicy: map['warranty_policy'] ?? '',
      brand: map.converter('brand', (v) => Brand.fromMap(v)),
      category: Category.fromMap(map['category']),
      subCategory: map.converter('sub_category', (v) => Category.fromMap(v)),
      totalOrderCount: map.parseInt('total_order_count'),
      totalDeliveredOrder: map.parseInt('total_delivered_order'),
      totalPlacedOrder: map.parseInt('total_placed_order'),
      totalOrderAmount: map.parseInt('total_order_amount'),
      price: map.parseNum('price'),
      discount: map.parseNum('discount'),
      discountPercentage: map.parseNum('discount_percentage'),
      maxPurchaseQty: map.parseInt('maximum_purchase_qty'),
      minPurchaseQty: map.parseInt('minimum_purchaseqty'),
      featuredImage: map['featured_image'] ?? '',
      galleryImage: GalleryImage.mapToList(map),
      rating: RatingModel.fromMap(map['rating']),
      shortDescription: map['short_description'] ?? '',
      description: map['description'] ?? '',
      metaTitle: map['meta_title'] ?? '',
      metaKeywords: map.converter(
        'meta_keywords',
        (v) => List<String>.from(v),
        List<String>.empty(),
      ),
      url: map['url'] ?? '',
      createdAt: map['created_at'] ?? '',
      status: map['status'] ?? '',
      shippings: List<int>.from(map['shippings']),
      attributes: List<String>.from(map['attributes']),
      attributeValues: AttributeValue.mapToList(map),
      stock: Stock.mapToList(map),
      digitalAttributes: DigitalAttribute.mapToList(map),
      weight: map.parseNum('weight'),
      shippingFee: map.parseNum('shipping_fee'),
      feeMultiplier: map['shipping_fee_multiply_by_qty'] ?? false,
      tax: Tax.fromList(map['taxes']),
    );
  }

  final List<AttributeValue> attributeValues;
  final List<String> attributes;
  final Brand? brand;
  final Category category;
  final String createdAt;
  final String description;
  final List<DigitalAttribute> digitalAttributes;
  final num discount;
  final num discountPercentage;
  final String featuredImage;
  final bool feeMultiplier;
  final List<GalleryImage> galleryImage;
  final int id;
  final int maxPurchaseQty;
  final List<String> metaKeywords;
  final String metaTitle;
  final int minPurchaseQty;
  final String name;
  final num price;
  final String productType;
  final RatingModel rating;
  final int sellerId;
  final num shippingFee;
  final List<int> shippings;
  final String shortDescription;
  final String status;
  final List<Stock> stock;
  final Category? subCategory;
  final List<Tax> tax;
  final int totalDeliveredOrder;
  final int totalOrderAmount;
  final int totalOrderCount;
  final int totalPlacedOrder;
  final int typeEnum;
  final String uid;
  final String url;
  final String warrantyPolicy;
  final num weight;

  bool get isDigital => typeEnum == 101;

  bool get isPhysical => typeEnum == 102;
  bool get isDiscount => discountPercentage != 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'seller_id': sellerId,
      'name': name,
      'product_type': productType,
      'type_enum': typeEnum,
      'warranty_policy': warrantyPolicy,
      'brand': brand?.toMap(),
      'category': category.toMap(),
      'sub_category': subCategory?.toMap(),
      'total_order_count': totalOrderCount,
      'total_delivered_order': totalDeliveredOrder,
      'total_placed_order': totalPlacedOrder,
      'total_order_amount': totalOrderAmount,
      'price': price,
      'discount': discount,
      'discount_percentage': discountPercentage,
      'maximum_purchase_qty': maxPurchaseQty,
      'minimum_purchaseqty': minPurchaseQty,
      'featured_image': featuredImage,
      'gallery_image': galleryImage.map((e) => e.toMap()).toList(),
      'rating': rating.toMap(),
      'short_description': shortDescription,
      'description': description,
      'meta_title': metaTitle,
      'meta_keywords': metaKeywords,
      'url': url,
      'created_at': createdAt,
      'status': status,
      'shippings': shippings,
      'attributes': attributes,
      'attribute_values': attributeValues.map((e) => e.toMap()).toList(),
      'stock': stock.map((e) => e.toMap()).toList(),
      'digital_attributes': digitalAttributes.map((e) => e.toMap()).toList(),
      'weight': weight,
      'shipping_fee': shippingFee,
      'shipping_fee_multiply_by_qty': feeMultiplier,
      'taxes': {'data': tax.map((e) => e.toMap()).toList()},
    };
  }
}

class AttributeValue {
  AttributeValue({required this.id, required this.values});

  factory AttributeValue.fromMap(Map<String, dynamic> map) {
    return AttributeValue(
      id: map['attribute_id'] ?? '',
      values: List<String>.from(map['values']),
    );
  }

  final String id;
  final List<String> values;

  Map<String, dynamic> toMap() {
    return {
      'attribute_id': id,
      'values': values,
    };
  }

  static List<AttributeValue> mapToList(Map<String, dynamic> map) {
    return List<AttributeValue>.from(
      map['attribute_values']?.map((e) => AttributeValue.fromMap(e)),
    );
  }
}
