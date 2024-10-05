import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../controller/ticket_ctrl.dart';
import 'local/local.dart';

class TicketListView extends HookConsumerWidget {
  const TicketListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketList = ref.watch(ticketListCtrlProvider);
    final ticketListCtrl =
        useCallback(() => ref.read(ticketListCtrlProvider.notifier));
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.massage.tr()),
        backgroundColor: context.colorTheme.background,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => RouteNames.createTicket.pushNamed(context),
            child: Text(
              '+ ${LocaleKeys.create_ticket.tr()}',
            ),
          ),
        ],
      ),
      body: ticketList.when(
        error: (error, stackTrace) => ErrorView(error, stackTrace),
        loading: () => ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: KShimmer.card(
              height: 100,
            ),
          ),
        ),
        data: (ticketList) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(ticketListCtrlProvider),
          child: ListViewWithFooter(
            itemCount: ticketList.length,
            pagination: ticketList.pagination,
            onNext: (url) => ticketListCtrl().listByUrl(url),
            onPrevious: (url) => ticketListCtrl().listByUrl(url),
            itemBuilder: (context, index) => TicketListCard(
              ticket: ticketList[index],
            ),
          ),
        ),
      ),
    );
  }
}
