import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:seller_management/main.export.dart';

class OrderModel {
  const OrderModel({
    required this.id,
    required this.uid,
    required this.orderStatus,
    required this.type,
    required this.typeFlag,
    required this.orderId,
    required this.quantity,
    required this.readableTime,
    required this.date,
    required this.customer,
    required this.billing,
    required this.totalProduct,
    required this.orderAmount,
    required this.originalAmount,
    required this.totalTax,
    required this.shippingCharge,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.paymentVia,
    required this.discount,
    required this.shipping,
    required this.details,
    required this.paymentDetails,
    required this.invoiceLogo,
    required this.deliveryManFee,
  });

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
     id: map.parseInt('id'),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      type: map['type'],
      typeFlag: map.parseInt('type_flag'),
      orderId: map['order_id'],
      quantity: map.parseInt('quantity'),
      readableTime: map['human_readable_time'] ?? '',
      date: map['date_time'] ?? '',
      customer: Customer.fromMap(map['customer_info']),
      billing: _parseBilling(map),
      totalProduct: map.parseInt('total_product'),
      orderAmount: map.parseNum('order_amount'),
      originalAmount: map.parseNum('original_amount'),
      totalTax: map.parseNum('total_taxes'),
      shippingCharge: map.parseNum('shipping_charge'),
      paymentStatus: map['payment_status'] ?? '',
      deliveryStatus: map['delevary_status'] ?? '',
      paymentVia: map['payment_via'] ?? '',
      deliveryManFee: map.parseNum('delivery_man_fee'),
      discount: map.parseNum('discount'),
      shipping: ShippingInfo.fromMap(map['shipping_info']),
      details: List<OrderDetails>.from(
          map['order_details']?['data']?.map((e) => OrderDetails.fromMap(e)) ??
              []),
      orderStatus: List<OrderStatus>.from(
        map['order_status']?['data']?.map((e) => OrderStatus.fromMap(e)) ?? [],
      ),
      paymentDetails: (map['payment_details'] is Map<String, String>)
          ? map['payment_details']
          : {},
      invoiceLogo: map['invoice_logo'],
    );
  }

  static BillingInfo? _parseBilling(dynamic map) {
    final info = map['billing_address'];
    final address = map['new_billing_address'];

    if (address is Map<String, dynamic>) {
      final it = BillingAddress.fromMap(address);
      return BillingInfo.fromAddress(it);
    }
    if (info is Map<String, dynamic>) {
      return BillingInfo.fromMap(info);
    }

    return null;
  }

  bool get isDigital => typeFlag == 101;
  bool get isPhysical => typeFlag == 102;
  num get subtotal => details.map((e) => e.total).sum;
  num get finalAmount => orderAmount + shippingCharge;

  final BillingInfo? billing;
  final Customer? customer;
  final List<OrderStatus> orderStatus;
  final String date;
  final String deliveryStatus;
  final List<OrderDetails> details;
  final int id;
  final num orderAmount;
  final num originalAmount;
  final String orderId;
  final String paymentStatus;
  final String paymentVia;
  final int quantity;
  final String readableTime;
  final ShippingInfo? shipping;
  final num shippingCharge;
  final int totalProduct;
  final String type;
  final int typeFlag;
  final String uid;
  final String? invoiceLogo;
  final Map<String, String> paymentDetails;
  final num deliveryManFee;
  final num totalTax;
  final num discount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'type': type,
      'type_flag': typeFlag,
      'order_id': orderId,
      'quantity': quantity,
      'human_readable_time': readableTime,
      'date_time': date,
      'customer_info': customer?.toMap(),
      'billing_address': billing?.toMap(),
      'payment_details': paymentDetails,
      'total_product': totalProduct,
      'order_amount': orderAmount,
      'original_amount': originalAmount,
      'total_taxes': totalTax,
      'shipping_charge': shippingCharge,
      'payment_status': paymentStatus,
      'invoice_logo': invoiceLogo,
      'delevary_status': deliveryStatus,
      'payment_via': paymentVia,
      'delivery_man_fee': deliveryManFee,
      'order_details': {'data': details.map((e) => e.toMap()).toList()},
      'order_status': {'data': orderStatus.map((e) => e.toMap()).toList()},
      'discount': discount,
      'shipping_info': shipping?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
