import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/features/order/controller/order_ctrl.dart';
import 'package:seller_management/features/settings/controller/settings_ctrl.dart';
import 'package:seller_management/main.export.dart';

import 'order_card.dart';

class PhysicalOrderTab extends HookConsumerWidget {
  const PhysicalOrderTab({
    super.key,
    required this.tabIndex,
  });
  final int tabIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(localSettingsProvider);

    if (settings == null) return const ErrorView('Settings not found', null);

    final tabs =
        settings.config.deliveryStatus.enumData.keys.map((e) => e).toList();

    return DefaultTabController(
      length: tabs.length + 1,
      initialIndex: tabIndex,
      child: Column(
        children: [
          ButtonsTabBar(
            backgroundColor: context.isDark
                ? context.colorTheme.onSurface
                : context.colorTheme.primary,
            unselectedBackgroundColor:
                context.colorTheme.onSurface.withOpacity(.05),
            unselectedLabelStyle:
                TextStyle(color: context.colorTheme.onSurface),
            labelStyle: TextStyle(
              color: context.colorTheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            tabs: [
              const Tab(
                text: 'All Order',
              ),
              ...tabs.map((e) => Tab(text: e.toTitleCase)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                const OrderListView(tab: ''),
                ...tabs.map((e) => OrderListView(tab: e)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderListView extends HookConsumerWidget {
  const OrderListView({
    super.key,
    required this.tab,
  });

  final String tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDigital = tab == 'digital';

    final orderList = isDigital
        ? ref.watch(digitalOrderCtrlProvider)
        : ref.watch(physicalOrderCtrlProvider(tab));

    final orderCtrl = useCallback(
      () => ref.read(physicalOrderCtrlProvider(tab).notifier),
    );
    final digitalCtrl = useCallback(
      () => ref.read(digitalOrderCtrlProvider.notifier),
    );

    return orderList.when(
      loading: () => Loader.list(5, 120),
      error: ErrorView.new,
      data: (orders) {
        return RefreshIndicator(
          onRefresh: () async {
            if (isDigital) {
              digitalCtrl().reload();
            } else {
              orderCtrl().reload();
            }
          },
          child: ListViewWithFooter(
            itemCount: orders.length,
            pagination: orders.pagination,
            onNext: (url) {
              if (isDigital) {
                digitalCtrl().orderByUrl(url);
              } else {
                orderCtrl().orderByUrl(url);
              }
            },
            onPrevious: (url) {
              if (isDigital) {
                digitalCtrl().orderByUrl(url);
              } else {
                orderCtrl().orderByUrl(url);
              }
            },
            itemBuilder: (context, index) {
              final order = orders[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: OrderCard(orderInfo: order),
              );
            },
          ),
        );
      },
    );
  }
}
