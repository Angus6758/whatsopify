
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';
import 'package:seller_management/features/product/view/user_content/user_dash_model.dart';

import '../../../../../_core/strings/endpoints.dart';

final userDashRepoProvider = Provider<UserDashRepo>((ref) {
  return UserDashRepo(ref);
});

class UserDashRepo {
  UserDashRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<UserDashModel>> getUserDash() async {
    try {
      final response = await _dio.get(Endpoints1.dashboard);
      print("User Dash Response: ${response.data}"); // Log API response
      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserDashModel.fromMap(map),
      );

      return right(res);
    } on DioException catch (e, s) {
      print("DioException: ${e.message}"); // Log Dio error
      final failure = DioExp(e).toFailure(s);
      return left(failure);
    } catch (e, s) {
      print("General Exception: ${e.toString()}"); // Log general error
      return left(Failure(e.toString(), stackTrace: s));
    }
  }

  FutureEither<ApiResponse<UserDashModel>> dashFromUrl(String url) async {
    try {
      final response = await _dio.get(url);
      print("User Dash Response: dashFromUrl ${response.data}"); // Log API response
      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserDashModel.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
