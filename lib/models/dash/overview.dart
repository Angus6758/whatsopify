class Overview {
  Overview({
    required this.physicalProduct,
    required this.digitalProduct,
    required this.totalWithdrawAmount,
    required this.totalTicket,
    required this.digitalOrder,
    required this.physicalOrder,
    required this.placedOrder,
    required this.shippedOrder,
    required this.cancelOrder,
    required this.deliveredOrder,
  });

  factory Overview.fromMap(Map<String, Object?> json) {
    return Overview(
      physicalProduct: json['total_physical_product'] as int,
      digitalProduct: json['total_digital_product'] as int,
      totalWithdrawAmount: json['total_withdraw_amount'] as int,
      totalTicket: json['total_ticket'] as int,
      digitalOrder: json['total_digital_order'] as int,
      physicalOrder: json['total_physical_order'] as int,
      placedOrder: json['total_placed_order'] as int,
      shippedOrder: json['total_shipped_order'] as int,
      cancelOrder: json['total_cancel_order'] as int,
      deliveredOrder: json['total_delivered_order'] as int,
    );
  }

  final int cancelOrder;
  final int deliveredOrder;
  final int digitalOrder;
  final int digitalProduct;
  final int physicalOrder;
  final int physicalProduct;
  final int placedOrder;
  final int shippedOrder;
  final int totalTicket;
  final int totalWithdrawAmount;

  double get cancelOrderRate =>
      placedOrder == 0 ? 0 : (cancelOrder / placedOrder) * 100;

  double get deliveredOrderRate =>
      placedOrder == 0 ? 0 : (deliveredOrder / placedOrder) * 100;

  double get digitalOrderRate =>
      placedOrder == 0 ? 0 : (digitalOrder / placedOrder) * 100;

  double get physicalOrderRate =>
      placedOrder == 0 ? 0 : (physicalOrder / placedOrder) * 100;

  double get shippedOrderRate =>
      placedOrder == 0 ? 0 : (shippedOrder / placedOrder) * 100;

  Map<String, dynamic> toMap() {
    return {
      'total_physical_product': physicalProduct,
      'total_digital_product': digitalProduct,
      'total_withdraw_amount': totalWithdrawAmount,
      'total_ticket': totalTicket,
      'total_digital_order': digitalOrder,
      'total_physical_order': physicalOrder,
      'total_placed_order': placedOrder,
      'total_shipped_order': shippedOrder,
      'total_cancel_order': cancelOrder,
      'total_delivered_order': deliveredOrder,
    };
  }
}
