
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/shared_pref_provider.dart';
import 'package:seller_management/features/product/view/content/brand_models.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';

final brandListProvider = Provider<List<BrandData>>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final data = pref.getStringList(CachedKeys.brands);

  if (data != null) {
    return data.map((e) => BrandData.fromJson(e)).toList();
  }
  return [];
});
