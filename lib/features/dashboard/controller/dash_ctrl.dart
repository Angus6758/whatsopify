import 'dart:async';

import 'package:seller_management/features/settings/controller/settings_ctrl.dart';
import 'package:seller_management/main.export.dart';

import '../repository/dash_repo.dart';

final dashBoardCtrlProvider =
    AutoDisposeAsyncNotifierProvider<DashBoardCtrlNotifier, Dashboard>(
        DashBoardCtrlNotifier.new);

class DashBoardCtrlNotifier extends AutoDisposeAsyncNotifier<Dashboard> {
  final _repo = locate<DashboardRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
    ref.invalidate(settingsCtrlProvider);
  }

  @override
  FutureOr<Dashboard> build() async {
    final data = await _repo.getDashboard();
    return data.fold(
      (l) => l.toFError(),
      (r) => r.data,
    );
  }
}
