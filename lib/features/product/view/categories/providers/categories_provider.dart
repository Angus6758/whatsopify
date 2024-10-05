
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/shared_pref_provider.dart';
import 'package:seller_management/features/product/view/content/category_models.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';

final categoryListProvider = Provider<List<CategoriesData>>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final data = pref.getStringList(CachedKeys.categories);

  if (data != null) {
    return data.map((e) => CategoriesData.fromJson(e)).toList();
  }
  return [];
});
