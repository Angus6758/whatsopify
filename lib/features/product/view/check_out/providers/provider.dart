
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/common/shared_pref_provider.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';

final checkoutStateProvider = Provider.autoDispose<OrderBaseModel?>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final data = pref.getString(CachedKeys.orderBase);

  if (data != null) return OrderBaseModel.fromJson(data);

  return null;
});
