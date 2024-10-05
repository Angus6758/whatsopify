import 'package:flutter/material.dart';
import 'package:seller_management/models/subscription/subscription_plan.dart';

class SubscriptionInfo {
  SubscriptionInfo({
    required this.uid,
    required this.plan,
    required this.totalProduct,
    required this.expiryDate,
    required this.createdDate,
    required this.statusNo,
    required this.statusEnum,
    required this.readableTime,
    required this.date,
  });

  factory SubscriptionInfo.fromMap(Map<String, dynamic> map) {
    return SubscriptionInfo(
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      plan: SubscriptionPlan.fromMap(map['plan']),
      totalProduct: map['total_product']?.toInt() ?? 0,
      expiryDate: map['expired_date'] ?? '',
      createdDate: DateTime.parse(map['creation_date']),
      statusNo: map['status']?.toInt() ?? 0,
      statusEnum: Map<String, int>.from(map['status_enum']),
      readableTime: map['human_readable_time'] ?? '',
      date: map['date_time'] ?? '',
    );
  }

  Color get statusColor {
    final color = switch (statusNo) {
      1 => Colors.blue,
      2 => Colors.red,
      3 => Colors.green,
      4 => Colors.orange,
      _ => Colors.orange,
    };
    return color;
  }

  final DateTime createdDate;
  final String expiryDate;
  final String readableTime;
  final String date;
  final SubscriptionPlan plan;
  final Map<String, int> statusEnum;
  final int statusNo;
  final int totalProduct;
  final String uid;

  String get status {
    final status = statusEnum.entries.firstWhere((x) => x.value == statusNo);

    return status.key;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'plan': plan.toMap(),
      'total_product': totalProduct,
      'expired_date': expiryDate,
      'creation_date': createdDate.toIso8601String(),
      'status': statusNo,
      'status_enum': statusEnum,
      'human_readable_time': readableTime,
      'date_time': date,
    };
  }
}
