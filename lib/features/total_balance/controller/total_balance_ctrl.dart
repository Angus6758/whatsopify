import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seller_management/features/total_balance/repository/total_balance_repo.dart';
import 'package:seller_management/main.export.dart';

final transactionCtrlProvider = AutoDisposeAsyncNotifierProvider<
    TransactionCtrlNotifier,
    PagedItem<TransactionData>>(TransactionCtrlNotifier.new);

class TransactionCtrlNotifier
    extends AutoDisposeAsyncNotifier<PagedItem<TransactionData>> {
  final _repo = locate<TransactionRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> filter({DateTimeRange? dateRange, String? search}) async {
    final data =
        await _repo.transactionList(dateRange: dateRange, search: search ?? '');

    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> listByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.transactionListFromUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<TransactionData>> build() async {
    final data = await _repo.transactionList();

    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}
