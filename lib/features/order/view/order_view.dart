import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/order/controller/order_ctrl.dart';
import 'package:seller_management/main.export.dart';

import 'local/physical_order_tab.dart';

class OrderView extends HookConsumerWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initTab = context.queryParams.parseInt('tab');
    final subTab = context.queryParams.parseInt('sub');
    final tabController =
        useTabController(initialLength: 2, initialIndex: initTab);

    final orderCtrl = useCallback(
      () => ref.read(physicalOrderCtrlProvider('').notifier),
    );
    final digitalCtrl = useCallback(
      () => ref.read(digitalOrderCtrlProvider.notifier),
    );
    final searchCtrl = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.isDark
            ?  Color.fromARGB(0, 0, 0, 0)
            : Color.fromARGB(0, 0, 0, 0),
        title: Text(
          LocaleKeys.manage_order.tr(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40 + kToolbarHeight),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    fillColor:  Color.fromARGB(0, 0, 0, 0),
                    hintText: LocaleKeys.search_via_order_id_customer_name.tr(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchCtrl.clear();
                        if (tabController.index == 0) {
                          digitalCtrl().reload();
                        } else {
                          orderCtrl().reload();
                        }
                      },
                      icon: const Icon(Icons.clear_rounded),
                    ),
                  ),
                  onChanged: (value) {
                    if (tabController.index == 0) {
                      orderCtrl().search(value);
                    } else {
                      digitalCtrl().search(value);
                    }
                  },
                ),
              ),
              TabBar(
                controller: tabController,
                tabs: [
                  Tab(text: LocaleKeys.physical_order.tr()),
                  Tab(text: LocaleKeys.digital_order.tr()),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          PhysicalOrderTab(tabIndex: subTab),
          const OrderListView(tab: 'digital'),
        ],
      ),
    );
  }
}
