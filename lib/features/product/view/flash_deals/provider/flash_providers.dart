
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/shared_pref_provider.dart';
import 'package:seller_management/features/product/view/content/flash_deal_model.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';

final flashDealProvider = Provider.autoDispose<FlashDeal?>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final flash = pref.getString(CachedKeys.flash);
  if (flash == null) return null;
  return FlashDeal.fromJson(flash);
});
