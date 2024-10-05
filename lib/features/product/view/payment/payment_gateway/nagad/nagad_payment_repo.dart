import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/crypto/encrypter.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/payment_credentials/nagad/confirm_payment.dart';
import 'package:seller_management/features/product/view/payment_credentials/nagad/init_payment.dart';
import 'package:seller_management/features/product/view/payment_credentials/nagad/nagad_credentials.dart';
import 'package:seller_management/features/product/view/payment_credentials/nagad/verify_payment.dart';

final nagadRepoProvider =
    Provider.family<NagadPaymentRepo, NagadCredentials>((ref, cred) {
  return NagadPaymentRepo(cred);
});

class NagadPaymentRepo {
  NagadPaymentRepo(this._cred) {
    _init();
  }

  final NagadCredentials _cred;
  final _dio = Dio();
  final _encrypter = KEncrypter();

  _init() async {
    _dio.interceptors.add(talk.dioLogger);
    _dio.interceptors.add(_interceptorsWrapper());
  }

  FutureEither<NagadInitDecryptedData> initializePayment(
    String trxId,
    NagadInitPaymentBody requestBody,
  ) async {
    try {
      final response = await _dio.post(
        _initializeUrl(trxId),
        data: requestBody.toMap(),
      );

      final sensitive = response.data['sensitiveData'];
      final signature = response.data['signature'];
      final decrypted =
          _encrypter.decryptWithPrivateKey(sensitive, _cred.privateKey);

      final isSignVerified =
          _encrypter.verifySignature(decrypted, signature, _cred.publicKey);

      // if (!isSignVerified) {
      //   return left(const Failure('signature verification failed'));
      // }

      final data = NagadInitDecryptedData.fromJson(decrypted);

      return right(data as NagadInitDecryptedData);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<String> confirmPayment(
    String refId,
    NagadConfirmPaymentBody requestBody,
  ) async {
    try {
      final response = await _dio.post(
        _completeUrl(refId),
        data: requestBody.toMap(),
      );

      final data = response.data;

      return right(data['callBackUrl']);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  @Deprecated('verify on server side')
  FutureEither<NagadVerifyPaymentData> verifyPayment(String referenceId) async {
    try {
      final response = await _dio.get(_verifyUrl(referenceId));

      final data = NagadVerifyPaymentData.fromJson(response.data);

      return right(data);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  // URLS

  String get _baseUrl => _cred.isSandbox
      ? 'http://sandbox.mynagad.com:10080/remote-payment-gateway-1.0/api/dfs'
      : 'https://api.mynagad.com/api/dfs';

  String _initializeUrl(String orderId) =>
      '$_baseUrl/check-out/initialize/${_cred.merchantId}/$orderId';

  String _completeUrl(String paymentReferenceId) =>
      '$_baseUrl/check-out/complete/$paymentReferenceId';

  String _verifyUrl(String paymentReferenceId) =>
      '$_baseUrl/verify/payment/$paymentReferenceId';

  Future<Map<String, String>> _headers() async {
    return {
      'Content-Type': 'application/json',
      'X-KM-Api-Version': 'v-0.2.0',
      'X-KM-IP-V4': await _getDeviceP(),
      'X-KM-Client-Type': 'MOBILE_APP',
    };
  }

  Future<String> _getDeviceP() async {
    final interfaces = await io.NetworkInterface.list();
    return interfaces.firstOrNull?.addresses.firstOrNull?.address ?? '';
  }

  _interceptorsWrapper() => InterceptorsWrapper(
        onRequest: (options, handler) async {
          final headers = await _headers();
          options.headers.addAll(headers);
          return handler.next(options);
        },
      );
}
