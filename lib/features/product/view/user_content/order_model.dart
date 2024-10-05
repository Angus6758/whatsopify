
import 'package:flutter/material.dart';
import 'package:seller_management/features/product/view/content/digital_product_models.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/user_content/billing_address.dart';
import 'package:seller_management/features/product/view/user_content/order_rating.dart';

enum OrderStatus {
  placed,
  confirmed,
  processing,
  shipped,
  delivered,
  cancel;

  const OrderStatus();

  factory OrderStatus.fromMap(String name) => values.byName(name.toLowerCase());
  factory OrderStatus.fromInt(int value) => switch (value) {
        1 => placed,
        2 => confirmed,
        3 => processing,
        4 => shipped,
        5 => delivered,
        6 => cancel,
        _ => cancel,
      };

  IconData get icon => switch (this) {
        placed => Icons.hourglass_bottom_rounded,
        confirmed => Icons.check_circle_rounded,
        processing => Icons.inventory_2_rounded,
        shipped => Icons.local_shipping_outlined,
        delivered => Icons.markunread_mailbox_outlined,
        cancel => Icons.cancel_rounded,
      };

  String get title => switch (this) {
        placed => 'Order Placed',
        confirmed => 'Order Confirmed',
        processing => 'Picked by courier',
        shipped => 'On The Way',
        delivered => 'Ready for pickup',
        cancel => 'Order Canceled',
      };
  int get ordered => switch (this) {
        placed => 1,
        confirmed => 2,
        processing => 3,
        shipped => 4,
        delivered => 5,
        cancel => 6,
      };

  static List<OrderStatus> get trackValues =>
      [placed, confirmed, processing, shipped, delivered];
  static List<OrderStatus> get cancelValues => [placed, cancel];

