import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/settings/controller/settings_ctrl.dart';

import '../../routes/routes.dart';

final serverStatusProvider =
    AutoDisposeNotifierProvider<ServerStatusNotifier, ServerStatus>(
        ServerStatusNotifier.new);

class ServerStatusNotifier extends AutoDisposeNotifier<ServerStatus> {
  void update(int? code) {
    if (code == null) return;

    final status = ServerStatus.fromCode(code);
    if (status == state) return;

    state = status;
  }

  Future<void> retryStatusResolver() async {
    await ref.read(settingsCtrlProvider.notifier).reload();
  }

  @override
  ServerStatus build() {
    ServerStatus status = ServerStatus.active;

    return status;
  }
}

enum ServerStatus {
  active,
  // noInternet,
  maintenance,
  invalidPurchase,
  panelNotActive;

  String? get paths => switch (this) {
        ServerStatus.active => null,
        ServerStatus.maintenance => RouteNames.maintenance.path,
        // ServerStatus.noInternet => RouteNames.noInternet.path,
        ServerStatus.invalidPurchase => RouteNames.invalidPurchase.path,
        ServerStatus.panelNotActive => RouteNames.panelNotActive.path,
      };
  int? get code => switch (this) {
        active => null,
        maintenance => 1000000,
        // noInternet => 0,
        invalidPurchase => 2000000,
        panelNotActive => 3000000,
      };

  factory ServerStatus.fromCode(int? code) => switch (code) {
        // null => ServerStatus.noInternet,
        1000000 => ServerStatus.maintenance,
        2000000 => ServerStatus.invalidPurchase,
        3000000 => ServerStatus.panelNotActive,
        _ => ServerStatus.active,
      };

  bool get isActive => this == ServerStatus.active;
  bool get isMaintenance => this == ServerStatus.maintenance;
  // bool get isNoInternet => this == ServerStatus.noInternet;
  bool get isInvalidPurchase => this == ServerStatus.invalidPurchase;
  bool get isPanelNotActive => this == ServerStatus.panelNotActive;
}
