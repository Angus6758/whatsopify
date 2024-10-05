
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/settings/config_model.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../locator.dart';

final settingsProvider = Provider<ConfigModel?>((ref) {
  final pref = locate<SharedPreferences>();
  print("we are now in the settingsProvider");
  final data = pref.getString(CachedKeys.config);

  if (data == null) {
    print("data is null from setting");
    return null;
  }

  return ConfigModel.fromJson(data);
});
