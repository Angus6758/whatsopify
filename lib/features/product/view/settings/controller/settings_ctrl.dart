import 'dart:async';


import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/region_settings/controller/region_ctrl.dart';
import 'package:seller_management/features/product/view/region_settings/repository/region_repo.dart';
import 'package:seller_management/features/product/view/settings/config_model.dart';
import 'package:seller_management/features/product/view/settings/repository/settings_repo.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../locator.dart';
import '../provider/settings_provider.dart';

final settingsCtrlProvider =
    AsyncNotifierProvider<SettingsCtrlNotifier, ConfigModel>(
        SettingsCtrlNotifier.new);

class SettingsCtrlNotifier extends AsyncNotifier<ConfigModel> {
  SettingsRepo get _repo => ref.watch(settingsRepoProvider);

  @override
  FutureOr<ConfigModel> build() => _init();

  FutureOr<ConfigModel> _init() async {
    final res = await _repo.getConfig();

    return await res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) async {
        await _setConfigState(r.data);
        final regionRepo = locate<RegionRepoEx1>();
        await regionRepo.setDefLanguage(r.data.defaultLanguage.code);
        ref.invalidate(regionCtrlProvider);

        locate<SharedPreferences>()
            .setBool(PrefKeys.currencyOnLeft, r.data.settings.currencyOnLeft);
        return r.data;
      },
    );
  }

  reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> reloadSilently() async {
    state = await AsyncValue.guard(() async => await _init());
  }

  Future<void> _setConfigState(ConfigModel config) async {
    final pref = locate<SharedPreferences>();
    await pref.setString(CachedKeys.config, config.toJson());

    ref.invalidate(settingsProvider);
  }
}
