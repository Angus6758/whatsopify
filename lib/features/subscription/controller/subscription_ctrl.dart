import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seller_management/features/settings/controller/auth_config_ctrl.dart';
import 'package:seller_management/main.export.dart';

import '../repository/subscription_repo.dart';

final isFirstSubscriptionProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final repo = locate<SubscriptionRepo>();
  final data = await repo.subscriptionList();
  return data.fold(
    (l) => l.toFError(),
    (r) {
      return !r.data.listData
          .map((e) => e.plan.name.toLowerCase())
          .contains('free');
    },
  );
});

final subscriptionPlanProvider = AutoDisposeAsyncNotifierProvider<
    SubscriptionPlanCtrlNotifier,
    List<SubscriptionPlan>>(SubscriptionPlanCtrlNotifier.new);

class SubscriptionPlanCtrlNotifier
    extends AutoDisposeAsyncNotifier<List<SubscriptionPlan>> {
  final _repo = locate<SubscriptionRepo>();

  /// 1 = Renew, 2 = Upgrade, 3 = Subscribe
  Future<void> planAction(String uid, int id, int type) async {
    switch (type) {
      case 1:
        await renewPlan(uid);
      case 2:
        await upgradePlan(id.toString());
      case 3:
        await subscribePlan(id.toString());
      default:
    }
    ref.invalidate(isFirstSubscriptionProvider);
    ref.invalidate(subscriptionListCtrlProvider);
    ref.invalidate(authConfigCtrlProvider);
    ref.invalidateSelf();
  }

  Future<void> renewPlan(String uid) async {
    final data = await _repo.renewPlan(uid.toString());
    data.fold((l) => Toaster.showError(l), (r) => Toaster.showSuccess(r.data));
  }

  Future<void> upgradePlan(String uid) async {
    final data = await _repo.upgradePlan(uid);
    data.fold((l) => Toaster.showError(l), (r) => Toaster.showSuccess(r.data));
  }

  Future<void> subscribePlan(String uid) async {
    final data = await _repo.subscribePlan(uid.toString());
    data.fold((l) => Toaster.showError(l), (r) => Toaster.showSuccess(r.data));
  }

  @override
  FutureOr<List<SubscriptionPlan>> build() async {
    final data = await _repo.subscriptionPlan();
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}

final subscriptionListCtrlProvider = AutoDisposeAsyncNotifierProvider<
    SubscriptionListCtrlNotifier,
    PagedItem<SubscriptionInfo>>(SubscriptionListCtrlNotifier.new);

class SubscriptionListCtrlNotifier
    extends AutoDisposeAsyncNotifier<PagedItem<SubscriptionInfo>> {
  final _repo = locate<SubscriptionRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidate(isFirstSubscriptionProvider);
    ref.invalidateSelf();
  }

  Future<void> filter(DateTimeRange? range) async {
    final data = await _repo.subscriptionList(range);
    state = data.fold((l) => l.toAsyncError(), (r) => AsyncData(r.data));
  }

  Future<void> listByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.subscriptionFromUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<SubscriptionInfo>> build() async {
    final data = await _repo.subscriptionList();
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}
