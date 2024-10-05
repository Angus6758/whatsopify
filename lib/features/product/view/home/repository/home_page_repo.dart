
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/base/home_response_data.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';


final homeRepoProvider = Provider<HomeRepo>((ref) {
  return HomeRepo(ref);
});

class HomeRepo {
  const HomeRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<HomeResponseData>> getStartUpData() async {
    try {
      final response = await _dio.get(Endpoints.home);

      final homeRes = ApiResponse.fromMap(
        response.data,
            (json) => HomeResponseData.fromMap(json),
      );

      return right(homeRes);
    } on DioException catch (e, s) {
      final failure = DioExp(e).toFailure(s);
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
