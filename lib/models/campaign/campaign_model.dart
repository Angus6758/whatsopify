import 'package:seller_management/main.export.dart';

class CampaignModel {
  CampaignModel({
    required this.name,
    required this.image,
    required this.startTime,
    required this.endTime,
    required this.discount,
    required this.discountType,
    required this.products,
  });

  factory CampaignModel.fromMap(Map<String, dynamic> map) {
    return CampaignModel(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      discount: map.parseInt('discount'),
      discountType: map['discount_type'] ?? '',
      products: List<ProductModel>.from(
        map['products']?['data'].map((x) => ProductModel.fromMap(x)),
      ),
    );
  }

  final num discount;
  final String discountType;
  final String endTime;
  final String image;
  final String name;
  final List<ProductModel> products;
  final String startTime;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'name': name});
    result.addAll({'image': image});
    result.addAll({'start_time': startTime});
    result.addAll({'end_time': endTime});
    result.addAll({'discount': discount});
    result.addAll({'discount_type': discountType});
    result.addAll({'products': products.map((x) => x.toMap()).toList()});

    return result;
  }
}
