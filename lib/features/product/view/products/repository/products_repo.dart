
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/base/item_list_with_page_data.dart';
import 'package:seller_management/features/product/view/base/product_details_response.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/state/product_filtering_state.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';

final productsRepoProvider = Provider<ProductsRepo>((ref) => ProductsRepo(ref));

class ProductsRepo {
  ProductsRepo(this._ref);

  DioClient get _dio => DioClient(_ref);
  final Ref _ref;

  FutureEither<ApiResponse<ProductDetailsResponse>> getProductDetails({
    required String uid,
    required String? campaignId,
    required bool isRegular,
  }) async {
    try {
      final endPoint = isRegular
          ? Endpoints.productDetails(uid, campaignId)
          : Endpoints.digitalProductDetails(uid);

      final response = await _dio.get(endPoint);

      final productRes = ApiResponse.fromMap(
        response.data,
            (json) => ProductDetailsResponse.fromMap(json),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<ItemListWithPageData<ProductsData>>> getAllProduct({
    required String query,
    String? brandUid,
    String? categoryUid,
    String? min,
    String? max,
    SortType? sort,
  }) async {
    try {
      final queryParameters = {
        if (query.isNotEmpty) 'name': query,
        'brand_uid': brandUid,
        'category_uid': categoryUid,
        'search_min': min,
        'serach_max': max,
        'sort_by': sort?.queryParam ?? 'default',
      };
      final endPoint =
      Uri(path: '/products', queryParameters: queryParameters).toString();

      final response = await _dio.get(endPoint);

      final productRes = ApiResponse.fromMap(
        response.data,
            (json) => ItemListWithPageData.fromMap(
          json['products'],
              (json) => ProductsData.fromMap(json),
        ),
      );

      return right(productRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