  bool get isFirst => placed == this;
  bool get isLast => delivered == this;
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.uid,
    required this.orderId,
    required this.orderDate,
    required this.quantity,
    required this.shippingCharge,
    required this.discount,
    required this.amount,
    required this.originalAmount,
    required this.totalTax,
    required this.paymentType,
    required this.paymentStatus,
    required this.shippingMethod,
    required this.status,
    required this.statusLog,
    required this.orderDetails,
    required this.billingAddress,
    required this.paymentDetails,
    required this.orderRatings,
    required this.customInfo,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
     id: map.parseInt('id') ?? 56,
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      orderId: map['order_id'] ?? '',
      shippingCharge: map['shipping_charge']?.toDouble() ?? 0,
      discount: map['discount']?.toDouble() ?? 0,
      amount: map['amount']?.toDouble() ?? 0,
      paymentType: map['payment_type'],
      paymentStatus: map['payment_status'] ?? '',
      orderDetails: _parseOrderDetails(map['order_details']),
      billingAddress: _parseBilling(map),
      paymentDetails: map['payment_details'] ?? {},
      quantity: map['quantity'] ?? 1,
      status: OrderStatus.fromMap(map['status']),
      orderDate: DateTime.parse(map['order_date']),
      shippingMethod: map['shipping_method'],
      statusLog: List<StatusLog>.from(
        map['status_log']?.map((x) => StatusLog.fromMap(x)),
      ),
      orderRatings: List<OrderRating>.from(
        map['order_ratings']?['data']?.map((x) => OrderRating.fromMap(x)) ?? [],
      ),
      totalTax: map.parseNum('total_taxes'),
      originalAmount: map.parseNum('original_amount'),
      customInfo: map['custom_information'] ?? {},
    );
  }
  static List<OrderDetails> _parseOrderDetails(dynamic data) {
    if (data is! Map<String, dynamic>) return [];

    return List<OrderDetails?>.from(
      data['data']?.map(
        (x) {
          if (x is! Map<String, dynamic>) return null;
          if (x['product'] == null) return null;
          return OrderDetails.fromMap(x);
        },
      ),
    ).removeNull();
  }

  static BillingInfo? _parseBilling(dynamic map) {
    final address = map['billing_address'];
    final newAddress = map['new_billing_address'];

    if (newAddress is Map<String, dynamic>) {
      final it = BillingAddress.fromMap(newAddress);
      return BillingInfo.fromAddress(it);
    }
    if (address is Map<String, dynamic>) return BillingInfo.fromMap(address);

    return null;
  }

  final int id;
  final double amount;
  final BillingInfo? billingAddress;
  final double discount;
  final DateTime orderDate;
  final List<OrderDetails> orderDetails;
  final String orderId;
  final String paymentStatus;
  final String? paymentType;
  final int? quantity;
  final double shippingCharge;
  final String? shippingMethod;
  final OrderStatus status;
  final List<StatusLog> statusLog;
  final String uid;
  final Map<String, dynamic> paymentDetails;
  final Map<String, dynamic> customInfo;

  final num originalAmount;
  final num totalTax;
  final List<OrderRating> orderRatings;

  StatusLog? statusLogOf(OrderStatus status) {
    if (status == OrderStatus.placed) {
      return StatusLog(
        note: 'Order was placed successfully',
        statusInt: 1,
        date: orderDate,
      );
    }
    if (statusLog.isEmpty) return null;

    if (!statusLog.map((e) => e.orderStatus).contains(status)) {
      if (status.ordered > this.status.ordered) return null;
      return null;
    }
    return statusLog.lastWhere((element) => element.orderStatus == status);
  }

  DateTime get statusDateNow {
    if (statusLog.isEmpty) return orderDate;
    final logs = statusLogOf(status);
    if (logs == null) return orderDate;
    return logs.date;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'order_id': orderId,
      'order_date': orderDate.toIso8601String(),
      'quantity': quantity,
      'shipping_charge': shippingCharge,
      'discount': discount,
      'amount': amount,
      'original_amount': originalAmount,
      'total_taxes': totalTax,
      'payment_type': paymentType,
      'payment_status': paymentStatus,
      'shipping_method': shippingMethod,
      'status': status.name,
      'status_log': statusLog.map((x) => x.toMap()).toList(),
      'order_details': {'data': orderDetails.map((x) => x.toMap()).toList()},
      'billing_address': billingAddress?.toMap(),
      'payment_details': paymentDetails,
      'order_ratings': {'data': orderRatings.map((x) => x.toMap()).toList()},
      'custom_information': customInfo,
    };
  }

  bool get isCOD => paymentType == 'Cash On Delivary';
  bool get isPaid => paymentStatus == 'Paid';
}

class OrderDetails {
  const OrderDetails({
    required this.uid,
    required this.product,
    required this.digitalProduct,
    required this.orderId,
    required this.quantity,
    required this.totalPrice,
    required this.originalTotalPrice,
    required this.totalTax,
    required this.discount,
    required this.attribute,
  });

  factory OrderDetails.fromMap(Map<String, dynamic> map) {
    final isRegular = !Map.from(map['product']).containsKey('attribute');

    return OrderDetails(
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      product: isRegular ? ProductsData.fromMap(map['product']) : null,
      digitalProduct: isRegular ? null : DigitalProduct.fromMap(map['product']),
      orderId: map.parseInt('order_id'),
      quantity: map.parseInt('quantity'),
      totalPrice: map.parseNum('total_price'),
      originalTotalPrice: map.parseNum('original_total_price'),
      totalTax: map.parseNum('total_taxes'),
      discount: map.parseNum('discount'),
      attribute: map['attribute'] ?? '',
    );
  }

  final String uid;
  final String? attribute;
  final DigitalProduct? digitalProduct;
  final int orderId;
  final ProductsData? product;
  final int quantity;
  final num totalPrice;
  final num originalTotalPrice;
  final num totalTax;
  final num discount;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'product': isRegular ? product?.toMap() : digitalProduct?.toMap(),
      'order_id': orderId,
      'quantity': quantity,
      'total_price': totalPrice,
      'original_total_price': originalTotalPrice,
      'total_taxes': totalTax,
      'discount': discount,
      'attribute': attribute,
    };
  }

  bool get isRegular => product != null;
}

