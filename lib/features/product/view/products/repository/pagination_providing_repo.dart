
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/base/home_response_data.dart';
import 'package:seller_management/features/product/view/base/item_list_with_page_data.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';


final paginationProvidingRepoProvider =
    Provider<PaginationProvidingRepo>((ref) {
  return PaginationProvidingRepo(ref);
});

class PaginationProvidingRepo {
  PaginationProvidingRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<ItemListWithPageData<ProductsData>>>
      paginatedProductFromUrl(String pageUrl) async {
    try {
      final response = await _dio.get(pageUrl);

      final result = ApiResponse.fromMap(
        response.data,
        (json) => ItemListWithPageData.fromMap(
          json['products'],
          (json) => ProductsData.fromMap(json),
        ),
      );

      return right(result);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<HomeResponseData>> pageFromHome(
    String url,
  ) async {
    try {
      final response = await _dio.get(url);

      final homeRes = ApiResponse.fromMap(
        response.data,
        (json) => HomeResponseData.fromMap(json),
      );

      return right(homeRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
