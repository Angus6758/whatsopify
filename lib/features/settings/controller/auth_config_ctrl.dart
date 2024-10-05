import 'dart:async';

import 'package:seller_management/features/settings/repository/settings_repo.dart';
import 'package:seller_management/main.export.dart';

final authConfigCtrlProvider =
    AsyncNotifierProvider<AuthConfigCtrlNotifier, AuthConfig>(
        AuthConfigCtrlNotifier.new);

class AuthConfigCtrlNotifier extends AsyncNotifier<AuthConfig> {
  final _repo = locate<SettingsRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<AuthConfig> _init() async {
    final settings = await _repo.getAuthConfig();
    return await settings.fold(
      (l) => l.toFError(),
      (r) async {
        await ref.read(localAuthConfigProvider.notifier).save(r.data);
        return r.data;
      },
    );
  }

  @override
  FutureOr<AuthConfig> build() {
    return _init();
  }
}

final localAuthConfigProvider =
    AutoDisposeNotifierProvider<_LocalAuthConfigNotifier, AuthConfig?>(
        _LocalAuthConfigNotifier.new);

class _LocalAuthConfigNotifier extends AutoDisposeNotifier<AuthConfig?> {
  @override
  AuthConfig? build() {
    final res = locate<SettingsRepo>().getAuthConfigSync();
    return res;
  }

  Future<void> save(AuthConfig settings) async {
    await locate<SettingsRepo>().saveAuthConfig(settings);
    ref.invalidateSelf();
  }
}
