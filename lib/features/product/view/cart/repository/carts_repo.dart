
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/misc/post_message.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';
import 'package:seller_management/features/product/view/user_content/carts_model.dart';

final cartsRepoProvider = Provider<CartsRepo>((ref) {
  return CartsRepo(ref);
});

class CartsRepo {
  CartsRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<PostMessage>> addToCart({
    required String productUid,
    String? campaignUid,
    String? attribute,
    required int quantity,
  }) async {
    print("Button clicked! Product ID: add to cart method");
    talk.debug('addToCart - Request Data: productUid: $productUid, campaignUid: $campaignUid, attribute: $attribute, quantity: $quantity');
    try {
      final response = await _dio.post(
        Endpoints.cartAdd,
        data: {
          'product_uid': productUid,
          if (campaignUid != null) 'campaign_uid': campaignUid,
          if (attribute != null) 'attribute_combination': attribute,
          'quantity': quantity,
        },
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

  FutureEither<ApiResponse<PostMessage>> deleteCart(
      String uid,
      ) async {
    try {

      final response = await _dio.post(
        Endpoints.cartDelete,
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

  FutureEither<ApiResponse<PostMessage>> updateQuantity({
    required String uid,
    required int quantity,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.cartUpdate,
        data: {
          'uid': uid,
          'quantity': quantity,
        },
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

  FutureEither<String> transferFromGuest(List<CartData> carts) async {
    try {
      for (var cart in carts) {
        final res = await addToCart(
          productUid: cart.product.uid,
          attribute: cart.variant,
          quantity: cart.quantity,
        );
        res.fold(
              (l) => talk.error(l.message, l, l.stackTrace),
              (r) {},
        );
      }

      return right('Carts transferred successfully');
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
