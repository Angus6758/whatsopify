
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/shared_pref_provider.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';
import 'package:seller_management/features/product/view/user_content/user_dash_model.dart';

final userDashProvider = Provider<UserDashModel?>((ref) {
  final pref = ref.watch(sharedPrefProvider);

  final data = pref.getString(CachedKeys.userDash);

  if (data == null) return null;

  return UserDashModel.fromJson(data);
});
