import 'package:seller_management/main.export.dart';

typedef FutureResponse<T> = FutureReport<BaseResponse<T>>;

class BaseResponse<T> {
  const BaseResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.locale,
    required this.currency,
    required this.data,
    required this.defCurrency,
  });

  factory BaseResponse.fromMap(QMap map, FromJsonT<T> fromMapT) {
    final status = map['status'];
    final code = map['code'];
    final message = map['message'];
    final locale = map['locale'];
    final currency = Currency.fromMap(map['currency']);
    final defCurrency = Currency.fromMap(map['default_currency']);
    final data = fromMapT(map['data']);

    return BaseResponse(
      status: status,
      code: code,
      message: message,
      locale: locale,
      currency: currency,
      data: data,
      defCurrency: defCurrency,
    );
  }

  final int code;
  final Currency currency;
  final Currency defCurrency;
  final T data;
  final String locale;
  final String message;
  final String status;

  Map<String, dynamic> toMap(QMap Function(T) toMapT) {
    return {
      'status': status,
      'code': code,
      'message': message,
      'locale': locale,
      'currency': currency.toMap(),
      'default_currency': defCurrency.toMap(),
      'data': toMapT(data),
    };
  }
}
