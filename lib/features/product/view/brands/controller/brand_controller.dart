
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/brands/repository/brand_repository.dart';
import 'package:seller_management/features/product/view/content/brand_models.dart';

final brandCtrlProvider =
    AsyncNotifierProviderFamily<BrandCtrlNotifier, BrandProducts, String>(
        BrandCtrlNotifier.new);

class BrandCtrlNotifier extends FamilyAsyncNotifier<BrandProducts, String> {
  BrandRepository get _repo => ref.watch(brandRepositoryProvider);

  @override
  Future<BrandProducts> build(String arg) async {
    return await init();
  }

  Future<BrandProducts> init() async {
    final res = await _repo.getBrandProducts(arg);

    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => r.data,
    );
  }

  reload() async {
    state = await AsyncValue.guard(() async => await init());
  }
}
