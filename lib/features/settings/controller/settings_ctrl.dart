import 'dart:async';


import 'package:seller_management/features/settings/repository/settings_repo.dart';
import 'package:seller_management/main.export.dart';
import '../../auth/controller/auth_ctrl.dart';
import 'auth_config_ctrl.dart';

final settingsCtrlProvider =
    AsyncNotifierProvider<SettingsCtrlNotifier, AppSettings>(
        SettingsCtrlNotifier.new);

class SettingsCtrlNotifier extends AsyncNotifier<AppSettings> {

  final _repo = locate<SettingsRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<AppSettings> _init() async {
    print("we are now in the settingsCtrlProvider");
    final settings = await _repo.getApiSettings();
    return settings.fold(
      (l) => l.toFError(),
      (r) {
        ref.read(localSettingsProvider.notifier).save(r.data);
        if (ref.read(authCtrlProvider)) {
          ref.watch(authConfigCtrlProvider);
        }

        return r.data;
      },
    );
  }

  @override
  FutureOr<AppSettings> build() {
    return _init();
  }

}

final localSettingsProvider =
    AutoDisposeNotifierProvider<_LocalSettingsNotifier, AppSettings?>(
        _LocalSettingsNotifier.new);

class _LocalSettingsNotifier extends AutoDisposeNotifier<AppSettings?> {
  @override
  AppSettings? build() {
    return locate<SettingsRepo>().getAppSettingsSync();
  }

  Future<void> save(AppSettings settings) async {
    await locate<SettingsRepo>().saveSettings(settings);
    ref.invalidateSelf();
  }
}
