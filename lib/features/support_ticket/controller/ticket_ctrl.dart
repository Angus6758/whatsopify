import 'dart:async';

import 'package:seller_management/main.export.dart';

import '../repository/ticket_repository.dart';

final ticketListCtrlProvider = AutoDisposeAsyncNotifierProvider<
    TicketListCtrlNotifier, PagedItem<SupportTicket>>(
  TicketListCtrlNotifier.new,
);

class TicketListCtrlNotifier
    extends AutoDisposeAsyncNotifier<PagedItem<SupportTicket>> {
  final _repo = locate<TicketRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> listByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.getTickets(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<SupportTicket>> build() async {
    final data = await _repo.getTickets();
    return data.fold(
      (l) => l.toFError(),
      (r) => r.data,
    );
  }
}
