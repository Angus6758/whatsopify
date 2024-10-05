import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/features/support_ticket/view/ticket_list.dart';
import 'package:seller_management/main.export.dart';

import 'customer_chat_list_view.dart';
import 'local/chat_view_appbar.dart';

class MessagesTabView extends ConsumerWidget {
  const MessagesTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = context.queryParams.parseInt('tab');
    return DefaultTabController(
      length: 2,
      initialIndex: tab,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 80),
          child: ChatViewAppbar(),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: Insets.padH.copyWith(top: 10),
                child: SegmentedTabControl(
                  tabTextColor: context.colorTheme.onSurface,
                  selectedTabTextColor: context.colorTheme.surface,
                  squeezeIntensity: 2,
                  height: 45,
                  tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                  tabs: [
                    SegmentTab(
                      label: 'Customer',
                      color: context.colorTheme.primary,
                    ),
                    SegmentTab(
                      label: 'Admin',
                      color: context.colorTheme.primary,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 65),
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    CustomerChatListView(),
                    TicketListView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
