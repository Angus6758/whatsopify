import 'package:flutter/material.dart';
import 'package:seller_management/_core/extensions/helper_extension.dart';

class GraphData {
  const GraphData({
    required this.monthlyOrderReport,
    required this.yearlyOrderReport,
  });

  factory GraphData.fromMap(Map<String, dynamic> map) {
    final monthlyReport =
        Map<String, int?>.from(map['monthly_order_report']).nonNull();

    return GraphData(
      monthlyOrderReport: Map<String, int>.from(monthlyReport),
      yearlyOrderReport: Map<String, YearlyData>.from(
        map['yearly_order_report']
            ?.map((key, value) => MapEntry(key, YearlyData.fromMap(value))),
      ),
    );
  }

  final Map<String, int> monthlyOrderReport;
  final Map<String, YearlyData> yearlyOrderReport;

  Map<String, dynamic> toMap() {
    return {
      'monthly_order_report': monthlyOrderReport,
      'yearly_order_report': yearlyOrderReport,
    };
  }

  static Color color(String name) {
    final color = switch (name.toLowerCase()) {
      'placed' => Colors.green,
      'confirmed' => Colors.pink,
      'processing' => Colors.cyan,
      'shipped' => Colors.purple,
      'delivered' => Colors.yellow,
      'cancel' => Colors.red,
      _ => Colors.red,
    };

    return color;
  }
}

class YearlyData {
  YearlyData({
    required this.total,
    required this.digital,
    required this.physical,
  });

  factory YearlyData.fromMap(Map<String, dynamic> map) {
    return YearlyData(
      total: map['total']?.toInt() ?? 0,
      digital: map['digital']?.toInt() ?? 0,
      physical: map['physical']?.toInt() ?? 0,
    );
  }

  int digital;
  int physical;
  int total;

  static Color get digitalColor => Colors.green;
  static Color get physicalColor => Colors.orange;
  static Color get totalColor => Colors.blue;

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'digital': digital,
      'physical': physical,
    };
  }
}
