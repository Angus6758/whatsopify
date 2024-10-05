import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/product_details_response.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/products/repository/products_repo.dart';

typedef ProductCtrlParam = ({String uid, String? campaignId, bool isRegular});

final productCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    ProductsCtrlNotifier,
    ProductDetailsResponse,
    ProductCtrlParam>(ProductsCtrlNotifier.new);

class ProductsCtrlNotifier extends AutoDisposeFamilyAsyncNotifier<
    ProductDetailsResponse, ProductCtrlParam> {
  FutureOr<ProductDetailsResponse> _init() async {
    final res = await _repo.getProductDetails(
      uid: arg.uid,
      campaignId: arg.campaignId,
      isRegular: arg.isRegular,
    );
talk.debug("resisgettingnulldat ${arg.campaignId.toString()}");
talk.debug("resisgettingnulldata $res");
    return res.fold((l) => Future.error(l, l.stackTrace), (r) => r.data);
  }

  ProductsRepo get _repo => ref.watch(productsRepoProvider);

  silentReload() async {
    state = AsyncValue.data(await _init());
  }

  @override
  Future<ProductDetailsResponse> build(ProductCtrlParam arg) async {
    return await _init();
  }
}
