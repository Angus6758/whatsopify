
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/misc/post_message.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';

final reviewRepoProvider = Provider<ReviewRepo>((ref) => ReviewRepo(ref));

class ReviewRepo {
  ReviewRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<PostMessage>> submitReview(
      Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(Endpoints.review, data: data);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => PostMessage.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();

      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