class BillingInfo {
  const BillingInfo({
    required this.address,
    required this.city,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.state,
    required this.zip,
    required this.country,
    required this.lat,
    required this.lng,
  });

  factory BillingInfo.fromMap(Map<String, dynamic> map) {
    return BillingInfo(
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      country: map['country'] ?? '',
      lat: map['latitude'],
      lng: map['longitude'],
    );
  }
  factory BillingInfo.fromAddress(BillingAddress address) {
    return BillingInfo(
      address: address.address,
      city: address.city?.name ?? '',
      email: address.email,
      firstName: address.firstName,
      lastName: address.lastName,
      phone: address.phone,
      state: address.state?.name ?? '',
      zip: address.zipCode,
      country: address.country?.name ?? '',
      lat: address.lat,
      lng: address.lng,
    );
  }

  final String address;
  final String city;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String state;
  final String zip;
  final String country;
  final String? lat;
  final String? lng;

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'state': state,
      'zip': zip,
      'country': country,
      'latitude': lat,
      'longitude': lng,
    };
  }

  String get fullName => '$firstName $lastName';

  bool get isNamesEmpty => firstName.isEmpty && lastName.isEmpty;
}

class PaymentLog {
  PaymentLog({
    required this.method,
    required this.charge,
    required this.uid,
    required this.trx,
    required this.amount,
    required this.finalAmount,
    required this.exchangeRate,
    required this.payable,
    required this.payStatus,
  });

  factory PaymentLog.fromMap(Map<String, dynamic>? map) {
    if (map == null) return PaymentLog.codLog;
    return PaymentLog(
      method: PaymentData.fromMap(map['payment_method']),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      trx: map['trx_number'] ?? '',
      amount: intFromAny(map['amount']),
      finalAmount: doubleFromAny(map['final_amount']),
      charge: doubleFromAny(map['charge']),
      payable: doubleFromAny(map['payable']),
      exchangeRate: doubleFromAny(map['exchange_rate']),
      payStatus: map['status']?.toString() ?? '1',
    );
  }

  static final PaymentLog codLog = PaymentLog(
    method: PaymentData.codPayment,
    charge: 0,
    uid: 'cod',
    trx: 'cod',
    amount: 0,
    finalAmount: 0,
    exchangeRate: 0,
    payable: 0,
    payStatus: 'cod',
  );

  final int amount;
  final double charge;
  final double payable;
  final double finalAmount;
  final double exchangeRate;
  final PaymentData method;
  final String trx;
  final String uid;

  /// 1 pending 2 success, 3 cancel
  final String payStatus;

  Map<String, dynamic> toMap() {
    return {
      'payment_method': method.toMap(),
      'uid': uid,
      'trx_number': trx,
      'amount': amount,
      'final_amount': finalAmount,
      'charge': charge,
      'payable': payable,
      'exchange_rate': exchangeRate,
      'status': payStatus,
    };
  }
}

class StatusLog {
  StatusLog({
    required this.note,
    required this.statusInt,
    required this.date,
  });

  factory StatusLog.fromMap(Map<String, dynamic> map) {
    return StatusLog(
      note: map['delivery_note'] ?? '',
      statusInt: map['delivery_status'] ?? 0,
      date: DateTime.parse(map['created_at']),
    );
  }

  final DateTime date;
  final String note;
  final int statusInt;

  OrderStatus get orderStatus => OrderStatus.fromInt(statusInt);

  Map<String, dynamic> toMap() {
    return {
      'delivery_note': note,
      'delivery_status': statusInt,
      'created_at': date.toIso8601String(),
    };
  }
}
