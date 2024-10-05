import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class WithdrawData {
  const WithdrawData({
    required this.id,
    required this.trxNo,
    required this.method,
    required this.currency,
    required this.amount,
    required this.charge,
    required this.rate,
    required this.finalAmount,
    required this.statuesCode,
    required this.statuesEnum,
    required this.feedback,
    required this.date,
    required this.rawDate,
    required this.readableTime,
  });

  factory WithdrawData.fromMap(Map<String, dynamic> map) {
    return WithdrawData(
      id: map['id']?.toInt() ?? 0,
      trxNo: map['trx_number'] ?? '',
      method: WithdrawMethod.fromMap(map['method']),
      currency: Currency.fromMap(map['currency']),
      amount: map['amount'] ?? 0,
      charge: map['charge'] ?? 0,
      rate: map['rate'] ?? 0,
      finalAmount: map['final_amount'] ?? 0,
      statuesCode: map['status']?.toInt() ?? 0,
      statuesEnum: JEnum.fromMap(map['status_enum']),
      feedback: map['feedback'] ?? '',
      date: map['date_time'] ?? '',
      rawDate: DateTime.parse(map['created_at']),
      readableTime: map['human_readable_time'] ?? '',
    );
  }

  final num amount;
  final num charge;
  final Currency currency;
  final String feedback;
  final num finalAmount;
  final int id;
  final WithdrawMethod method;
  final num rate;
  final int statuesCode;
  final JEnum statuesEnum;
  final String trxNo;
  final String readableTime;
  final String date;
  final DateTime rawDate;

  String get status => statuesEnum[statuesCode];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trx_number': trxNo,
      'method': method.toMap(),
      'currency': currency.toMap(),
      'amount': amount,
      'charge': charge,
      'rate': rate,
      'final_amount': finalAmount,
      'status': statuesCode,
      'status_enum': statuesEnum.enumData,
      'feedback': feedback,
      'date_time': date,
      'human_readable_time': readableTime,
      'created_at': rawDate.toIso8601String(),
    };
  }

  Color get statusColor {
    final color = switch (statuesCode) {
      0 => Colors.blue,
      1 => Colors.green,
      2 => Colors.orange,
      3 => Colors.red,
      _ => Colors.blue,
    };
    return color;
  }
}
