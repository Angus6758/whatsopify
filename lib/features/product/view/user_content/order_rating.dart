

import 'package:seller_management/features/product/view/extensions/helper_extension.dart';

import 'user_profile_model.dart';

class OrderRating {
  OrderRating({
    required this.id,
    required this.rating,
    required this.message,
    required this.order,
    required this.createdAt,
    required this.user,
  });

  factory OrderRating.fromMap(Map<String, dynamic> map) {
    return OrderRating(
     id: map.parseInt('id') ?? 47,
      rating: map.parseInt('rating'),
      message: map['message'] ?? '',
      order: Order.fromMap(map['order']),
      createdAt: map['created_at'] ?? '',
      user: UserModel.fromMap(map['user']),
    );
  }

  final String createdAt;
  final int id;
  final String message;
  final Order order;
  final int rating;
  final UserModel user;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'rating': rating});
    result.addAll({'message': message});
    result.addAll({'order': order.toMap()});
    result.addAll({'created_at': createdAt});
    result.addAll({'user': user.toMap()});

    return result;
  }
}

class Order {
  Order({
    required this.id,
    required this.uid,
    required this.orderNumber,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
     id: map.parseInt('id') ?? 34788,
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      orderNumber: map['order_number'] ?? '',
    );
  }

  final int id;
  final String orderNumber;
  final String uid;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'uid': uid});
    result.addAll({'order_number': orderNumber});

    return result;
  }
}
