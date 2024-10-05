
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/item_list_with_page_data.dart';
import 'package:seller_management/features/product/view/common/shared_pref_provider.dart';
import 'package:seller_management/features/product/view/content/store_model.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';

final storeListProvider = Provider<ItemListWithPageData<StoreModel>?>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final stores = pref.getString(CachedKeys.shops);
  if (stores == null) return null;

  return ItemListWithPageData<StoreModel>.fromJson(
    stores,
    (source) => StoreModel.fromJson(source),
  );
});
