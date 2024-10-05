
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/content/category_models.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';
final categoryRepoProvider = Provider<CategoryRepo>((ref) => CategoryRepo(ref));

class CategoryRepo {
  CategoryRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<CategoryDetails>> getCategoryProducts(
      String uid) async {
    try {
      final response = await _dio.get(Endpoints.categoryProducts(uid));
      final productRes = ApiResponse.fromMap(
        response.data,
        (json) => CategoryDetails.fromMap(json),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<CategoryDetails>> getCategoryFromUrl(
      String url) async {
    try {
      final response = await _dio.get(url);

      final productRes = ApiResponse.fromMap(
        response.data,
        (json) => CategoryDetails.fromMap(json),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
