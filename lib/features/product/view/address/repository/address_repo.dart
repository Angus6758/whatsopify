
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';
import 'package:seller_management/features/product/view/user_content/user_profile_model.dart';

final addressRepoProvider = Provider<AddressRepo>((ref) {
  return AddressRepo(ref);
});

class AddressRepo {
  AddressRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<UserModel>> createAddress(
    Map<String, dynamic> address,
  ) async {
    try {
      final response = await _dio.post(Endpoints.addressAdd, data: address);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserModel.fromMap(map['user']),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<ApiResponse<UserModel>> deleteAddress(String key) async {
    try {
      final response = await _dio.get(Endpoints.addressDelete(key));
      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserModel.fromMap(map['user']),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<ApiResponse<UserModel>> updateAddress(
    Map<String, dynamic> address,
    int id,
  ) async {
    try {
      final response = await _dio
          .post(Endpoints.addressUpdate, data: {'id': id, ...address});

      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserModel.fromMap(map['user']),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  DioClient get _dio => DioClient(_ref);
}
