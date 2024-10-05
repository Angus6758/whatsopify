import 'package:dio/dio.dart';
import 'package:seller_management/_core/common/failure.dart';
import 'package:seller_management/_core/strings/app_const.dart';

class DioExp implements Exception {
  final DioException exception;

  DioExp(this.exception);

  Failure toFailure(StackTrace? st) {
    final code = exception.response?.statusCode;

    return _handleError(code, exception.response?.data)
        .copyWith(stackTrace: st, error: exception.error);
  }
}

Failure _badResponseParser(Map<String, dynamic>? error) {
  final errMsg = error?['message'];
  final errors = error?['data']?['errors'] as List?;
  final m = error?['data']?['message'];
  final massage = errors?.firstOrNull ?? m ?? errMsg;
  final fail = Failure(massage ?? kErrorMessage('bad response'), error: error);

  return fail;
}

Failure _handleError(int? statusCode, dynamic error) {
  Failure failure = Failure(kErrorMessage('handleError'));
  switch (statusCode) {
    case 500:
      failure = failure.copyWith(message: 'INTERNAL SERVER ERROR');
    case 501:
      failure = failure.copyWith(message: 'NOT IMPLEMENTED');
    case 502:
      failure = failure.copyWith(message: 'BAD GATEWAY');
    case 503:
      failure = failure.copyWith(message: 'SERVICE UNAVAILABLE');
    case 504:
      failure = failure.copyWith(message: 'GATEWAY TIMEOUT');
    case 505:
      failure = failure.copyWith(message: 'HTTP VERSION NOT SUPPORTED');
    case 506:
      failure = failure.copyWith(message: 'VARIANT ALSO NEGOTIATES');
    case 507:
      failure = failure.copyWith(message: 'INSUFFICIENT STORAGE');
    case 508:
      failure = failure.copyWith(message: 'LOOP DETECTED');
    case 509:
      failure = failure.copyWith(message: 'BANDWIDTH LIMIT EXCEEDED');
    case 510:
      failure = failure.copyWith(message: 'NOT EXTENDED');
    case 511:
      failure = failure.copyWith(message: 'NETWORK AUTHENTICATION REQUIRED');
    case 598:
      failure = failure.copyWith(message: 'NETWORK READ TIMEOUT ERROR');
    case 599:
      failure = failure.copyWith(message: 'NETWORK CONNECT TIMEOUT ERROR');

    default:
      failure = _badResponseParser(error);
  }

  return failure;
}
