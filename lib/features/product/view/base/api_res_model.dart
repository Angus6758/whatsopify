import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/settings/region_model.dart';

class ApiResponse<T> {
  ApiResponse({
    required this.code,
    required this.currency,
    required this.data,
    required this.locale,
    required this.message,
    required this.status,
  });

  factory ApiResponse.fromJson(
      String source,
      T Function(dynamic source) fromJsonT,
      ) {
    return ApiResponse.fromMap(json.decode(source), fromJsonT);
  }

  factory ApiResponse.fromMap(
      Map<String, dynamic> map,
      T Function(dynamic source) fromJsonT,
      ) {
    return ApiResponse<T>(
      code: intFromAny(map['code']),
      currency: Currency.fromMap(map['currency']),
      data: fromJsonT(map['data']),
      locale: map['locale'] as String,
      message: map['message'] as String,
      status: map['status'] as String,
    );
  }

  final int code;
  final Currency currency;
  final T data;
  final String locale;
  final String message;
  final String status;

  Map<String, dynamic> toMap(Object Function(T) toJsonT) {
    return {
      'code': code,
      'currency': currency,
      'data': toJsonT(data),
      'locale': locale,
      'message': message,
      'status': status,
    };
  }

  String toJson(Object Function(T) toJsonT) => json.encode(toMap(toJsonT));
}
