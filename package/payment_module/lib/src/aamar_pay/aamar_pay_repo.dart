import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:payment_module/src/aamar_pay/aamar_pay.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AamarPayRepo {
  AamarPayRepo({
    required this.config,
  });
  final AamarPayConfig config;

  final _dio = Dio()..interceptors.add(PrettyDioLogger());

  String get endPoint => config.isSandBox
      ? 'https://sandbox.aamarpay.com'
      : 'https://secure.aamarpay.com';

  final cancelUrl = 'https://cartuser.com/payment/cancel';
  final successUrl = 'https://cartuser.com/payment/confirm';
  final failUrl = 'https://cartuser.com/payment/fail';

  Future<String> getPaymentUrl() async {
    try {
      final response = await _dio.post(
        '$endPoint/jsonpost.php',
        data: {
          'store_id': config.storeID,
          'tran_id': config.isSandBox
              ? DateTime.now().microsecondsSinceEpoch.toString()
              : config.transactionId,
          'success_url': successUrl,
          'fail_url': failUrl,
          'cancel_url': cancelUrl,
          'amount': config.amount,
          'currency': 'BDT',
          'signature_key': config.signature,
          'desc': config.description ?? 'Empty',
          'cus_name': config.name ?? 'Customer name',
          'cus_email': config.email,
          'cus_add1': config.address1 ?? 'Dhaka',
          'cus_add2': config.address2 ?? 'Dhaka',
          'cus_city': config.city ?? 'Dhaka',
          'cus_state': config.state ?? 'Dhaka',
          'cus_postcode': config.postCode ?? '0',
          'cus_country': 'Bangladesh',
          'cus_phone': config.mobile,
          'type': 'json',
        },
      );

      final data =
          json.decode(response.data.toString()) as Map<String, dynamic>;

      final url = data['payment_url'];
      if (url == null) {
        throw Exception(data.values.firstOrNull ?? 'Something went wrong');
      }

      return url.toString();
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
