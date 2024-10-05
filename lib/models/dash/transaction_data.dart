import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class TransactionData {
  TransactionData({
    required this.trxId,
    required this.amount,
    required this.postBalance,
    required this.transactionType,
    required this.details,
    required this.date,
    required this.readableTime,
    required this.rawDate,
  });

  final num amount;
  final String date;
  final String readableTime;
  final DateTime rawDate;
  final String details;
  final num postBalance;
  final String transactionType;
  final String trxId;

  String get formattedAmount => '$transactionType ${amount.formate()}';

  Color get amountColor => switch (transactionType) {
        '+' => Colors.green,
        _ => Colors.red,
      };

  factory TransactionData.fromMap(Map<String, dynamic> map) {
    return TransactionData(
      trxId: map['trx_id'],
      amount: map.parseNum('amount'),
      postBalance: map.parseNum('post_balance'),
      transactionType: map['transaction_type'],
      details: map['details'],
      rawDate: DateTime.parse(map['created_at']),
      date: map['date_time'],
      readableTime: map['human_readable_time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trx_id': trxId,
      'amount': amount,
      'post_balance': postBalance,
      'transaction_type': transactionType,
      'details': details,
      'created_at': date,
    };
  }
}
