
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/base/item_list_with_page_data.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';

final searchRepoProvider = Provider<SearchRepo>((ref) => SearchRepo(ref));

class SearchRepo {
  SearchRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<ItemListWithPageData<ProductsData>>> searchProduct(
    String name,
  ) async {
    try {
      final response = await _dio.get(Endpoints.searchProduct(name));

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

  DioClient get _dio => DioClient(_ref);
}
