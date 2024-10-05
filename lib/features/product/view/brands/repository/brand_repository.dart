
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/_core/strings/endpoints.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/content/brand_models.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';

final brandRepositoryProvider =
    Provider<BrandRepository>((ref) => BrandRepository(ref));

class BrandRepository {
  BrandRepository(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<BrandProducts>> getBrandProducts(String uid) async {
    try {
      final response = await _dio.get(Endpoints.brandProducts(uid));

      final productRes = ApiResponse.fromMap(
        response.data,
        (json) => BrandProducts.fromMap(json),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
