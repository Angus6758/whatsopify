
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/misc/post_message.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';

final wishlistRepoProvider = Provider<WishlistRepo>((ref) {
  return WishlistRepo(ref);
});

class WishlistRepo {
  WishlistRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<PostMessage>> addToWishlist(
    String productUid,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.wishlistAdd,
        data: {'product_uid': productUid},
      );
      final authRes = ApiResponse.fromMap(
        response.data,
        (map) => PostMessage.fromMap(map),
      );
      return right(authRes);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<PostMessage>> deleteWishlist(
    String uid,
  ) async {
    try {
      final response = await _dio.post(
        Endpoints.wishlistDelete,
        data: {'uid': uid},
      );
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
}
