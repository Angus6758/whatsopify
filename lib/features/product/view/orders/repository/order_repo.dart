
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';
import 'package:seller_management/features/product/view/user_content/order_model.dart';

final orderRepoProvider = Provider<OrderRepo>((ref) {
  return OrderRepo(ref);
});

class OrderRepo {
  OrderRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<OrderModel>> getOrderDetails({
    required String orderId,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.orderTrack,
        data: {'order_id': orderId},
      );

      final res = ApiResponse.fromMap(
        response.data,
        (map) => OrderModel.fromMap(map['order']),
      );
      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<PaymentLog>> getPaymentLog(String trx) async {
    try {
      final response = await _dio.get(Endpoints.paymentLog(trx));

      final res = ApiResponse.fromMap(
        response.data,
        (map) => PaymentLog.fromMap(map['payment_log']),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
